class AddColumnVisibilityToProjects < ActiveRecord::Migration[5.1]
  def change
    add_column :projects, :visibility, :boolean, default: true
  end
end
