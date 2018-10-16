class ChangePerformanceDate < ActiveRecord::Migration[5.1]
  def change
    remove_column :performances, :date
    add_column :performances, :date, :date
  end

  def down
    remove_column :performances, :date
    add_column :performances, :date, :datetime
  end
end
