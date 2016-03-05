class AddFieldToEmployee < ActiveRecord::Migration
  def change
  	add_column :employees, :hire_date, :date
  	add_column :employees, :sin, :string
  	add_column :employees, :date_of_birth, :date
  	add_column :employees, :email, :string
  	add_column :employees, :address, :string
  	add_column :employees, :hourly_rate, :string
  	add_column :employees, :group, :string
  	add_column :employees, :registration_expiry, :date
  	add_column :employees, :first_aid_expiry, :date
  	add_column :employees, :whmis_expiry, :date
  	add_column :employees, :food_safe_expiry, :date
  	add_column :employees, :nvci_expiry, :date
  	add_column :employees, :crc_expiry, :date
  	add_column :employees, :evaluation_due, :date
  end
end
