class ChangeColumnNames < ActiveRecord::Migration[5.1]
  def change
    rename_column :projects, :project_leader, :tech_name
    rename_column :projects, :customer, :email

    add_column :reports, :is_sent, :boolean, default: false
  end
end
