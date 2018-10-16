class AddCustomerToProjekt < ActiveRecord::Migration[5.1]
  def up
    add_column :projects, :customer, :string
  end

  def down
    remove_column :projects, :customer
  end
end
