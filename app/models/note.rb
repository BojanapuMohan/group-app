class Note < ActiveRecord::Base

	belongs_to :employee

	def user_name(user_id)
		User.find(user_id).name
    end
	
end
