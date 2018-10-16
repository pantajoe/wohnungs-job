class AddForeignKeyIncidentLogReferencesIncident < ActiveRecord::Migration[5.1]
  def change
    change_table :incident_logs do |t|
      t.references :incident, foreign_key: true
    end
  end
end
