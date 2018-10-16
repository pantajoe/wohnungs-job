class RenameVisibilityOfProjectsToArchived < ActiveRecord::Migration[5.2]
  def self.up
    rename_column :projects, :visibility, :archived
    change_column :projects, :archived, :boolean, default: false
    Project.find_each {|project| project.update(archived: !project.archived) }
  end

  def self.down
    rename_column :projects, :archived, :visibility
    change_column :projects, :visibility, :boolean, default: true
    Project.find_each {|project| project.update(visibility: !project.visibility) }
  end
end
