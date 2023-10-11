class StatusSchedulesController < ApplicationController
  before_action :set_status_schedule, only: %i[ show edit update destroy ]

  # GET /status_schedules or /status_schedules.json
  def index
    @status_schedules = StatusSchedule.all
  end

  # GET /status_schedules/1 or /status_schedules/1.json
  def show
  end

  # GET /status_schedules/new
  def new
    @status_schedule = StatusSchedule.new
  end

  # GET /status_schedules/1/edit
  def edit
  end

  # POST /status_schedules or /status_schedules.json
  def create
    @status_schedule = StatusSchedule.new(status_schedule_params)

    respond_to do |format|
      if @status_schedule.save
        format.html { redirect_to status_schedule_url(@status_schedule), notice: "Status schedule was successfully created." }
        format.json { render :show, status: :created, location: @status_schedule }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @status_schedule.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /status_schedules/1 or /status_schedules/1.json
  def update
    respond_to do |format|
      if @status_schedule.update(status_schedule_params)
        format.html { redirect_to status_schedule_url(@status_schedule), notice: "Status schedule was successfully updated." }
        format.json { render :show, status: :ok, location: @status_schedule }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @status_schedule.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /status_schedules/1 or /status_schedules/1.json
  def destroy
    @status_schedule.destroy

    respond_to do |format|
      format.html { redirect_to status_schedules_url, notice: "Status schedule was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_status_schedule
      @status_schedule = StatusSchedule.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def status_schedule_params
      params.require(:status_schedule).permit(:status_scheduleable_type, :status_scheduleable_id, :from, :to, :status, :status_reason, :comment, :previous_status, :previous_status_reason, :created_by, :updated_by, :previous_comment)
    end
end
