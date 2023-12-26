class Dashboards::DepartmentConfigurationController < ApplicationController

  def index
    @department_info = DepartmentConfiguration.new
    render partial: 'dashboards/dep_information/department_configuration', locals: { filtered_records: @filtered_records }

    @task_details = DepartmentInformation.all

    @task_details.each do |task_detail|
      # Check if a record with the same task already exists in DepartmentConfiguration
      existing_record = DepartmentConfiguration.find_by(task: task_detail.task, category: task_detail.service)

      unless existing_record
        # If no record exists, create a new one
        DepartmentConfiguration.create(
          category: task_detail.service, # Use task_detail.service for the category column
          task: task_detail.task,
          tat: task_detail.tat,
          target: task_detail.target,
          kpi: task_detail.kpi
        # Add other attributes as needed
        )
      end
    end

    @department_details = DepartmentConfiguration.all.to_a

  end

  def filter_data
    selected_category = params[:category]
    selected_status = params[:status]

    if selected_category.present? && selected_status.present?
      @filtered_records = DepartmentConfiguration.where(category: selected_category, status: selected_status)
    elsif selected_category.present?
      @filtered_records = DepartmentConfiguration.where(category: selected_category)
    elsif selected_status.present?
      @filtered_records = DepartmentConfiguration.where(status: selected_status)
    end

    render partial: 'dashboards/dep_information/table_partial', locals: { filtered_records: @filtered_records }
  end

  def calculate_kpi
    model_name = params[:model_name]
    tat = params[:tat]
    task = params[:task]
    category = params[:category]
    target = params[:target]
    user = params[:user]
    status = params[:status]

    # binding.pry
    @department_configuration = DepartmentConfiguration.find_or_create_by(category: category, task: task)

    dep_information_controller = Dashboards::DepInformationController.new
    dep_information_controller.request = request

    if @department_configuration
      if tat.match?(/\A\d+\z/)
        kpi = dep_information_controller.kpi_percentage(model_name, tat.to_i)
      else
        kpi = @department_configuration.kpi
        tat = @department_configuration.tat
      end

      @department_configuration.update(kpi: kpi, tat: tat, task: task, category: category, target: target, user: user, status: status)
      render json: {
        id: @department_configuration.id,
        kpi: kpi,
        category: @department_configuration.category,
        task: @department_configuration.task,
        tat: @department_configuration.tat,
        target: @department_configuration.target
      }
    else
      render json: { error: 'Record not found' }, status: :not_found
    end
  end

  def edit
    render 'dashboards/dep_information/edit_department_configuration'
  end

  def audit_logs
    render 'dashboards/dep_information/department_audit_logs'
  end

  def filter_audit_logs
    date_from = Date.parse(params[:date_from].to_s)
    date_to = Date.parse(params[:date_to].to_s).end_of_day
    @filtered_logs = AuditLog.where(created_at: date_from.beginning_of_day..date_to)

    render partial: 'dashboards/dep_information/audit_logs_partial', locals: { filtered_records: @filtered_logs }
  end
end