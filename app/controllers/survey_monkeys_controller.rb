class SurveyMonkeysController < ApplicationController
  before_action :set_survey_monkey, only: %i[ show edit update destroy ]

  # GET /survey_monkeys or /survey_monkeys.json
  def index
    @survey_monkeys = SurveyMonkey.all
  end

  # GET /survey_monkeys/1 or /survey_monkeys/1.json
  def show
  end

  # GET /survey_monkeys/new
  def new
    @survey_monkey = SurveyMonkey.new
  end

  # GET /survey_monkeys/1/edit
  def edit
  end

  # POST /survey_monkeys or /survey_monkeys.json
  def create
    @survey_monkey = SurveyMonkey.new(survey_monkey_params)

    respond_to do |format|
      if @survey_monkey.save
        format.html { redirect_to survey_monkey_url(@survey_monkey), notice: "Survey monkey was successfully created." }
        format.json { render :show, status: :created, location: @survey_monkey }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @survey_monkey.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /survey_monkeys/1 or /survey_monkeys/1.json
  def update
    respond_to do |format|
      if @survey_monkey.update(survey_monkey_params)
        format.html { redirect_to survey_monkey_url(@survey_monkey), notice: "Survey monkey was successfully updated." }
        format.json { render :show, status: :ok, location: @survey_monkey }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @survey_monkey.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /survey_monkeys/1 or /survey_monkeys/1.json
  def destroy
    @survey_monkey.destroy

    respond_to do |format|
      format.html { redirect_to survey_monkeys_url, notice: "Survey monkey was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_survey_monkey
      @survey_monkey = SurveyMonkey.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def survey_monkey_params
      params.require(:survey_monkey).permit(:respondent_id, :collector_id, :start_date, :end_date, :ip_address, :email_address, :first_name, :last_name, :custom_data, :what_is_your_email_address, :what_is_your_gender, :what_is_your_age, :what_is_customer_suits_you, :how_do_you_reachus, :how_long_did_you_wait, :is_this_issue_or_problem, :how_would_you_rate, :overall_how_satisfied_are_you)
    end
end
