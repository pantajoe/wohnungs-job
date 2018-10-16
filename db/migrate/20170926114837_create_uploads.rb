class CreateUploads < ActiveRecord::Migration[5.1]
  def change
    create_table :uploads do |t|
      t.datetime :date
      t.binary :file
      t.string :file_type
      t.references :project, foreign_key: true

      t.timestamps
    end
  end
end
