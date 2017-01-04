class PrivateController < ApplicationController

  before_action :before_action
  after_action :after_action
  
  
  private def before_action
    redirect_to root_path if !user_signed_in?
    @user = current_user
  end

  private def after_action
  end
end
