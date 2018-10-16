class AddColumnsErrorRateErrorsCleanErrorsToPerformances < ActiveRecord::Migration[5.1]
  def up
    add_column :performances, :error_rate, :float
    add_column :performances, :clean_errors, :bigint
  end

  def down
    remove_column :performances, :error_rate
    remove_column :performances, :clean_errors
  end
end
