class DashboardController < ApplicationController
  def show
    @year  = (params[:year] || Date.current.year).to_i
    @years = current_user.entries.distinct.pluck(Arel.sql("EXTRACT(YEAR FROM entry_date)"))
                         .map(&:to_i).sort.reverse
    @years = [Date.current.year] if @years.empty?

    entries = current_user.entries.for_year(@year)

    @totals_by_country = entries.group(:country_code, :kind).sum(:amount_home)
    @income     = entries.income.sum(:amount_home)
    @expenses   = entries.expense.sum(:amount_home)
    @net        = @income - @expenses
    @unconverted = entries.where(amount_home: nil).count
  end
end
