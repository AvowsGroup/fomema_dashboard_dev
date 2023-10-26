class ThirdDashboardController < ApplicationController
  def index
    @task_list = tasks
    result_key
    page_number = params[:page] || 1
    @users = User.select(:name, :designation).paginate(page: page_number, per_page: 10)
  end

  def third_db_data
    @params = JSON.parse(params.keys.first)
    page_number = params[:page] || 1
    @task_list = tasks
    result_key
    @users = User.select(:name, :designation).paginate(page: page_number, per_page: 10)
  end

  private

  def result_key
    @kpi_data = {
      customer_service: @task_list.select { |hash| ["Email", "Chat", "Bypass fingerprint approval"].include?(hash[:task]) },
      support_service: @task_list.select { |hash| ["Employer Registration", "Agency Registration", "Foreign Worker Amendment", "Change Employer (transfer worker)", "Special Renewal Approval (unfit)", "Update Employer Detail Approval (Employer)"].include?(hash[:task]) },
      xray_quality: @task_list.select { |hash| ["Review - Normal chest X-ray", "Audit - Abnormal chest X-ray", "XQCC Amendment"].include?(hash[:task]) },
      laboratory_quality: @task_list.select { |hash| ["Laboratory"].include?(hash[:task]) },
      inspectorate: @task_list.select { |hash| ["Doctor Visit", "X-ray Visit"].include?(hash[:task]) },
      finance_admin: @task_list.select { |hash| ["Payment to service providers (Doctor, X-ray, Laboratory)", "Refund to Employers", "Insurance payment to Fomema Global Sdn Bhd"].include?(hash[:task]) },
      medical_review: @task_list.select { |hash| ["Appeal cases", "Pending Review Cases", "TCUPI Cases", "Employer Enquiry JIVO"].include?(hash[:task]) },
      regional_office: @task_list.select { |hash| ["Change of employer (transfer)", "Amendment of Foreign worker info", "Special Renewal Approval (unfit)", "Update employer details", "Employer Registration Approval"].include?(hash[:task]) },
      human_capital: @task_list.select { |hash| ["Staff Claims Submission"].include?(hash[:task]) },
      management: @task_list.select { |hash| ["Approval for registration of service provider", "Activating new service provider"].include?(hash[:task]) }
    }
  end

  def tasks
    @params ||= {}
    [
      {
        KPI: 0, # as there is no table mentioned in the doc
        task: 'Email',
        TAT: 'First response time within 24 business hours',
        target: '80%'
      },
      {
        KPI: 0, # as there is no table mentioned in the doc so pasting 0 in value
        task: 'Chat',
        TAT: 'First response time within 24 business hours ',
        target: '80%'
      },
      {
        KPI: 0,
        task: 'Bypass fingerprint approval',
        TAT: '24 business hours',
        target: '80%'
      },
      {
        KPI: kpi_percentage("Employer", 2),
        task: 'Employer Registration',
        TAT: '2wd',
        target: '80%'
      },
      {
        KPI: kpi_percentage("Agency", 14),
        task: 'Agency Registration',
        TAT: '14wd',
        target: '80%'
      },
      {
        KPI: kpi_percentage("ApprovalRequest", 3),
        task: 'Foreign Worker Amendment',
        TAT: '3wd',
        target: '80%'
      },
      {
        KPI: kpi_percentage("FwChangeEmployer", 3),
        task: 'Change Employer (transfer worker)',
        TAT: '3wd',
        target: '80%'
      },
      {
        KPI: kpi_percentage("ApprovalRequest", 2),
        task: 'Special Renewal Approval (unfit)',
        TAT: '2wd',
        target: '80%'
      },
      {
        KPI: kpi_percentage("ApprovalRequest", 3),
        task: 'Update Employer Detail Approval (Employer)',
        TAT: '3wd',
        target: '80%'
      },
      {
        KPI: review_xray,
        task: 'Review - Normal chest X-ray',
        TAT: '72 hours from the date of certification',
        target: '80%'
      },
      {
        KPI: pcr_xray,
        task: 'Audit - Abnormal chest X-ray',
        TAT: '48 hours from the date of certification',
        target: '80%'
      },
      {
        KPI: 0,
        task: 'XQCC Amendment',
        TAT: 'Four (4) weeks from the date of confirmation',
        target: '80%'
      },
      {
        KPI: 0, # as there is no table menthioned in the doc
        task: 'Laboratory',
        TAT: 'Calendar year',
        target: '100%'
      },
      {
        KPI: 0, # as there is no table menthioned in the doc
        task: 'Doctor Visit',
        TAT: 'Calendar year',
        target: '100%'
      },
      {
        KPI: 0, # as there is no table menthioned in the doc
        task: 'X-ray Visit',
        TAT: 'Calendar year',
        target: '100%'
      },
      {
        KPI: 0,
        task: 'Payment to service providers (Doctor, X-ray, Laboratory)',
        TAT: 'For every 7 working days, Finance team will generate data from Nios and transmit those data to Sage, our accounting system, to perform the payment processes.\n\nThe payments will be generated into 5 batches based on the certification dates:\n\na) 1st - 6th\nb) 7th - 12th\nc) 13th -18th\nd) 19th -24th\ne) 25th -30th',
        target: '100%'
      },
      {
        KPI: 0,
        task: 'Refund to Employers',
        TAT: '80%',
        target: ''
      },
      {
        KPI: 0,
        task: 'Insurance payment to Fomema Global Sdn Bhd',
        TAT: '100%',
        target: '80%'
      },
      {
        KPI: 0,
        task: 'Appeal cases',
        TAT: '28wd',
        target: '90%'
      },
      {
        KPI: 0,
        task: 'Pending Review Cases',
        TAT: '3wd',
        target: '90%'
      },
      {
        KPI: 0,
        task: 'TCUPI Cases',
        TAT: '28wd',
        target: '90%'
      },
      {
        KPI: 0, # data from CS new system
        task: 'Employer Enquiry JIVO',
        TAT: '24 hours',
        target: '100%'
      },
      {
        KPI: kpi_percentage("FwChangeEmployer", 3),
        task: 'Change of employer (transfer)',
        TAT: '3wd',
        target: '80%'
      },
      {
        KPI: kpi_percentage("ApprovalRequest", 3),
        task: 'Amendment of Foreign worker info',
        TAT: '3wd',
        target: '80%'
      },
      {
        KPI: kpi_percentage("ApprovalRequest", 3),
        task: 'Special Renewal Approval (unfit)',
        TAT: '3wd',
        target: '80%'
      },
      {
        KPI: kpi_percentage("ApprovalRequest", 3),
        task: 'Update employer details',
        TAT: '3wd',
        target: '80%'
      },
      {
        KPI: kpi_percentage("ApprovalRequest", 3),
        task: 'Employer Registration Approval',
        TAT: '2wd',
        target: '80%'
      },
      {
        KPI: 0, # Avows System (Claims Management)
        task: 'Staff Claims Submission',
        TAT: 'One Week from date HODs approved to HCM verification',
        target: '90%'
      },
      {
        KPI: 0,
        task: 'Approval for registration of service provider',
        TAT: '14wd',
        target: '80%'
      },
      {
        KPI: 0,
        task: 'Activating new service provider',
        TAT: '10wd',
        target: '80%'
      }
    ]
  end

  def kpi_percentage(model_name, tat)
    achieved_count = 0
    not_achieved_count = 0

    case model_name
    when "Employer"
      achieved_count = Employer.where("created_at <= registration_approved_at + interval '? days'", tat).count
      not_achieved_count = Employer.where("created_at > registration_approved_at + interval '? days'", tat).count

    when "Agencies"
      achieved_count = Agency.where("created_at <= registration_approved_at + interval '? days'", tat).count
      not_achieved_count = Agency.where("created_at > registration_approved_at + interval '? days'", tat).count

    when "ApprovalRequest"
      achieved_count = ApprovalRequest.where("approved_at <= requested_at + interval '? days'", tat).count
      not_achieved_count = ApprovalRequest.where("approved_at > requested_at + interval '? days'", tat).count

    when "FwChangeEmployer"
      achieved_count = FwChangeEmployer.where("approval_at <= requested_at + interval '? days'", tat).count
      not_achieved_count = FwChangeEmployer.where("approval_at > requested_at + interval '? days'", tat).count

    end

    total_count = achieved_count + not_achieved_count
    kpi_percentage = total_count > 0 ? (achieved_count.to_f / total_count) * 100 : 0
    kpi_percentage.round(1) # Round to one decimal place
  end

  def review_xray
    achieved_count = 0
    not_achieved_count = 0

    achieved_count = Transaction.joins("INNER JOIN xray_reviews ON xray_reviews.id = transactions.xray_review_id")
                                .where("xray_reviews.transmitted_at <= transactions.certification_date + INTERVAL '3' DAY")
                                .where("transactions.transaction_date BETWEEN ? AND ?", '2023-01-01', '2023-12-31')
                                .count

    not_achieved_count = Transaction.joins("INNER JOIN xray_reviews ON xray_reviews.id = transactions.xray_review_id")
                                    .where("xray_reviews.transmitted_at > transactions.certification_date + INTERVAL '3' DAY")
                                    .where("transactions.transaction_date BETWEEN ? AND ?", '2023-01-01', '2023-12-31')
                                    .count

    total_count = achieved_count + not_achieved_count
    kpi_percentage = total_count > 0 ? (achieved_count.to_f / total_count) * 100 : 0
    kpi_percentage.round(1) # Round to one decimal place

  end

  def pcr_xray
    achieved_count = 0
    not_achieved_count = 0

    achieved_count = PcrReview.joins("INNER JOIN transactions ON transactions.pcr_review_id = pcr_reviews.id")
                              .where("pcr_reviews.transmitted_at <= (transactions.certification_date + INTERVAL '2 days') AT TIME ZONE 'UTC'")
                              .where(transactions: { transaction_date: '2023-01-01'..'2023-12-31' })
                              .count

    not_achieved_count = PcrReview.joins("INNER JOIN transactions ON transactions.pcr_review_id = pcr_reviews.id")
                                  .where("pcr_reviews.transmitted_at > (transactions.certification_date + INTERVAL '2 days') AT TIME ZONE 'UTC'")
                                  .where(transactions: { transaction_date: '2023-01-01'..'2023-12-31' })
                                  .count

    total_count = achieved_count + not_achieved_count
    kpi_percentage = total_count > 0 ? (achieved_count.to_f / total_count) * 100 : 0
    kpi_percentage.round(1) # Round to one decimal place

  end

end


