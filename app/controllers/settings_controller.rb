class SettingsController < ApplicationController
  before_action :authenticate_user!

  def index
    @family = current_user.family
    @users = @family.users
  end
end
