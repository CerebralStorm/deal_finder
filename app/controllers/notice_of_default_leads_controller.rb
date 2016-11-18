class NoticeOfDefaultLeadsController < ApplicationController
  before_action :set_lead, only: [:letter, :show, :edit, :update, :destroy]

  def index
    @leads = NoticeOfDefaultLead.all
  end

  def show
  end

  def new
    @lead = NoticeOfDefaultLead.new
  end

  def edit
  end

  def letter
  end

  def create
    @lead = NoticeOfDefaultLead.new(lead_params)

    respond_to do |format|
      if @lead.save
        format.html { redirect_to @lead, flash: {success: 'NoticeOfDefaultLead was successfully created.'} }
        format.json { render :show, status: :created, location: @lead }
      else
        format.html { render :new }
        format.json { render json: @lead.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @lead.update(lead_params)
        format.html { redirect_to @lead, flash: {success: 'NoticeOfDefaultLead was successfully updated.'} }
        format.json { render :show, status: :ok, location: @lead }
      else
        format.html { render :edit }
        format.json { render json: @lead.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @lead.destroy
    respond_to do |format|
      format.html { redirect_to notice_of_default_leads_url, flash: {success: 'NoticeOfDefaultLead was successfully destroyed.' } }
      format.json { head :no_content }
    end
  end

  private
    def set_lead
      @lead = NoticeOfDefaultLead.find(params[:id])
    end

    def lead_params
      params.require(:notice_of_default_lead).permit(:entry_number, :filing_date, :deceased, :address, :city, :zip, :heir, :contact_info, :assessed_value, :zillow_value)
    end
end
