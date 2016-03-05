class UsersController < ApplicationController
  load_and_authorize_resource :except =>[:create]
  before_action :set_user, only: [:show, :edit, :update, :destroy, :enable, :disable]

  def index
    authorize! :index, @user, :message => 'Not authorized as an administrator.'
    @users = User.all
  end

  def new
    authorize! :new, @user, :message => 'Not authorized as an administrator.'
    @user = User.new()
  end

  def create
    authorize! :create, @user, :message => 'Not authorized as an administrator.'
    @user = User.invite!(users_params)
    if @user.valid?
      redirect_to users_path, :notice => "User created."
    else
      flash[:alert] = "Unable to create user."
      render :new
    end
  end

  def edit
  end

  def show
  end

  def update
    @user = User.invite!(users_params) if params[:commit] == "Re-Send Invitation"
    authorize! :update, @user, :message => 'Not authorized as an administrator.'
    if @user.update_attributes(users_params)
      redirect_to users_path, :notice => "User updated."
    else
      flash[:alert] = "Unable to create user."
      render :edit
    end
  end

  def destroy
    authorize! :destroy, @user, :message => 'Not authorized as an administrator.'
    unless @user == current_user
      @user.disable!
      redirect_to users_path, :alert => "User disabled."
    else
      redirect_to users_path, :notice => "Can't disable yourself."
    end
  end

  def enable
    @user.enable!
    redirect_to users_path, :notice => "User is enabled."
  end

  def disable
    destroy
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
    # Never trust parameters from the scary internet, only allow the white list through.
    def users_params
      params.require(:user).permit(:name, :email, :enabled, :password, :role_id, {:facility_ids => []})
    end

end
