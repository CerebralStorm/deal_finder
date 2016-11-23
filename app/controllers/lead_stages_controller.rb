class LeadStagesController < ApplicationController
  before_action :set_lead, only: [:show, :edit, :update, :destroy]

  def index
    @lead_stages = LeadStage.all
  end

  def show
  end

  def new
    @lead_stage = LeadStage.new
  end

  def edit
  end

  def create
    @lead_stage = LeadStage.new(lead_params)

    respond_to do |format|
      if @lead_stage.save
        format.html { redirect_to @lead_stage, notice: 'LeadStage was successfully created.' }
        format.json { render :show, status: :created, location: @lead_stage }
      else
        format.html { render :new }
        format.json { render json: @lead_stage.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @lead_stage.update(lead_params)
        format.html { redirect_to @lead_stage, notice: 'LeadStage was successfully updated.' }
        format.json { render :show, status: :ok, location: @lead_stage }
      else
        format.html { render :edit }
        format.json { render json: @lead_stage.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @lead_stage.destroy
    respond_to do |format|
      format.html { redirect_to leads_url, notice: 'LeadStage was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_lead
      @lead_stage = LeadStage.find(params[:id])
    end

    def lead_params
      params.require(:lead).permit(:entry_number, :filing_date, :deceased, :address, :city, :zip, :heir, :contact_info, :assessed_value, :zillow_value)
    end
end
