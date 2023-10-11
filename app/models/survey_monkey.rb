class SurveyMonkey < ApplicationRecord
	 def self.transaction_data_1_years
    # Get the current year
    current_year = Time.now.year

    # Initialize a hash to store the data
    transaction_data_by_year = {}

    # Loop through the last 5 years
    (current_year..current_year).each do |year|
      # Initialize a hash to store transaction counts for each month of the current year
      transactions_by_month = Hash.new(0)

      # Query the database to get transactions for the current year
      transactions = Transaction.where("EXTRACT(YEAR FROM created_at) = ?", year)

      # Loop through the transactions and organize the data by month
      transactions.each do |transaction|
        month = transaction.created_at.month
        transactions_by_month[month] += 1
      end

      # Create an array to store transaction counts for each month
      transaction_counts_per_month = (1..12).map { |month| transactions_by_month[month] }

      # Store the data in the hash
      transaction_data_by_year[year] = transaction_counts_per_month
    end

    # Return the transaction data as a hash
    transaction_data_by_year
 
end 
end
