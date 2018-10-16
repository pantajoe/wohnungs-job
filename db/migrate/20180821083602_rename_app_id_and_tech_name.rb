class RenameAppIdAndTechName < ActiveRecord::Migration[5.2]
  def self.up
    rename_column :projects, :tech_name, :repo_name
    rename_column :projects, :app_id, :appsignal_id
  end

  def self.down
    rename_column :projects, :repo_name, :tech_name
    rename_column :projects, :appsignal_id, :app_id
  end
end
