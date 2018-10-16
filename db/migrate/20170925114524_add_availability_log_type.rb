class AddAvailabilityLogType < ActiveRecord::Migration[5.1]
  def up
    add_column :availability_logs, :log_type, :string
  end

  def down
    remove_column :availability_logs, :log_type
  end
end
