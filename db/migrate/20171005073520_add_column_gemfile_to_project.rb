class AddColumnGemfileToProject < ActiveRecord::Migration[5.1]
  def change
    add_column :projects, :gemfile, :text
  end
end
