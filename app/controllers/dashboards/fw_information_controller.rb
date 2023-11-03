class Dashboards::FwInformationController < ApplicationController
  def index
    # data for filter drop down 
    @countries = Country.pluck(:name).compact
    @states = State.pluck(:name).compact.uniq
    @job_type = JobType.pluck(:name).compact.uniq
    @organizations = Organization.pluck(:name).uniq
    @foregin_worker_type = Transaction.pluck(:registration_type).uniq
    # unfiltered data for data_pints
    @current_year = Date.today.year
    @transactions = Transaction.where("extract(year from created_at) = ?", @current_year)
    @passed_examination_count = @transactions.where("EXTRACT(YEAR FROM medical_examination_date) = ? AND medical_examination_date < ?", @current_year, Date.current).count
    @certification_count = @transactions.where("EXTRACT(YEAR FROM certification_date) = ? AND certification_date < ?", @current_year, Date.current).count
    @final_result = @transactions.where(final_result: nil).count

    if request.format.js? && params[:value].nil?
      @filters = JSON.parse(params.keys.first)
      @filters = convert_values_to_arrays(@filters)

      # calling filter from here
      @transactions = apply_filter(@filters)

      if @transactions.present?
        # chart 2 and chart 4
        @pi_chart_data = [['Task', 'Hours per Day']]
        @transactions = Transaction.where(id: @transactions.ids)
        @transaction_line_chart = @transactions.transaction_data_last_5_years rescue {}

        # filtered data for data_pints
        @passed_examination_count = @transactions.where("EXTRACT(YEAR FROM medical_examination_date) = ? AND medical_examination_date < ?", @current_year, Date.current).count
        @certification_count = @transactions.where("EXTRACT(YEAR FROM certification_date) = ? AND certification_date < ?", @current_year, Date.current).count
        @final_result = @transactions.where(final_result: nil).count
        @side_bar_medical_appeals = @transactions.joins(:medical_appeals).count
        @block_fw = @transactions.joins(:myimms_transactions).pluck('myimms_transactions.status').map { |i| displayed_status(i) }.group_by { |status| status }.transform_values(&:count)
        @fw_insured = fw_insured(@transactions)

        @transactions.joins(:job_type).group('job_types.name').count.to_a.map { |i| @pi_chart_data << i }
        state_ids = @transactions.joins(doctor: :state).pluck('states.id')
        hash = {}
        state_ids.sort.uniq.each { |h| hash[h] = state_ids.count(h) }
        state_names = State.where(id: state_ids.sort.uniq).pluck(:name)
        converted_hash = {}
        state_names.each_with_index { |value, index| converted_hash[value] = hash.values[index] }
        @fw_reg_by_states = converted_hash.to_a
        @fw_Reg_by_countries = @transactions.joins(:country).group('countries.name').count.to_a
      end
    else
      @block_fw = Transaction.joins(:myimms_transactions).pluck('myimms_transactions.status').map { |i| displayed_status(i) }.group_by { |status| status }.transform_values(&:count)
      @fw_insured = fw_insured(@transactions)
      @side_bar_medical_appeals = Transaction.includes(:medical_appeals).find(@transactions.ids).count
      @pi_chart_data = [['Task', 'Hours per Day']]
      Transaction.joins(:job_type).group('job_types.name').count.to_a.map { |i| @pi_chart_data << i }
      @fw_reg_by_states = State.joins(doctors: :transactions).group('states.name').count.to_a
      @fw_Reg_by_countries = Transaction.joins(:country).group('countries.name').count.to_a
      @transaction_line_chart = Transaction.transaction_data_last_5_years
    end


    if @transaction_line_chart == {} || @transaction_line_chart.nil?
      current_year = Time.now.year
      last_five_years = (current_year - 4..current_year)

      @transaction_line_chart = last_five_years.each_with_object({}) do |year, chart_data|
        chart_data[year] = [0] * 12  # Initialize an array of zeros for each month
      end
    end

    # binding.pry
    @fw_pending_view = {
      xqcc_pool_received: Transaction.joins("JOIN xqcc_pools ON xqcc_pools.transaction_id = transactions.id") .order('transactions.created_at DESC')
                                      .limit(50)
                                      .group('xqcc_pools.created_at, transactions.certification_date, transactions.created_at')
                                      .count,

      xqcc_pool_reviewed: Transaction.joins("JOIN xray_reviews ON xray_reviews.transaction_id = transactions.id") .order('transactions.created_at DESC')
                                     .limit(50)
                                     .group('xray_reviews.transmitted_at, transactions.certification_date, transactions.created_at')
                                     .count,
      pcr_pool_received: Transaction.joins("JOIN pcr_pools ON pcr_pools.transaction_id = transactions.id") .order('transactions.created_at DESC')
                                    .limit(50)
                                    .group('pcr_pools.created_at, transactions.certification_date, transactions.created_at')
                                    .count,
      pcr_pool_reviewed: Transaction.joins("JOIN pcr_reviews ON pcr_reviews.transaction_id = transactions.id") .order('transactions.created_at DESC')
                                   .limit(50)
                                   .group('pcr_reviews.transmitted_at, transactions.certification_date, transactions.created_at')
                                   .count,

      xray_pending_review_received: Transaction.joins("JOIN xray_pending_reviews ON xray_pending_reviews.transaction_id = transactions.id") .order('transactions.created_at DESC')
                                               .limit(50)
                                               .group('xray_pending_reviews.created_at, transactions.certification_date, transactions.created_at')
                                               .count,

      xray_pending_review_reviewed: Transaction.joins("JOIN xray_pending_reviews ON xray_pending_reviews.transaction_id = transactions.id") .order('transactions.created_at DESC')
                                               .limit(50)
                                               .group('xray_pending_reviews.transmitted_at, transactions.certification_date, transactions.created_at')
                                               .count,

      xray_pending_decision_received: Transaction.joins("JOIN xray_pending_decisions ON xray_pending_decisions.transaction_id = transactions.id") .order('transactions.created_at DESC')
                                                 .limit(50)
                                                 .group('xray_pending_decisions.created_at, transactions.certification_date, transactions.created_at')
                                                 .count,


      xray_pending_decision_reviewed:  Transaction.joins("JOIN xray_pending_decisions ON xray_pending_decisions.transaction_id = transactions.id") .order('transactions.created_at DESC')
                                                  .limit(50)
                                                  .group('xray_pending_decisions.transmitted_at, transactions.certification_date, transactions.created_at')
                                                  .count,
      medical_review: MedicalReview.joins("JOIN medical_reviews ON medical_reviews.transaction_id = transactions.id")
                                   .where("medical_reviews.created_at IS NOT NULL AND medical_reviews.medical_mle1_decision_at IS NOT NULL AND medical_reviews.qa_decision_at IS NOT NULL AND is_qa = ?", true)
                                   .pluck('transactions.certification_date, medical_reviews.created_at, medical_reviews.medical_mle1_decision_at, medical_reviews.is_qa, medical_reviews.qa_decision_at').uniq.count

    } rescue nil
    respond_to do |format|
      format.html
      format.js { render layout: false } # Add this line to you respond_to block
    end
  end

  # binding.pry

  def excel_generate
    @countries = Country.pluck(:name).compact.uniq
    countries_with_ids = Country.where(name: @countries).pluck(:name, :id).to_h
    @total_fw_registration = {}
    @examination_count = {}
    @certification_count = {}
    @xqcc_pool_received = {}
    @xqcc_pool_reviewed = {}
    @pcr_pool_received = {}
    @pcr_pool_reviewed ={}
    @xray_pending_review_received = {}
    @xray_pending_review_reviewed = {}
    @xray_pending_decision_received = {}
    @xray_pending_decision_reviewed = {}
    @countries.each do |country|
      country_id = countries_with_ids[country]

      total_fw_registration_count = Transaction.where(fw_country_id: country_id)
                                               .order(created_at: :desc)
                                               .limit(50)
                                               .count
      @total_fw_registration[country] = total_fw_registration_count

      examination_count =  Transaction.where(fw_country_id: country_id)
                                      .where("EXTRACT(YEAR FROM medical_examination_date) = ? AND medical_examination_date < ?", Date.current.year, Date.current)
                                      .order(created_at: :desc)
                                      .limit(50)
                                      .count
      @examination_count[country] = examination_count

      certification_count = Transaction.where(fw_country_id: country_id)
                                       .where("EXTRACT(YEAR FROM medical_examination_date) = ? AND medical_examination_date < ?", Date.current.year, Date.current)
                                       .order(created_at: :desc)
                                       .limit(50)
                                       .count
      @certification_count[country] = certification_count

      xqcc_pool_received = Transaction.joins("JOIN xqcc_pools ON xqcc_pools.transaction_id = transactions.id") .order('transactions.created_at DESC')
                                      .limit(50)
                                      .group('xqcc_pools.created_at, transactions.certification_date, transactions.created_at')
                                      .count
      @xqcc_pool_received[country] = xqcc_pool_received

      xqcc_pool_reviewed = Transaction.joins("JOIN xray_reviews ON xray_reviews.transaction_id = transactions.id") .order('transactions.created_at DESC')
                                      .limit(50)
                                      .group('xray_reviews.transmitted_at, transactions.certification_date, transactions.created_at')
                                      .count
      @xqcc_pool_reviewed[country] = xqcc_pool_reviewed

      pcr_pool_received = Transaction.joins("JOIN pcr_pools ON pcr_pools.transaction_id = transactions.id") .order('transactions.created_at DESC')
                                      .limit(50)
                                      .group('pcr_pools.created_at, transactions.certification_date, transactions.created_at')
                                      .count
      @pcr_pool_received[country] = pcr_pool_received

      pcr_pool_reviewed = Transaction.joins("JOIN pcr_reviews ON pcr_reviews.transaction_id = transactions.id") .order('transactions.created_at DESC')
                                      .limit(50)
                                      .group('pcr_reviews.transmitted_at, transactions.certification_date, transactions.created_at')
                                      .count
      @pcr_pool_reviewed[country] = pcr_pool_reviewed

      xray_pending_review_received = Transaction.joins("JOIN xray_pending_reviews ON xray_pending_reviews.transaction_id = transactions.id") .order('transactions.created_at DESC')
                                     .limit(50)
                                     .group('xray_pending_reviews.created_at, transactions.certification_date, transactions.created_at')
                                     .count
      @xray_pending_review_received[country] = xray_pending_review_received

      xray_pending_review_reviewed = Transaction.joins("JOIN xray_pending_reviews ON xray_pending_reviews.transaction_id = transactions.id") .order('transactions.created_at DESC')
                                                .limit(50)
                                                .group('xray_pending_reviews.transmitted_at, transactions.certification_date, transactions.created_at')
                                                .count
      @xray_pending_review_reviewed[country] = xray_pending_review_reviewed

      xray_pending_decision_received = Transaction.joins("JOIN xray_pending_decisions ON xray_pending_decisions.transaction_id = transactions.id") .order('transactions.created_at DESC')
                                               .limit(50)
                                               .group('xray_pending_decisions.created_at, transactions.certification_date, transactions.created_at')
                                               .count
      @xray_pending_decision_received[country] = xray_pending_decision_received

      xray_pending_decision_reviewed = Transaction.joins("JOIN xray_pending_decisions ON xray_pending_decisions.transaction_id = transactions.id") .order('transactions.created_at DESC')
                                               .limit(50)
                                               .group('xray_pending_decisions.transmitted_at, transactions.certification_date, transactions.created_at')
                                               .count
      @xray_pending_decision_reviewed[country] = xray_pending_decision_reviewed

    end

    @states = State.pluck(:name).compact.uniq
    @job_type = JobType.pluck(:name).compact.uniq
    @organizations = Organization.pluck(:name).uniq
    @sheet_data = {
      'FW Reg. by Country' => [
        'FW Registration by Country',
        ['FW Registration by Country', 'Total FW Registration', 'FW went for medical examination', 'Certification', 'XQCC Pool (Film Received)', 'XQCC Pool (Film Reviewed)', 'PCR Pool (Film Received)', 'PCR Pool (Film Reviewed)', 'X-Ray Pending Review (Film Received)', 'X-Ray Pending Review (Film Reviewed)', 'X-Ray Pending Decision (Film Received)', 'X-Ray Pending Decision (Film Reviewed)', 'Medical Review (Received)', 'Medical Review (Reviewed)', 'Final Result Released', 'Result Transmitted to Immigration', 'Blocked FW', 'Appeal', 'FW Insured'],
      ],
      'FW Reg. by State' => [
        'FW Registration by State',
        ['FW Registration by State', 'Total FW Registration', 'FW went for medical examination', 'Certification', 'XQCC Pool (Film Received)', 'XQCC Pool (Film Reviewed)', 'PCR Pool (Film Received)', 'PCR Pool (Film Reviewed)', 'X-Ray Pending Review (Film Received)', 'X-Ray Pending Review (Film Reviewed)', 'X-Ray Pending Decision (Film Received)', 'X-Ray Pending Decision (Film Reviewed)', 'Medical Review (Received)', 'Medical Review (Reviewed)', 'Final Result Released', 'Result Transmitted to Immigration', 'Blocked FW', 'Appeal', 'FW Insured'],
      ],
      'FW Reg. by Sector' => [
        'FW Registration by Sector',
        ['FW Registration by Sector', 'Total FW Registration', 'FW went for medical examination', 'Certification', 'XQCC Pool (Film Received)', 'XQCC Pool (Film Reviewed)', 'PCR Pool (Film Received)', 'PCR Pool (Film Reviewed)', 'X-Ray Pending Review (Film Received)', 'X-Ray Pending Review (Film Reviewed)', 'X-Ray Pending Decision (Film Received)', 'X-Ray Pending Decision (Film Reviewed)', 'Medical Review (Received)', 'Medical Review (Reviewed)', 'Final Result Released', 'Result Transmitted to Immigration', 'Blocked FW', 'Appeal', 'FW Insured'],
        ['Example data 1', 'Example data 2', 'Example data 3', 'Example data 4', 'Example data 5', 'Example data 6', 'Example data 7', 'Example data 8', 'Example data 9', 'Example data 10', 'Example data 11', 'Example data 12', 'Example data 13', 'Example data 14', 'Example data 15', 'Example data 16', 'Example data 17', 'Example data 18', 'Example data 19']
      ],
      'FW Reg. by Gender' => [
        'FW Registration by Gender',
        ['FW Registration by Gender', 'Total FW Registration', 'FW went for medical examination', 'Certification', 'XQCC Pool (Film Received)', 'XQCC Pool (Film Reviewed)', 'PCR Pool (Film Received)', 'PCR Pool (Film Reviewed)', 'X-Ray Pending Review (Film Received)', 'X-Ray Pending Review (Film Reviewed)', 'X-Ray Pending Decision (Film Received)', 'X-Ray Pending Decision (Film Reviewed)', 'Medical Review (Received)', 'Medical Review (Reviewed)', 'Final Result Released', 'Result Transmitted to Immigration', 'Blocked FW', 'Appeal', 'FW Insured'],
        ['Example data 1', 'Example data 2', 'Example data 3', 'Example data 4', 'Example data 5', 'Example data 6', 'Example data 7', 'Example data 8', 'Example data 9', 'Example data 10', 'Example data 11', 'Example data 12', 'Example data 13', 'Example data 14', 'Example data 15', 'Example data 16', 'Example data 17', 'Example data 18', 'Example data 19']
      ],
      'FW Reg. by Registration at' => [
        'FW Registration by Registration at',
        ['FW Registration by Sector', 'Total FW Registration', 'FW went for medical examination', 'Certification', 'XQCC Pool (Film Received)', 'XQCC Pool (Film Reviewed)', 'PCR Pool (Film Received)', 'PCR Pool (Film Reviewed)', 'X-Ray Pending Review (Film Received)', 'X-Ray Pending Review (Film Reviewed)', 'X-Ray Pending Decision (Film Received)', 'X-Ray Pending Decision (Film Reviewed)', 'Medical Review (Received)', 'Medical Review (Reviewed)', 'Final Result Released', 'Result Transmitted to Immigration', 'Blocked FW', 'Appeal', 'FW Insured'],
        ['Example data 1', 'Example data 2', 'Example data 3', 'Example data 4', 'Example data 5', 'Example data 6', 'Example data 7', 'Example data 8', 'Example data 9', 'Example data 10', 'Example data 11', 'Example data 12', 'Example data 13', 'Example data 14', 'Example data 15', 'Example data 16', 'Example data 17', 'Example data 18', 'Example data 19']
      ],
      'FW Reg. by FW Type' => [
        'FW Registration by FW Type',
        ['FW Registration by FW Type', 'Total FW Registration', 'FW went for medical examination', 'Certification', 'XQCC Pool (Film Received)', 'XQCC Pool (Film Reviewed)', 'PCR Pool (Film Received)', 'PCR Pool (Film Reviewed)', 'X-Ray Pending Review (Film Received)', 'X-Ray Pending Review (Film Reviewed)', 'X-Ray Pending Decision (Film Received)', 'X-Ray Pending Decision (Film Reviewed)', 'Medical Review (Received)', 'Medical Review (Reviewed)', 'Final Result Released', 'Result Transmitted to Immigration', 'Blocked FW', 'Appeal', 'FW Insured'],
        ['Example data 1', 'Example data 2', 'Example data 3', 'Example data 4', 'Example data 5', 'Example data 6', 'Example data 7', 'Example data 8', 'Example data 9', 'Example data 10', 'Example data 11', 'Example data 12', 'Example data 13', 'Example data 14', 'Example data 15', 'Example data 16', 'Example data 17', 'Example data 18', 'Example data 19']
      ],
      'Trend of FW Reg. by year' => [
        'Trend of FW registration by Year',
        ['Transaction date by Month', 'Transaction date by Day', '2019', '2020', '2021', '2022', '2023', 'Count'],
        ['Example data 1', 'Example data 2', 'Example data 3', 'Example data 4', 'Example data 5', 'Example data 6', 'Example data 7', 'Example data 8']
      ],
      'Raw Data 2023' => [
        'Data 2023',
        ['Transaction Date (Month)', 'Medical Examination Date (Month)', 'Certification Date (Month)', 'State', 'Country', 'Age', 'Gender', 'Registration at', 'Foreign Worker Type', 'XQCC Pool (Film Received)', 'XQCC Pool (Film Reviewed)', 'PCR Pool (Film Received)', 'PCR Pool (Film Reviewed)', 'X-Ray Pending Review (Film Received)', 'X-Ray Pending Review (Film Reviewed)', 'X-Ray Pending Decision (Film Received)', 'X-Ray Pending Decision (Film Reviewed)', 'Medical Review (Received)', 'Medical Review (Reviewed)', 'Final Result Released', 'Result Transmitted to Immigration', 'Blocked FW', 'Appeal', 'FW Insured'],
        ['Example data 1', 'Example data 2', 'Example data 3', 'Example data 4', 'Example data 5', 'Example data 6', 'Example data 7', 'Example data 8', 'Example data 9', 'Example data 10', 'Example data 11', 'Example data 12', 'Example data 13', 'Example data 14', 'Example data 15', 'Example data 16', 'Example data 17', 'Example data 18', 'Example data 19', 'Example data 20', 'Example data 21', 'Example data 22', 'Example data 23', 'Example data 24']
      ],
      'Raw Data 2022' => [
        'Data 2022',
        ['Transaction Date (Month)', 'Medical Examination Date (Month)', 'Certification Date (Month)', 'State', 'Country', 'Age', 'Gender', 'Registration at', 'Foreign Worker Type', 'XQCC Pool (Film Received)', 'XQCC Pool (Film Reviewed)', 'PCR Pool (Film Received)', 'PCR Pool (Film Reviewed)', 'X-Ray Pending Review (Film Received)', 'X-Ray Pending Review (Film Reviewed)', 'X-Ray Pending Decision (Film Received)', 'X-Ray Pending Decision (Film Reviewed)', 'Medical Review (Received)', 'Medical Review (Reviewed)', 'Final Result Released', 'Result Transmitted to Immigration', 'Blocked FW', 'Appeal', 'FW Insured'],
        ['Example data 1', 'Example data 2', 'Example data 3', 'Example data 4', 'Example data 5', 'Example data 6', 'Example data 7', 'Example data 8', 'Example data 9', 'Example data 10', 'Example data 11', 'Example data 12', 'Example data 13', 'Example data 14', 'Example data 15', 'Example data 16', 'Example data 17', 'Example data 18', 'Example data 19', 'Example data 20', 'Example data 21', 'Example data 22', 'Example data 23', 'Example data 24']
      ],
      'Raw Data 2021' => [
        'Data 2021',
        ['Transaction Date (Month)', 'Medical Examination Date (Month)', 'Certification Date (Month)', 'State', 'Country', 'Age', 'Gender', 'Registration at', 'Foreign Worker Type', 'XQCC Pool (Film Received)', 'XQCC Pool (Film Reviewed)', 'PCR Pool (Film Received)', 'PCR Pool (Film Reviewed)', 'X-Ray Pending Review (Film Received)', 'X-Ray Pending Review (Film Reviewed)', 'X-Ray Pending Decision (Film Received)', 'X-Ray Pending Decision (Film Reviewed)', 'Medical Review (Received)', 'Medical Review (Reviewed)', 'Final Result Released', 'Result Transmitted to Immigration', 'Blocked FW', 'Appeal', 'FW Insured'],
        ['Example data 1', 'Example data 2', 'Example data 3', 'Example data 4', 'Example data 5', 'Example data 6', 'Example data 7', 'Example data 8', 'Example data 9', 'Example data 10', 'Example data 11', 'Example data 12', 'Example data 13', 'Example data 14', 'Example data 15', 'Example data 16', 'Example data 17', 'Example data 18', 'Example data 19', 'Example data 20', 'Example data 21', 'Example data 22', 'Example data 23', 'Example data 24']
      ],
      'Raw Data 2020' => [
        'Data 2020',
        ['Transaction Date (Month)', 'Medical Examination Date (Month)', 'Certification Date (Month)', 'State', 'Country', 'Age', 'Gender', 'Registration at', 'Foreign Worker Type', 'XQCC Pool (Film Received)', 'XQCC Pool (Film Reviewed)', 'PCR Pool (Film Received)', 'PCR Pool (Film Reviewed)', 'X-Ray Pending Review (Film Received)', 'X-Ray Pending Review (Film Reviewed)', 'X-Ray Pending Decision (Film Received)', 'X-Ray Pending Decision (Film Reviewed)', 'Medical Review (Received)', 'Medical Review (Reviewed)', 'Final Result Released', 'Result Transmitted to Immigration', 'Blocked FW', 'Appeal', 'FW Insured'],
        ['Example data 1', 'Example data 2', 'Example data 3', 'Example data 4', 'Example data 5', 'Example data 6', 'Example data 7', 'Example data 8', 'Example data 9', 'Example data 10', 'Example data 11', 'Example data 12', 'Example data 13', 'Example data 14', 'Example data 15', 'Example data 16', 'Example data 17', 'Example data 18', 'Example data 19', 'Example data 20', 'Example data 21', 'Example data 22', 'Example data 23', 'Example data 24']
      ],
      'Raw Data 2019' => [
        'Data 2019',
        ['Transaction Date (Month)', 'Medical Examination Date (Month)', 'Certification Date (Month)', 'State', 'Country', 'Age', 'Gender', 'Registration at', 'Foreign Worker Type', 'XQCC Pool (Film Received)', 'XQCC Pool (Film Reviewed)', 'PCR Pool (Film Received)', 'PCR Pool (Film Reviewed)', 'X-Ray Pending Review (Film Received)', 'X-Ray Pending Review (Film Reviewed)', 'X-Ray Pending Decision (Film Received)', 'X-Ray Pending Decision (Film Reviewed)', 'Medical Review (Received)', 'Medical Review (Reviewed)', 'Final Result Released', 'Result Transmitted to Immigration', 'Blocked FW', 'Appeal', 'FW Insured'],
        ['Example data 1', 'Example data 2', 'Example data 3', 'Example data 4', 'Example data 5', 'Example data 6', 'Example data 7', 'Example data 8', 'Example data 9', 'Example data 10', 'Example data 11', 'Example data 12', 'Example data 13', 'Example data 14', 'Example data 15', 'Example data 16', 'Example data 17', 'Example data 18', 'Example data 19', 'Example data 20', 'Example data 21', 'Example data 22', 'Example data 23', 'Example data 24']
      ]
    }

    respond_to do |format|
      format.xlsx { render xlsx: 'excel_generate', filename: 'Report.xlsx' }
    end
  end

  private

  def convert_values_to_arrays(hash)
    converted_hash = {}

    hash.each_with_index do |(key, value), index|
      if index == 0
        converted_hash[key] = value
      else
        converted_hash[key] = value.split(' ')
      end
    end

    converted_hash
  end

  def apply_filter(filter_params)
    transactions = Transaction.all
    filter_params.each do |param_key, param_value|
      case param_key
      when "DateRange"
        if param_value.present?
          start_date, end_date = param_value.split(" - ")
          transactions = transactions.where(created_at: start_date..end_date)
        end
      when "Sector"
        if param_value.present?
          sector_names = JobType.pluck(:name)
          selected_sector_names = sector_names & param_value
          transactions = transactions.joins(:job_type).where("job_types.name" => selected_sector_names)
        end
      when "Country"
        if param_value.present?
          transactions = transactions.joins(:country).where("countries.name" => param_value)
        end
      when "State"
        if param_value.present?
          state_ids = State.where(name: param_value).pluck(:id)
          doctor_ids = Doctor.where(state_id: state_ids).pluck(:id)
          transactions = transactions.where(doctor_id: doctor_ids)
        end
      when "Gender"
        if param_value.present?
          transactions = transactions.where(fw_gender: param_value)
        end
      when "age"
        if param_value.present?
          age_ranges = param_value.map do |age_range|
            if age_range == "65+"
              [65, nil] # Represent "65+" as [65, nil]
            else
              age_range.split("-").map(&:to_i)
            end
          end

          birth_years = age_ranges.map do |min_age, max_age|
            if max_age.nil?
              birth_year_min = Date.today.year - 65
              birth_year_max = nil # Handle "65+" case with no maximum age
            else
              birth_year_min = Date.today.year - max_age - 1
              birth_year_max = Date.today.year - min_age
            end
            [birth_year_min, birth_year_max]
          end

          # Find the overall minimum and maximum birth years
          overall_birth_year_min = birth_years.map(&:first).min
          overall_birth_year_max = birth_years.map(&:last).max

          transactions = transactions.where(fw_date_of_birth: Date.new(overall_birth_year_min)..Date.new(overall_birth_year_max))
        end

      when "ForeginWorker"
        if param_value.present?
          transactions = transactions.where(registration_type: param_value)
        end
      when "Registration"
        if param_value.present?
          organization_names = Organization.pluck(:name).uniq
          selected_organization_names = organization_names & param_value
          transactions = transactions.joins(:organization).where("organizations.name" => selected_organization_names)
        end
        # Add more cases for other filter keys here
      end
    end
    transactions

  end

  def displayed_status(status)
    resp_status = {
      '1' => "SUCCESS",
      '0' => "FAILED",
      '96' => 'IMM BLOCKED',
      '97' => 'YET TO PROCEED',
      '98' => "FOREIGN WORKER BLOCKED",
      "99" => "PHYSICAL NOT DONE"
    }
    resp_status[status]
  end

  def fw_insured(transactions)
    insurance_purchase_counts = {}
    transactions.ids.each do |transaction_id|
      transaction = Transaction.find_by(id: transaction_id)
      if transaction
        insurance_purchase_counts[transaction_id] = transaction.foreign_worker.insurance_purchases.count
      else
        insurance_purchase_counts[transaction_id] = 0
      end
    end
    insurance_purchase_counts.values.sum
  end

end
