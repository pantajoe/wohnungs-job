class AddSlugColumnToProjects < ActiveRecord::Migration[5.2]
  def self.up
    add_column :projects, :slug, :string

    # create slugs for all projects
    Project.find_each {|project| project.save(validate: false) }
  end

  def self.down
    remove_column :projects, :slug
  end
end
