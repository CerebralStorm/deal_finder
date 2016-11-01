namespace :deals do
  desc 'Extract count recorder info'

  def sleep_before_next_action
    sleep rand(1.0..2.0)
  end

  def login(session)
    session.visit 'https://recorder.slco.org/SLCR/SLCRLogin.aspx'
    session.fill_in 'TxtUsername', with: ENV['RECORDER_USERNAME']
    sleep_before_next_action
    session.fill_in 'TxtPassword', with: ENV['RECORDER_PASSWORD']
    sleep_before_next_action
    session.click_button 'btnSignIn'
    sleep_before_next_action
  end

  task death: :environment do |t, args|
    # Capybara.register_driver :selenium do |app|
    #   Capybara::Selenium::Driver.new(app, :browser => :chrome)
    # end

    Capybara.register_driver :selenium do |app|
      Capybara::Selenium::Driver.new(
        app,
        browser: :firefox,
        desired_capabilities: Selenium::WebDriver::Remote::Capabilities.firefox(marionette: false)
      )
    end
    session = Capybara::Session.new(:selenium)
    login(session)

    session.visit 'http://recorder.slco.org/SLCR/Search/DocTypeSearchAdv.aspx'
    sleep_before_next_action

    session.select "DEATHC", from: "ddlDocType"
    sleep_before_next_action
    session.choose 'radRecent'
    sleep_before_next_action
    session.click_button 'btnFindDocTypes'

    new_leads = []

    session.all('#grdDocuments tr').each do |tr|
      tds = tr.all('td')
      lead = Lead.where(entry_number: tds[1].text).first_or_create
      lead.document_type = tds[4].text
      lead.parcel_number = tds[5].text
      lead.filing_date = Date.strptime(tds[8].text, "%m/%d/%Y") rescue nil
      lead.deceased = tds[9].text
      new_leads << lead.id if lead.changed? and lead.save
    end

    Lead.where(id: new_leads).each do |lead|
      begin
        parcel = lead.parcel || Parcel.new(lead_id: lead.id)
        next unless lead.parcel_number.present?
        session.visit "http://recorder.slco.org/SLCR/Search/MainfrDocsListAndParcelDataRXPNVTDI_.aspx?ParNum=#{lead.parcel_number}"
        sleep_before_next_action
        session.click_button 'btnFindParcelData'
        sleep_before_next_action
        parcel.owner = session.find('#grdOwnersjEsCoOl_tableDiv').text
        parcel.owner_address = session.find('#grdMailingAddressjEsCoOl_mainDiv').text
        parcel.land_value = session.find('#lblLandValueVal').text.scan(/\d/).join('')
        parcel.building_value = session.find('#lblBuildingValueVal').text.scan(/\d/).join('')
        parcel.acres = session.find('#lblAcresVal').text
        parcel.address = session.find('#lblLocationAddressVal').text
        parcel.save
      rescue Net::ReadTimeout => e
        session.driver.browser.quit
        session = Capybara::Session.new(:selenium)
        login(session)
      rescue => e
        puts e
      end


      session.all('table#grdDocsList tr').each do |tr|
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
          session.driver.browser.quit
          session = Capybara::Session.new(:selenium)
          login(session)
        rescue => e
          puts e
        end
      end
    end
  end

  task ntdf: :environment do |t, args|
    # Capybara.register_driver :selenium do |app|
    #   Capybara::Selenium::Driver.new(app, :browser => :chrome)
    # end

    Capybara.register_driver :selenium do |app|
      Capybara::Selenium::Driver.new(
        app,
        browser: :firefox,
        desired_capabilities: Selenium::WebDriver::Remote::Capabilities.firefox(marionette: false)
      )
    end
    session = Capybara::Session.new(:selenium)
    login(session)

    session.visit 'http://recorder.slco.org/SLCR/Search/DocTypeSearchAdv.aspx'
    sleep_before_next_action

    session.select "NT DF", from: "ddlDocType"
    sleep_before_next_action
    session.choose 'radRecent'
    sleep_before_next_action
    session.click_button 'btnFindDocTypes'

    new_leads = []

    session.all('#grdDocuments tr').each do |tr|
      tds = tr.all('td')
      lead = Lead.where(entry_number: tds[1].text).first_or_create
      lead.document_type = tds[4].text
      lead.parcel_number = tds[5].text
      lead.filing_date = Date.strptime(tds[8].text, "%m/%d/%Y") rescue nil
      lead.deceased = tds[9].text
      new_leads << lead.id if lead.changed? and lead.save
    end

    Lead.where(id: new_leads).each do |lead|
      begin
        parcel = lead.parcel || Parcel.new(lead_id: lead.id)
        next unless lead.parcel_number.present?
        session.visit "http://recorder.slco.org/SLCR/Search/MainfrDocsListAndParcelDataRXPNVTDI_.aspx?ParNum=#{lead.parcel_number}"
        sleep_before_next_action
        session.click_button 'btnFindParcelData'
        sleep_before_next_action
        parcel.owner = session.find('#grdOwnersjEsCoOl_tableDiv').text
        parcel.owner_address = session.find('#grdMailingAddressjEsCoOl_mainDiv').text
        parcel.land_value = session.find('#lblLandValueVal').text.scan(/\d/).join('')
        parcel.building_value = session.find('#lblBuildingValueVal').text.scan(/\d/).join('')
        parcel.acres = session.find('#lblAcresVal').text
        parcel.address = session.find('#lblLocationAddressVal').text
        parcel.save
      rescue Net::ReadTimeout => e
        session.driver.browser.quit
        session = Capybara::Session.new(:selenium)
        login(session)
      rescue => e
        puts e
      end


      session.all('table#grdDocsList tr').each do |tr|
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
          session.driver.browser.quit
          session = Capybara::Session.new(:selenium)
          login(session)
        rescue => e
          puts e
        end
      end
    end
  end
end