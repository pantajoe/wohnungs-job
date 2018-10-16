class AddForeignKeyToSentryErrors < ActiveRecord::Migration[5.1]
  def change
    change_table :sentry_errors do |t|
      t.references :project, foreign_key: true
    end
  end
end
