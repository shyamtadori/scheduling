class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = User.where("status <> 'INACTIVE'").order(:last_name)
  end
end