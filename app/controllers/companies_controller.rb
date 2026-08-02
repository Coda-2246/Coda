class CompaniesController < ApplicationController
  def show
    @company = current_user.company

    redirect_to edit_company_path, alert: "Add your company details first." if @company.nil?
  end

  def edit
    @company = current_user.company || current_user.build_company
  end

  def update
    @company = current_user.company || current_user.build_company

    if @company.update(company_params)
      redirect_to company_path, notice: "Company details saved."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def company_params
    params.require(:company).permit(:company_name, :tax_id, :country_code, :default_currency)
  end
end
