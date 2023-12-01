class Transaction < ApplicationRecord
  belongs_to :job_type, foreign_key: 'fw_job_type_id'
  belongs_to :xray_review, foreign_key: 'xray_review_id'
  belongs_to :pcr_review, foreign_key: 'pcr_review_id'
  has_many :xray_pending_decision, class_name: "XrayPendingDecision"
  # belongs_to :xray_pending_review, foreign_key: 'xray_pending_review_id'
  belongs_to :country, class_name: 'Country', foreign_key: 'fw_country_id'
  belongs_to :organization, class_name: 'Organization', foreign_key: 'organization_id'
  belongs_to :doctor, class_name: 'Doctor', foreign_key: 'doctor_id'
  has_many :medical_appeals, class_name: 'MedicalAppeal'
  has_one :xqcc_pool, foreign_key: 'transaction_id'
  has_one :pcr_pool
  has_many :myimms_transactions
  belongs_to :foreign_worker, class_name: "ForeignWorker", foreign_key: "foreign_worker_id"
  has_many :xray_pending_review, class_name: "XrayPendingReview"
  belongs_to :laboratory_examination, foreign_key: 'id'
  belongs_to :xray_facility, foreign_key: 'xray_facility_id'
  enum registration_type: { new_registration: 0, renewal: 1 }

  def self.transaction_data_last_5_years

    current_year = Time.now.year

    # Batch query to get transactions for the last 5 years
    transactions = Transaction.where(created_at: (Time.new(current_year - 4, 1, 1)..Time.new(current_year, 12, 31, 23, 59, 59)))

    transaction_data_by_month = transactions.group_by { |t| [t.created_at.year, t.created_at.month] }
                                            .transform_values { |data| data.size }

    transaction_data_by_year = {}

    transaction_data_by_month.each do |(year, month), count|
      transaction_data_by_year[year] ||= Array.new(12, 0)
      transaction_data_by_year[year][month - 1] = count
    end
    sorted_transaction_data = transaction_data_by_year.sort.to_h

    sorted_transaction_data
  end

end

