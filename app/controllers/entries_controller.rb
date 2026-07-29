class EntriesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_entry, only: %i[show edit update destroy]

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

    @entries = @entries.includes(:gig)
  end

  def show; end

  def new
    @entry = current_user.entries.new(
      entry_date: Date.current,
      currency: current_user.home_currency,
      kind: params[:kind] || "expense",
      gig_id: params[:gig_id]
    )
  end

  def create
    @entry = current_user.entries.new(entry_params)
    @entry.status = :confirmed

    if @entry.save
      redirect_to @entry, notice: "Entry logged."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def extract
    if params[:document].blank?
      return redirect_to entries_path, alert: "Choose a file to upload."
    end

    result = EntryExtractor.new(params[:document]).call

    @entry = current_user.entries.new(result.attributes)
    @entry.entry_date ||= Date.current
    @entry.currency ||= current_user.home_currency
    @entry.receipt.attach(result.blob)

    if @entry.save
      redirect_to edit_entry_path(@entry), notice: "Entry extracted — review and confirm the details."
    else
      render :new, status: :unprocessable_entity
    end
  rescue EntryExtractor::ExtractionFailed => e
    redirect_to entries_path, alert: "Couldn't read that document: #{e.message}"
  end

  def edit; end

  def update
    if @entry.update(entry_params)
      redirect_to @entry, notice: "Entry updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @entry.destroy
    redirect_to entries_path, notice: "Entry deleted.", status: :see_other
  end

  private

  def set_entry
    @entry = current_user.entries.find(params[:id])
  end

  def entry_params
    params.require(:entry).permit(
      :kind,
      :category,
      :description,
      :amount,
      :currency,
      :entry_date,
      :country_code,
      :gig_id,
      :receipt
    )
  end
end
