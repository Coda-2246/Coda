module Users
  class RegistrationsController < Devise::RegistrationsController
    protected

    def after_sign_up_path_for(_resource)
      edit_company_path
    end
  end
end
