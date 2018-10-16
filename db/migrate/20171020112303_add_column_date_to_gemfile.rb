class AddColumnDateToGemfile < ActiveRecord::Migration[5.1]
  def change
    add_column :gemfiles, :date, :date
  end
end
