class AddDeletedAtToFacilities < ActiveRecord::Migration
  def change
    add_column :facilities, :deleted_at, :datetime
  end
end
