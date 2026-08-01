class TaxAdviser
  class AdviserFailed < StandardError; end

  def initialize(user, question)
    @user = user
    @question = question
  end

  def call
    RubyLLM.chat.ask(prompt).content
  rescue RubyLLM::Error, RubyLLM::ConfigurationError => e
    raise AdviserFailed, e.message
  end

  private

  attr_reader :user, :question

  def prompt
    <<~PROMPT
      You are Coda's tax adviser for an international freelancer.

      Answer using only the financial data provided below.

      Give clear and practical insights about:
      - income
      - expenses
      - gigs
      - countries
      - profitability
      - possible tax considerations

      Formatting rules:
      - Use short headings.
      - Use bullet points where useful.
      - Use Markdown bold with **text** for important figures.
      - Use only 1 to 3 helpful emojis in the whole answer.
      - Keep the answer concise and easy to scan.

      Do not claim to be a licensed tax professional.
      Do not invent tax rates or laws.
      Recommend professional advice when country-specific rules are required.

      User home currency: #{user.home_currency}

      Gigs:
      #{gigs_data}

      Entries:
      #{entries_data}

      User question:
      #{question}
    PROMPT
  end

  def gigs_data
    user.gigs.map do |gig|
      "#{gig.name} | #{gig.country_code} | #{gig.status} | " \
      "income: #{gig.total_income} | expenses: #{gig.total_expenses} | net: #{gig.net}"
    end.join("\n")
  end

  def entries_data
    user.entries.includes(:gig).map do |entry|
      "#{entry.entry_date} | #{entry.kind} | #{entry.category} | " \
      "#{entry.amount} #{entry.currency} | home amount: #{entry.amount_home} | " \
      "country: #{entry.country_code} | gig: #{entry.gig&.name} | #{entry.description}"
    end.join("\n")
  end
end
