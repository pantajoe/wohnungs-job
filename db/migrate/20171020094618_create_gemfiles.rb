class CreateGemfiles < ActiveRecord::Migration[5.1]
  def change
    create_table :gemfiles do |t|
      t.string :gemfile
      t.string :commit
      t.references :project, foreign_key: true

      t.timestamps
    end

    remove_column :projects, :gemfile
    remove_column :projects, :gemfile_last_update
  end
end
