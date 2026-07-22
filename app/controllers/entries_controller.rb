class EntriesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_entry, only: %i[show edit update destroy]

  def index
    @entries = current_user.entries.left_joins(:gig).order(entry_date: :desc)
    # ... existing filter blocks unchanged ...
    @entries = @entries.includes(:gig)
  end

  # ↓ everything below is new

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
      :kind, :category, :description, :amount, :currency,
      :entry_date, :country_code, :gig_id, :receipt
    )
  end
end
