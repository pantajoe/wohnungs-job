class ChangeColumnNameAndTypeForComment < ActiveRecord::Migration[5.1]
  def change
    change_table :projects do |t|
      t.rename :comment, :customer
    end
    change_column :projects, :customer, :string
  end
end
