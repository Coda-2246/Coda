module ApplicationHelper
  def money(amount, currency)
    "#{number_with_precision(amount || 0, precision: 2, delimiter: ',')} #{currency}"
  end

  def country_name(code)
    {
      "GB" => "United Kingdom",
      "DE" => "Germany",
      "FR" => "France",
      "US" => "United States",
      "CH" => "Switzerland"
    }.fetch(code, code.presence || "Unassigned")
  end
end
