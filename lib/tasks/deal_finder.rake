namespace :deals do
  desc 'Extract count recorder info'

  def set_capybara_driver(driver = 'firefox')
    case driver
    when 'chrome'
      Capybara.register_driver :selenium do |app|
        Capybara::Selenium::Driver.new(app, :browser => :chrome)
      end
    else
      Capybara.register_driver :selenium do |app|
        Capybara::Selenium::Driver.new(
          app,
          browser: :firefox,
          desired_capabilities: Selenium::WebDriver::Remote::Capabilities.firefox(marionette: false)
        )
      end
    end
  end

  def setup_session
    @session.driver.browser.quit if @session.present?
    set_capybara_driver(ENV['DRIVER'])
    @session = Capybara::Session.new(:selenium)
    login
    @session.visit 'http://recorder.slco.org/SLCR/Search/DocTypeSearchAdv.aspx'
    sleep_before_next_action
  end

  def filter_address(address)
    address = address.gsub('Mailing Address:', '') if address.include?('Mailing Address:')
    address.strip
  end

  def sleep_before_next_action
    sleep rand(1.0..2.0)
  end

  def login
    @session.visit 'https://recorder.slco.org/SLCR/SLCRLogin.aspx'
    @session.fill_in 'TxtUsername', with: ENV['RECORDER_USERNAME']
    sleep_before_next_action
    @session.fill_in 'TxtPassword', with: ENV['RECORDER_PASSWORD']
    sleep_before_next_action
    @session.click_button 'btnSignIn'
    sleep_before_next_action
  end

  def select_lead_type(lead_type)
    @session.select lead_type, from: "ddlDocType"
    sleep_before_next_action
    @session.choose 'radRecent'
    sleep_before_next_action
    @session.click_button 'btnFindDocTypes'
  end

  def create_leads
    @session.all('#grdDocuments tr').each do |tr|
      tds = tr.all('td')
      lead = Lead.where(entry_number: tds[1].text).first_or_create
      lead.document_type = tds[4].text
      lead.parcel_number = tds[5].text
      lead.filing_date = Date.strptime(tds[8].text, "%m/%d/%Y") rescue nil
      lead.deceased = tds[9].text
      lead.save if lead.changed?
    end
  end

  def create_parcel(lead)
    begin
      parcel = lead.parcel || Parcel.new(lead_id: lead.id)
      raise 'Parcel Number Not Present' unless lead.parcel_number.present?
      @session.visit "http://recorder.slco.org/SLCR/Search/MainfrDocsListAndParcelDataRXPNVTDI_.aspx?ParNum=#{lead.parcel_number}"
      sleep_before_next_action
      @session.click_button 'btnFindParcelData'
      sleep_before_next_action
      parcel.owner = @session.find('#grdOwnersjEsCoOl_tableDiv').text
      parcel.owner_address = filter_address(@session.find('#grdMailingAddressjEsCoOl_mainDiv').text)
      parcel.land_value = @session.find('#lblLandValueVal').text.scan(/\d/).join('')
      parcel.building_value = @session.find('#lblBuildingValueVal').text.scan(/\d/).join('')
      parcel.acres = @session.find('#lblAcresVal').text
      parcel.address = filter_address(@session.find('#lblLocationAddressVal').text)
      parcel.save
      parcel
    rescue Net::ReadTimeout => e
      lead.fail_scrap
      setup_session
      puts e
      return
    rescue => e
      lead.fail_scrape
      puts e
      return
    end
  end

  def create_parcel_entries(lead, parcel)
    result = true
    @session.all('table#grdDocsList tr').each do |tr|
      begin
        tds = tr.all('td')
        parcel_entry = parcel.parcel_entries.where(number: tds[0].text).first_or_create
        parcel_entry.book = tds[1].text
        parcel_entry.page = tds[2].text
        parcel_entry.instrument_type = tds[3].text
        parcel_entry.recorded_date = Date.strptime(tds[4].text, "%m/%d/%Y") rescue nil
        parcel_entry.first_party = tds[5].text
        parcel_entry.second_party = tds[6].text
        parcel_entry.consideration = tds[7].text
        parcel_entry.save
      rescue Net::ReadTimeout => e
        result = false
        lead.fail_scrape
        setup_session
      rescue => e
        result = false
        lead.fail_scrape
        puts e
      end
    end
    result
  end

  def scrape_death_certificates
    setup_session
    select_lead_type('DEATHC')
    create_leads

    Lead.needs_scraping.by_type('DeathCertificateLead').each do |lead|
      parcel = create_parcel(lead)
      result = create_parcel_entries(lead, parcel) if parcel.present?
      lead.complete_scrape if result
    end
  end

  def scrape_ntdf
    setup_session
    select_lead_type('NT DF')
    create_leads

    Lead.needs_scraping.by_type('NoticeOfDefaultLead').each do |lead|
      parcel = create_parcel(lead)
      lead.complete_scrape if parcel.present?
    end
  end

  task all: :environment do |t, args|
    puts 'Scraping Death Certificate Leads'
    scrape_death_certificates
    puts 'Death Certificate Leads: COMPLETE'
    puts 'Scraping Notice of Default Leads'
    scrape_ntdf
    puts 'Notice of Default Leads: COMPLETE'

    puts 'Process: COMPLETE'
  end

  task death: :environment do |t, args|
    scrape_death_certificates
  end

  task ntdf: :environment do |t, args|
    scrape_ntdf
  end
end