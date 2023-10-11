class LaboratoryExaminationsController < ApplicationController
  before_action :set_laboratory_examination, only: %i[ show edit update destroy ]

  # GET /laboratory_examinations or /laboratory_examinations.json
  def index
    @laboratory_examinations = LaboratoryExamination.all
  end

  # GET /laboratory_examinations/1 or /laboratory_examinations/1.json
  def show
  end

  # GET /laboratory_examinations/new
  def new
    @laboratory_examination = LaboratoryExamination.new
  end

  # GET /laboratory_examinations/1/edit
  def edit
  end

  # POST /laboratory_examinations or /laboratory_examinations.json
  def create
    @laboratory_examination = LaboratoryExamination.new(laboratory_examination_params)

    respond_to do |format|
      if @laboratory_examination.save
        format.html { redirect_to laboratory_examination_url(@laboratory_examination), notice: "Laboratory examination was successfully created." }
        format.json { render :show, status: :created, location: @laboratory_examination }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @laboratory_examination.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /laboratory_examinations/1 or /laboratory_examinations/1.json
  def update
    respond_to do |format|
      if @laboratory_examination.update(laboratory_examination_params)
        format.html { redirect_to laboratory_examination_url(@laboratory_examination), notice: "Laboratory examination was successfully updated." }
        format.json { render :show, status: :ok, location: @laboratory_examination }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @laboratory_examination.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /laboratory_examinations/1 or /laboratory_examinations/1.json
  def destroy
    @laboratory_examination.destroy

    respond_to do |format|
      format.html { redirect_to laboratory_examinations_url, notice: "Laboratory examination was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_laboratory_examination
      @laboratory_examination = LaboratoryExamination.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def laboratory_examination_params
      params.require(:laboratory_examination).permit(:transaction_id, :laboratory_id, :laboratory_test_not_done, :specimen_taken_date, :specimen_received_date, :blood_specimen_barcode, :urine_specimen_barcode, :blood_group, :blood_group_rhesus, :result, :transmitted_at, :created_by, :updated_by, :web_service_indicator, :deleted_at)
    end
end
