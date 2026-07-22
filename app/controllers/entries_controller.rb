class EntriesController < ApplicationController
  def index
    @entries = current_user.entries.left_joins(:gig).order(entry_date: :desc)

    if params[:query].present?
      query = "%#{params[:query]}%"

      @entries = @entries.where(
        "entries.description ILIKE :query
         OR entries.currency ILIKE :query
         OR entries.country_code ILIKE :query
         OR gigs.name ILIKE :query",
        query: query
      )
    end

    if params[:country].present?
      @entries = @entries.where(country_code: params[:country])
    end

    if params[:date_range].present?
      dates = params[:date_range].split(" to ")

      @entries = @entries.where("entry_date >= ?", dates.first) if dates.first.present?
      @entries = @entries.where("entry_date <= ?", dates.second) if dates.second.present?
    end
  end
end
