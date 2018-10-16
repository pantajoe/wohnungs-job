class RemoveColumnsTitleAndPlatformFromCodeCares < ActiveRecord::Migration[5.2]
  def self.up
    remove_column :code_cares, :title
    remove_column :code_cares, :platform
  end

  def self.down
    add_column :code_cares, :title, :string
    add_column :code_cares, :platform, :string
  end
end
