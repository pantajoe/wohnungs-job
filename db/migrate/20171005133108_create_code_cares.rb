class CreateCodeCares < ActiveRecord::Migration[5.1]
  def change
    create_table :code_cares do |t|
      t.string :name
      t.string :platform
      t.string :version
      t.string :advisory_id
      t.string :title
      t.date :startdate
      t.date :enddate
      t.references :project, foreign_key: true

      t.timestamps
    end
  end
end
