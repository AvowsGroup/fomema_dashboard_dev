json.extract! status_schedule, :id, :status_scheduleable_type, :status_scheduleable_id, :from, :to, :status, :status_reason, :comment, :previous_status, :previous_status_reason, :created_by, :updated_by, :previous_comment, :created_at, :updated_at
json.url status_schedule_url(status_schedule, format: :json)
