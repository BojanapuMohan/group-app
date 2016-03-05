module ControllerHelpers
  def sign_in(user = build_stubbed(:user))
    if user.nil?
      request.env['warden'].stub(:authenticate!).
        and_throw(:warden, {:scope => :user})
      controller.stub :current_user => false
    else
      request.env['warden'].stub :authenticate! => user
      controller.stub :current_user => user
    end
  end

  def sign_in_admin
    admin = build_stubbed(:user)
    admin.add_role :administrator
    sign_in(admin)
  end
end

