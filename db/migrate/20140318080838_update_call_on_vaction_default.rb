class UpdateCallOnVactionDefault < ActiveRecord::Migration
  def change
    change_column :availabilities, :call_on_vacation, :boolean, :default => false
  end
end
