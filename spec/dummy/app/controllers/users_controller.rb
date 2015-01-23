class UsersController < ApplicationController
  before_filter :set_user

  def index
    @users = User.all
  end

  def show
  end

  def new
  end

  def create
    if @user.save
      flash[:notice] = t(".user_was_created")
      redirect_to user_path(@user)
    else
      flash[:error] = @user.errors.full_messages.join(". ")
      render :new
    end
  end

  def edit
  end

private

  def set_user
    @user = User.find(params[:id].to_i) if params[:id].to_i > 0
  end
end
