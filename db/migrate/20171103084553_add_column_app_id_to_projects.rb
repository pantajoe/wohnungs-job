class AddColumnAppIdToProjects < ActiveRecord::Migration[5.1]
  def change
    add_column :projects, :app_id, :string
  end

  def down
    remove_column :projects, :app_id
  end
end
