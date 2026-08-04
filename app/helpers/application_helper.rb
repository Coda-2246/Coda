module ApplicationHelper
  def money(amount, currency)
    "#{number_with_precision(amount || 0, precision: 2, delimiter: ',')} #{currency}"
  end

  def net_amount_color_class(amount)
    return "text-warning" if amount.zero?

    amount.positive? ? "text-success" : "text-danger"
  end

  def nav_active?(path)
    request.path == path || request.path.start_with?("#{path}/")
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
