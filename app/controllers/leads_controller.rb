class LeadsController < ApplicationController
  before_action :set_lead, only: [:letter, :hide, :show, :edit, :update, :destroy]

  def index
    @leads = Lead.by_type(params[:type]).by_stage(params[:stage]).visible
    render "#{params[:type].underscore}_index"
  end

  def show
  end

  def new
    @lead = Lead.new
  end

  def edit
  end

  def hide
    @lead.update(hidden: true)
    redirect_to :back
  end

  def letter
    klass = "#{params[:type]}LobLetter".constantize
    @letter = klass.new(
      name: @lead.parcel.owner_pretty,
      address: @lead.parcel.address,
      city: @lead.parcel.city,
      state: @lead.parcel.state,
      zip: @lead.parcel.zip,
      deceased: @lead.deceased_pretty,
      country: 'US'
    )
    render "#{params[:type].underscore}_letter"
  end

  def send_letter
    render json: LobWorker.new(params).send_letter
  end

  def create
    @lead = Lead.new(lead_params)

    respond_to do |format|
      if @lead.save
        format.html { redirect_to lead_path(@lead), notice: 'Lead was successfully created.' }
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
        format.html { redirect_to lead_path(@lead), notice: 'Lead was successfully updated.' }
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
      format.html { redirect_to leads_url, notice: 'Lead was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_lead
      @lead = Lead.find(params[:id])
    end

    def lead_params
      params.require(:lead).permit(
        :entry_number,
        :filing_date,
        :deceased,
        :address,
        :city,
        :zip,
        :heir,
        :contact_info,
        :lead_stage_id,
        :hidden
      )
    end
end
