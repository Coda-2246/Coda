class EntryExtractionSchema < RubyLLM::Schema
  string :kind, enum: Entry.kinds.keys,
    description: "Whether this document represents income received or an expense paid"

  string :category, required: false, enum: Entry.categories.keys,
    description: "Best-matching expense category. Omit for income."

  string :description, required: false,
    description: "Short description of the transaction, e.g. vendor name or purpose"

  number :amount,
    description: "Total amount as a positive number, without any currency symbol"

  string :currency, enum: Entry::CURRENCIES,
    description: "ISO 4217 currency code the amount is stated in"

  string :entry_date,
    description: "Date of the transaction, formatted as YYYY-MM-DD"

  string :country_code, required: false, enum: %w[GB DE FR AT US ES IT NL],
    description: "ISO 3166-1 alpha-2 country code where the transaction occurred, if identifiable"
end
