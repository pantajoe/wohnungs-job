class AddColumnGemfileLastUpdatedToProject < ActiveRecord::Migration[5.1]
  def change
    add_column :projects, :gemfile_last_update, :datetime
  end
end
