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
        chart_data[year] = [0] * 12 # Initialize an array of zeros for each month
      end
    end
    @fw_pending_view = {
      xqcc_pool_received: Transaction.joins("JOIN xqcc_pools ON xqcc_pools.transaction_id = transactions.id").order('transactions.created_at DESC')
                                     .limit(50)
                                     .group('xqcc_pools.created_at, transactions.certification_date, transactions.created_at')
                                     .count,

      xqcc_pool_reviewed: Transaction.joins("JOIN xray_reviews ON xray_reviews.transaction_id = transactions.id").order('transactions.created_at DESC')
                                     .limit(50)
                                     .group('xray_reviews.transmitted_at, transactions.certification_date, transactions.created_at')
                                     .count,
      pcr_pool_received: Transaction.joins("JOIN pcr_pools ON pcr_pools.transaction_id = transactions.id").order('transactions.created_at DESC')
                                    .limit(50)
                                    .group('pcr_pools.created_at, transactions.certification_date, transactions.created_at')
                                    .count,
      pcr_pool_reviewed: Transaction.joins("JOIN pcr_reviews ON pcr_reviews.transaction_id = transactions.id").order('transactions.created_at DESC')
                                    .limit(50)
                                    .group('pcr_reviews.created_at,transactions.certification_date, transactions.created_at')
                                    .count.values,

      xray_pending_review_received: Transaction.joins("JOIN xray_pending_reviews ON xray_pending_reviews.transaction_id = transactions.id").order('transactions.created_at DESC')
                                               .limit(50)
                                               .group('xray_pending_reviews.created_at, transactions.certification_date, transactions.created_at')
                                               .count,

      xray_pending_review_reviewed: Transaction.joins("JOIN xray_pending_reviews ON xray_pending_reviews.transaction_id = transactions.id").order('transactions.created_at DESC')
                                               .limit(50)
                                               .group('xray_pending_reviews.transmitted_at, transactions.certification_date, transactions.created_at')
                                               .count,

      xray_pending_decision_received: Transaction.joins("JOIN xray_pending_decisions ON xray_pending_decisions.transaction_id = transactions.id").order('transactions.created_at DESC')
                                                 .limit(50)
                                                 .group('xray_pending_decisions.created_at, transactions.certification_date, transactions.created_at')
                                                 .count,

      xray_pending_decision_reviewed: Transaction.joins("JOIN xray_pending_decisions ON xray_pending_decisions.transaction_id = transactions.id").order('transactions.created_at DESC')
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

  def excel_generate
    @total_fw_registration = {}
    @examination_count = {}
    @certification_count = {}
    @xqcc_pool_received = {}
    @xqcc_pool_reviewed = {}
    @pcr_pool_received = {}
    @pcr_pool_reviewed = {}
    @xray_pending_review_received = {}
    @xray_pending_review_reviewed = {}
    @xray_pending_decision_received = {}
    @xray_pending_decision_reviewed = {}

    @countries = Country.pluck(:name).compact.uniq
    countries_with_ids = Country.where(name: @countries).pluck(:name, :id).to_h
    @countries.each do |country|
      country_id = countries_with_ids[country]

      total_fw_registration_count = Transaction.where(fw_country_id: country_id)
                                               .order(created_at: :desc)
                                               .limit(50)
                                               .count
      @total_fw_registration[country] = total_fw_registration_count

      examination_count = Transaction.where(fw_country_id: country_id)
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

      xqcc_pool_received = Transaction.joins("JOIN xqcc_pools ON xqcc_pools.transaction_id = transactions.id").order('transactions.created_at DESC')
                                      .limit(50)
                                      .group('xqcc_pools.created_at, transactions.certification_date, transactions.created_at')
                                      .count.values
      @xqcc_pool_received[country] = xqcc_pool_received

      xqcc_pool_reviewed = Transaction.joins("JOIN xray_reviews ON xray_reviews.transaction_id = transactions.id").order('transactions.created_at DESC')
                                      .limit(50)
                                      .group('xray_reviews.transmitted_at, transactions.certification_date, transactions.created_at')
                                      .count.values
      @xqcc_pool_reviewed[country] = xqcc_pool_reviewed

      pcr_pool_received = Transaction.joins("JOIN pcr_pools ON pcr_pools.transaction_id = transactions.id").order('transactions.created_at DESC')
                                     .limit(50)
                                     .group('pcr_pools.created_at, transactions.certification_date, transactions.created_at')
                                     .count.values
      @pcr_pool_received[country] = pcr_pool_received

      pcr_pool_reviewed = Transaction.joins("JOIN pcr_reviews ON pcr_reviews.transaction_id = transactions.id").order('transactions.created_at DESC')
                                     .limit(50)
                                     .group('pcr_reviews.created_at,transactions.certification_date, transactions.created_at')
                                     .count.values
      @pcr_pool_reviewed[country] = pcr_pool_reviewed

      xray_pending_review_received = Transaction.joins("JOIN xray_pending_reviews ON xray_pending_reviews.transaction_id = transactions.id").order('transactions.created_at DESC')
                                                .limit(50)
                                                .group('xray_pending_reviews.created_at, transactions.certification_date, transactions.created_at')
                                                .count.values
      @xray_pending_review_received[country] = xray_pending_review_received

      xray_pending_review_reviewed = Transaction.joins("JOIN xray_pending_reviews ON xray_pending_reviews.transaction_id = transactions.id").order('transactions.created_at DESC')
                                                .limit(50)
                                                .group('xray_pending_reviews.transmitted_at, transactions.certification_date, transactions.created_at')
                                                .count.values
      @xray_pending_review_reviewed[country] = xray_pending_review_reviewed

      xray_pending_decision_received = Transaction.joins("JOIN xray_pending_decisions ON xray_pending_decisions.transaction_id = transactions.id").order('transactions.created_at DESC')
                                                  .limit(50)
                                                  .group('xray_pending_decisions.created_at, transactions.certification_date, transactions.created_at')
                                                  .count.values
      @xray_pending_decision_received[country] = xray_pending_decision_received

      xray_pending_decision_reviewed = Transaction.joins("JOIN xray_pending_decisions ON xray_pending_decisions.transaction_id = transactions.id").order('transactions.created_at DESC')
                                                  .limit(50)
                                                  .group('xray_pending_decisions.transmitted_at, transactions.certification_date, transactions.created_at')
                                                  .count.values
      @xray_pending_decision_reviewed[country] = xray_pending_decision_reviewed

    end

    @states = State.pluck(:name).compact.uniq
    states_with_ids = State.where(name: @states).pluck(:name, :id).to_h

    @states.each do |state|
      doctor_ids = Doctor.where(state_id: states_with_ids[state]).pluck(:id)

      total_fw_registration_count = Transaction.where(doctor_id: doctor_ids)
                                               .order(created_at: :desc)
                                               .limit(50)
                                               .count
      @total_fw_registration[state] = total_fw_registration_count

      examination_count = Transaction.where(doctor_id: doctor_ids)
                                     .where("EXTRACT(YEAR FROM medical_examination_date) = ? AND medical_examination_date < ?", Date.current.year, Date.current)
                                     .order(created_at: :desc)
                                     .limit(50)
                                     .count
      @examination_count[state] = examination_count

      certification_count = Transaction.where(doctor_id: doctor_ids)
                                       .where("EXTRACT(YEAR FROM medical_examination_date) = ? AND medical_examination_date < ?", Date.current.year, Date.current)
                                       .order(created_at: :desc)
                                       .limit(50)
                                       .count
      @certification_count[state] = certification_count

      xqcc_pool_received = Transaction.joins("JOIN xqcc_pools ON xqcc_pools.transaction_id = transactions.id").order('transactions.created_at DESC')
                                      .limit(50)
                                      .group('xqcc_pools.created_at, transactions.certification_date, transactions.created_at')
                                      .count.values
      @xqcc_pool_received[state] = xqcc_pool_received

      xqcc_pool_reviewed = Transaction.joins("JOIN xray_reviews ON xray_reviews.transaction_id = transactions.id").order('transactions.created_at DESC')
                                      .limit(50)
                                      .group('xray_reviews.transmitted_at, transactions.certification_date, transactions.created_at')
                                      .count.values
      @xqcc_pool_reviewed[state] = xqcc_pool_reviewed

      pcr_pool_received = Transaction.joins("JOIN pcr_pools ON pcr_pools.transaction_id = transactions.id").order('transactions.created_at DESC')
                                     .limit(50)
                                     .group('pcr_pools.created_at, transactions.certification_date, transactions.created_at')
                                     .count.values
      @pcr_pool_received[state] = pcr_pool_received

      pcr_pool_reviewed = Transaction.joins("JOIN pcr_reviews ON pcr_reviews.transaction_id = transactions.id").order('transactions.created_at DESC')
                                     .limit(50)
                                     .group('pcr_reviews.created_at,transactions.certification_date, transactions.created_at')
                                     .count.values
      @pcr_pool_reviewed[state] = pcr_pool_reviewed

      xray_pending_review_received = Transaction.joins("JOIN xray_pending_reviews ON xray_pending_reviews.transaction_id = transactions.id").order('transactions.created_at DESC')
                                                .limit(50)
                                                .group('xray_pending_reviews.created_at, transactions.certification_date, transactions.created_at')
                                                .count.values
      @xray_pending_review_received[state] = xray_pending_review_received

      xray_pending_review_reviewed = Transaction.joins("JOIN xray_pending_reviews ON xray_pending_reviews.transaction_id = transactions.id").order('transactions.created_at DESC')
                                                .limit(50)
                                                .group('xray_pending_reviews.transmitted_at, transactions.certification_date, transactions.created_at')
                                                .count.values
      @xray_pending_review_reviewed[state] = xray_pending_review_reviewed

      xray_pending_decision_received = Transaction.joins("JOIN xray_pending_decisions ON xray_pending_decisions.transaction_id = transactions.id").order('transactions.created_at DESC')
                                                  .limit(50)
                                                  .group('xray_pending_decisions.created_at, transactions.certification_date, transactions.created_at')
                                                  .count.values
      @xray_pending_decision_received[state] = xray_pending_decision_received

      xray_pending_decision_reviewed = Transaction.joins("JOIN xray_pending_decisions ON xray_pending_decisions.transaction_id = transactions.id").order('transactions.created_at DESC')
                                                  .limit(50)
                                                  .group('xray_pending_decisions.transmitted_at, transactions.certification_date, transactions.created_at')
                                                  .count.values
      @xray_pending_decision_reviewed[state] = xray_pending_decision_reviewed

    end

    @job_type = JobType.pluck(:name).compact.uniq
    job_type_with_ids = JobType.where(name: @job_type).pluck(:name, :id).to_h
    @job_type.each do |job|
      job_id = job_type_with_ids[job]

      total_fw_registration_count = Transaction.where(fw_job_type_id: job_id)
                                               .order(created_at: :desc)
                                               .limit(50)
                                               .count
      @total_fw_registration[job] = total_fw_registration_count

      examination_count = Transaction.where(fw_job_type_id: job_id)
                                     .where("EXTRACT(YEAR FROM medical_examination_date) = ? AND medical_examination_date < ?", Date.current.year, Date.current)
                                     .order(created_at: :desc)
                                     .limit(50)
                                     .count
      @examination_count[job] = examination_count

      certification_count = Transaction.where(fw_job_type_id: job_id)
                                       .where("EXTRACT(YEAR FROM medical_examination_date) = ? AND medical_examination_date < ?", Date.current.year, Date.current)
                                       .order(created_at: :desc)
                                       .limit(50)
                                       .count
      @certification_count[job] = certification_count

      xqcc_pool_received = Transaction.joins("JOIN xqcc_pools ON xqcc_pools.transaction_id = transactions.id").order('transactions.created_at DESC')
                                      .limit(50)
                                      .group('xqcc_pools.created_at, transactions.certification_date, transactions.created_at')
                                      .count.values
      @xqcc_pool_received[job] = xqcc_pool_received

      xqcc_pool_reviewed = Transaction.joins("JOIN xray_reviews ON xray_reviews.transaction_id = transactions.id").order('transactions.created_at DESC')
                                      .limit(50)
                                      .group('xray_reviews.transmitted_at, transactions.certification_date, transactions.created_at')
                                      .count.values
      @xqcc_pool_reviewed[job] = xqcc_pool_reviewed

      pcr_pool_received = Transaction.joins("JOIN pcr_pools ON pcr_pools.transaction_id = transactions.id").order('transactions.created_at DESC')
                                     .limit(50)
                                     .group('pcr_pools.created_at, transactions.certification_date, transactions.created_at')
                                     .count.values
      @pcr_pool_received[job] = pcr_pool_received

      pcr_pool_reviewed = Transaction.joins("JOIN pcr_reviews ON pcr_reviews.transaction_id = transactions.id").order('transactions.created_at DESC')
                                     .limit(50)
                                     .group('pcr_reviews.created_at,transactions.certification_date, transactions.created_at')
                                     .count.values
      @pcr_pool_reviewed[job] = pcr_pool_reviewed

      xray_pending_review_received = Transaction.joins("JOIN xray_pending_reviews ON xray_pending_reviews.transaction_id = transactions.id").order('transactions.created_at DESC')
                                                .limit(50)
                                                .group('xray_pending_reviews.created_at, transactions.certification_date, transactions.created_at')
                                                .count.values
      @xray_pending_review_received[job] = xray_pending_review_received

      xray_pending_review_reviewed = Transaction.joins("JOIN xray_pending_reviews ON xray_pending_reviews.transaction_id = transactions.id").order('transactions.created_at DESC')
                                                .limit(50)
                                                .group('xray_pending_reviews.transmitted_at, transactions.certification_date, transactions.created_at')
                                                .count.values
      @xray_pending_review_reviewed[job] = xray_pending_review_reviewed

      xray_pending_decision_received = Transaction.joins("JOIN xray_pending_decisions ON xray_pending_decisions.transaction_id = transactions.id").order('transactions.created_at DESC')
                                                  .limit(50)
                                                  .group('xray_pending_decisions.created_at, transactions.certification_date, transactions.created_at')
                                                  .count.values
      @xray_pending_decision_received[job] = xray_pending_decision_received

      xray_pending_decision_reviewed = Transaction.joins("JOIN xray_pending_decisions ON xray_pending_decisions.transaction_id = transactions.id").order('transactions.created_at DESC')
                                                  .limit(50)
                                                  .group('xray_pending_decisions.transmitted_at, transactions.certification_date, transactions.created_at')
                                                  .count.values
      @xray_pending_decision_reviewed[job] = xray_pending_decision_reviewed

    end

    @male_count = Transaction.where(fw_gender: 'M')
                             .order(created_at: :desc)
                             .limit(50)
                             .count

    @female_count = Transaction.where(fw_gender: 'F')
                               .order(created_at: :desc)
                               .limit(50)
                               .count

    @male_examination_count = Transaction.where(fw_gender: 'M')
                                         .where("EXTRACT(YEAR FROM medical_examination_date) = ? AND medical_examination_date < ?", Date.current.year, Date.current)
                                         .order(created_at: :desc)
                                         .limit(50)
                                         .count

    @female_examination_count = Transaction.where(fw_gender: 'F')
                                           .where("EXTRACT(YEAR FROM medical_examination_date) = ? AND medical_examination_date < ?", Date.current.year, Date.current)
                                           .order(created_at: :desc)
                                           .limit(50)
                                           .count

    @male_certification_count = Transaction.where(fw_gender: 'M')
                                           .where("EXTRACT(YEAR FROM medical_examination_date) = ? AND medical_examination_date < ?", Date.current.year, Date.current)
                                           .order(created_at: :desc)
                                           .limit(50)
                                           .count

    @female_certification_count = Transaction.where(fw_gender: 'F')
                                             .where("EXTRACT(YEAR FROM medical_examination_date) = ? AND medical_examination_date < ?", Date.current.year, Date.current)
                                             .order(created_at: :desc)
                                             .limit(50)
                                             .count

    @organizations = Organization.pluck(:name).uniq
    organization_with_ids = Organization.where(name: @organizations).pluck(:name, :id).to_h
    @organizations.each do |organization|
      organization_id = organization_with_ids[organization]

      total_fw_registration_count = Transaction.where(organization_id: organization_id)
                                               .order(created_at: :desc)
                                               .limit(50)
                                               .count
      @total_fw_registration[organization] = total_fw_registration_count

      examination_count = Transaction.where(organization_id: organization_id)
                                     .where("EXTRACT(YEAR FROM medical_examination_date) = ? AND medical_examination_date < ?", Date.current.year, Date.current)
                                     .order(created_at: :desc)
                                     .limit(50)
                                     .count
      @examination_count[organization] = examination_count

      certification_count = Transaction.where(organization_id: organization_id)
                                       .where("EXTRACT(YEAR FROM medical_examination_date) = ? AND medical_examination_date < ?", Date.current.year, Date.current)
                                       .order(created_at: :desc)
                                       .limit(50)
                                       .count
      @certification_count[organization] = certification_count

      xqcc_pool_received = Transaction.joins("JOIN xqcc_pools ON xqcc_pools.transaction_id = transactions.id").order('transactions.created_at DESC')
                                      .limit(50)
                                      .group('xqcc_pools.created_at, transactions.certification_date, transactions.created_at')
                                      .count.values
      @xqcc_pool_received[organization] = xqcc_pool_received

      xqcc_pool_reviewed = Transaction.joins("JOIN xray_reviews ON xray_reviews.transaction_id = transactions.id").order('transactions.created_at DESC')
                                      .limit(50)
                                      .group('xray_reviews.transmitted_at, transactions.certification_date, transactions.created_at')
                                      .count.values
      @xqcc_pool_reviewed[organization] = xqcc_pool_reviewed

      pcr_pool_received = Transaction.joins("JOIN pcr_pools ON pcr_pools.transaction_id = transactions.id").order('transactions.created_at DESC')
                                     .limit(50)
                                     .group('pcr_pools.created_at, transactions.certification_date, transactions.created_at')
                                     .count.values
      @pcr_pool_received[organization] = pcr_pool_received

      pcr_pool_reviewed = Transaction.joins("JOIN pcr_reviews ON pcr_reviews.transaction_id = transactions.id").order('transactions.created_at DESC')
                                     .limit(50)
                                     .group('pcr_reviews.created_at,transactions.certification_date, transactions.created_at')
                                     .count.values
      @pcr_pool_reviewed[organization] = pcr_pool_reviewed

      xray_pending_review_received = Transaction.joins("JOIN xray_pending_reviews ON xray_pending_reviews.transaction_id = transactions.id").order('transactions.created_at DESC')
                                                .limit(50)
                                                .group('xray_pending_reviews.created_at, transactions.certification_date, transactions.created_at')
                                                .count.values
      @xray_pending_review_received[organization] = xray_pending_review_received

      xray_pending_review_reviewed = Transaction.joins("JOIN xray_pending_reviews ON xray_pending_reviews.transaction_id = transactions.id").order('transactions.created_at DESC')
                                                .limit(50)
                                                .group('xray_pending_reviews.transmitted_at, transactions.certification_date, transactions.created_at')
                                                .count.values
      @xray_pending_review_reviewed[organization] = xray_pending_review_reviewed

      xray_pending_decision_received = Transaction.joins("JOIN xray_pending_decisions ON xray_pending_decisions.transaction_id = transactions.id").order('transactions.created_at DESC')
                                                  .limit(50)
                                                  .group('xray_pending_decisions.created_at, transactions.certification_date, transactions.created_at')
                                                  .count.values
      @xray_pending_decision_received[organization] = xray_pending_decision_received

      xray_pending_decision_reviewed = Transaction.joins("JOIN xray_pending_decisions ON xray_pending_decisions.transaction_id = transactions.id").order('transactions.created_at DESC')
                                                  .limit(50)
                                                  .group('xray_pending_decisions.transmitted_at, transactions.certification_date, transactions.created_at')
                                                  .count.values
      @xray_pending_decision_reviewed[organization] = xray_pending_decision_reviewed

    end

    @new_count = Transaction.where(registration_type: 0)
                            .order(created_at: :desc)
                            .limit(50)
                            .count

    @renewal_count = Transaction.where(registration_type: 1)
                                .order(created_at: :desc)
                                .limit(50)
                                .count

    @new_examination_count = Transaction.where(registration_type: 0)
                                        .where("EXTRACT(YEAR FROM medical_examination_date) = ? AND medical_examination_date < ?", Date.current.year, Date.current)
                                        .order(created_at: :desc)
                                        .limit(50)
                                        .count

    @renewal_examination_count = Transaction.where(registration_type: 1)
                                            .where("EXTRACT(YEAR FROM medical_examination_date) = ? AND medical_examination_date < ?", Date.current.year, Date.current)
                                            .order(created_at: :desc)
                                            .limit(50)
                                            .count

    @new_certification_count = Transaction.where(registration_type: 0)
                                          .where("EXTRACT(YEAR FROM medical_examination_date) = ? AND medical_examination_date < ?", Date.current.year, Date.current)
                                          .order(created_at: :desc)
                                          .limit(50)
                                          .count

    @renewal_certification_count = Transaction.where(registration_type: 1)
                                              .where("EXTRACT(YEAR FROM medical_examination_date) = ? AND medical_examination_date < ?", Date.current.year, Date.current)
                                              .order(created_at: :desc)
                                              .limit(50)
                                              .count

    @latest_transactions = Transaction.order(created_at: :desc).limit(50).pluck(:created_at).map { |date| date.strftime("%Y-%m-%d %H:%M:%S") }


    current_year = Date.current.year


    (0..4).each do |i|
      year = current_year - i
      raw_data_for_year = Transaction
                            .where(created_at: (Time.new(year, 1, 1)..Time.new(year, 12, 31, 23, 59, 59)))
                            .order(created_at: :desc)
                            .limit(50)
                            .pluck(:created_at, :medical_examination_date, :certification_date)
                            .map { |record| record.map { |date| date&.strftime("%Y-%m-%d %H:%M:%S") } }

      # Creating  instance variable dynamically
      instance_variable_set("@raw_data_#{year}", raw_data_for_year)
    end


    @sheet_data = generate_dynamic_sheet_data

    respond_to do |format|
      format.xlsx { render xlsx: 'excel_generate', filename: 'Report.xlsx' }
    end
  end

end

private

  def generate_dynamic_sheet_data
    current_year = Time.now.year
    years = (current_year.downto(current_year - 4)).to_a

    sheet_data = {}

    sheet_data['FW Reg. by Country'] = generate_sheet_data_for_category('FW Registration by Country', years)
    sheet_data['FW Reg. by State'] = generate_sheet_data_for_category('FW Registration by State', years)
    sheet_data['FW Reg. by Sector'] = generate_sheet_data_for_category('FW Registration by Sector', years)
    sheet_data['FW Reg. by Gender'] = generate_sheet_data_for_category('FW Registration by Gender', years)
    sheet_data['FW Reg. by Registration at'] = generate_sheet_data_for_category('FW Registration by Registration at', years)
    sheet_data['FW Reg. by FW Type'] = generate_sheet_data_for_category('FW Registration by FW Type', years)
    sheet_data['Trend of FW Reg. by year'] = ['Trend of FW registration by Year', ['Transaction date by Month', 'Transaction date by Day'] + years.map(&:to_s) + ['Count']]

    years.each do |year|
      sheet_name = "Raw Data #{year}"
      title = "Data #{year}"
      headers = [
        'Transaction Date (Month)', 'Medical Examination Date (Month)', 'Certification Date (Month)',
        'State', 'Country', 'Age', 'Gender', 'Registration at', 'Foreign Worker Type',
        'XQCC Pool (Film Received)', 'XQCC Pool (Film Reviewed)',
        'PCR Pool (Film Received)', 'PCR Pool (Film Reviewed)',
        'X-Ray Pending Review (Film Received)', 'X-Ray Pending Review (Film Reviewed)',
        'X-Ray Pending Decision (Film Received)', 'X-Ray Pending Decision (Film Reviewed)',
        'Medical Review (Received)', 'Medical Review (Reviewed)',
        'Final Result Released', 'Result Transmitted to Immigration',
        'Blocked FW', 'Appeal', 'FW Insured'
      ]

      sheet_data[sheet_name] = [title, headers]
    end

    sheet_data
  end

  def generate_sheet_data_for_category(category_name, years)
    [category_name, [category_name, 'Total FW Registration', 'FW went for medical examination', 'Certification', 'XQCC Pool (Film Received)', 'XQCC Pool (Film Reviewed)', 'PCR Pool (Film Received)', 'PCR Pool (Film Reviewed)', 'X-Ray Pending Review (Film Received)', 'X-Ray Pending Review (Film Reviewed)', 'X-Ray Pending Decision (Film Received)', 'X-Ray Pending Decision (Film Reviewed)', 'Medical Review (Received)', 'Medical Review (Reviewed)', 'Final Result Released', 'Result Transmitted to Immigration', 'Blocked FW', 'Appeal', 'FW Insured']]
  end

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
      # if transaction
      #   insurance_purchase_counts[transaction_id] = transaction.foreign_worker.insurance_purchases.count
      # else
      #   insurance_purchase_counts[transaction_id] = 0
      # end
    end
    insurance_purchase_counts.values.sum
  end


