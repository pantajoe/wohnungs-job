class ChangeColumnInReports < ActiveRecord::Migration[5.1]
  def up
    remove_column :reports, :is_sent
    add_column :reports, :is_sent, :datetime
  end

  def down
    remove_column :reports, :is_sent
    add_column :reports, :is_sent, :boolean
  end
end
