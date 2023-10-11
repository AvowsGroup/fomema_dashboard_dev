class RadiologistsController < ApplicationController
  before_action :set_radiologist, only: %i[ show edit update destroy ]

  # GET /radiologists or /radiologists.json
  def index
    @radiologists = Radiologist.all
  end

  # GET /radiologists/1 or /radiologists/1.json
  def show
  end

  # GET /radiologists/new
  def new
    @radiologist = Radiologist.new
  end

  # GET /radiologists/1/edit
  def edit
  end

  # POST /radiologists or /radiologists.json
  def create
    @radiologist = Radiologist.new(radiologist_params)

    respond_to do |format|
      if @radiologist.save
        format.html { redirect_to radiologist_url(@radiologist), notice: "Radiologist was successfully created." }
        format.json { render :show, status: :created, location: @radiologist }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @radiologist.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /radiologists/1 or /radiologists/1.json
  def update
    respond_to do |format|
      if @radiologist.update(radiologist_params)
        format.html { redirect_to radiologist_url(@radiologist), notice: "Radiologist was successfully updated." }
        format.json { render :show, status: :ok, location: @radiologist }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @radiologist.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /radiologists/1 or /radiologists/1.json
  def destroy
    @radiologist.destroy

    respond_to do |format|
      format.html { redirect_to radiologists_url, notice: "Radiologist was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_radiologist
      @radiologist = Radiologist.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def radiologist_params
      params.require(:radiologist).permit(:code, :name, :xray_facility_name, :string, :title_id, :icno, :address1, :address2, :address3, :address4, :country_id, :state_id, :town_id, :postcode, :phone, :fax, :mobile, :email, :qualification, :is_panel_xray_facility, :district_health_office_id, :is_pcr, :apc_year, :apc_number, :nsr_number, :renewal_agreement_date, :comment, :status, :status_reason, :registration_approved_at, :activated_at, :approval_status, :approval_remark, :created_by, :updated_by, :status_comment, :user_id, :gender, :nationality_id, :race_id)
    end
end
