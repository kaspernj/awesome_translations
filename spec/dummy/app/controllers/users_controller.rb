class UsersController < ApplicationController
  before_action :set_user

  def index
    @users = User.all
  end

  def show; end

  def new; end

  def create
    if @user.save
      flash[:notice] = t(".user_was_created")
      redirect_to user_path(@user)
    else
      flash[:error] = @user.errors.full_messages.join(". ")
      render :new
    end
  end

  def edit; end

  def update
    if @user.update_attributes(user_params)
      flash[:notice] = controller_t(".user_was_updated")
      redirect_to user_path(@user)
    else
      flash[:error] = @user.errors.full_messages.join(". ")
      render :edit
    end
  end

private

  def set_user
    @user = User.find(params[:id].to_i) if params[:id].to_i > 0
  end

  def user_params
    params.require(:user).permit(:email)
  end
end
