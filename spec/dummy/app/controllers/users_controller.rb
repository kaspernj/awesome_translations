class UsersController < ApplicationController
  before_filter :set_user

  def index
    @users = User.all
  end

  def show
  end

  def new
  end

  def edit
  end

private

  def set_user
    @user = User.find(params[:id].to_i) if params[:id].to_i > 0
  end
end
