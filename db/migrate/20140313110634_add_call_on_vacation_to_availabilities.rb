class AddCallOnVacationToAvailabilities < ActiveRecord::Migration
  def change
    add_column :availabilities, :call_on_vacation, :boolean, :default => true
  end
end
