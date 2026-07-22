module DashboardHelper
  def country_name(code)
    return "Unassigned" if code.blank?

    {
      "GB" => "United Kingdom", "DE" => "Germany", "FR" => "France",
      "AT" => "Austria", "US" => "United States", "ES" => "Spain",
      "IT" => "Italy", "NL" => "Netherlands"
    }.fetch(code, code)
  end

  def money(amount, currency)
    "#{number_with_precision(amount || 0, precision: 2, delimiter: ',')} #{currency}"
  end
end
