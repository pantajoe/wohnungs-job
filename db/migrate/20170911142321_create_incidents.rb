class CreateIncidents < ActiveRecord::Migration[5.1]
  def change
    create_table :incidents do |t|
      t.datetime :time_from
      t.datetime :time_to
      t.text :what_happened
      t.string :which_server
      t.text :realized_error
      t.text :solution
      t.text :impacts
      t.text :future_approach
      t.references :project, foreign_key: true

      t.timestamps
    end
  end
end
