class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  private

  def after_sign_up_path_for(resource)
    edit_company_path
  end
end
