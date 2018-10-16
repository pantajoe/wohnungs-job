class CreateProjects < ActiveRecord::Migration[5.1]
  def change
    create_table :projects do |t|
      t.string :title
      t.string :project_leader
      t.text :comment

      t.timestamps
    end
  end
end
