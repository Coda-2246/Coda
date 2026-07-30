class GigsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_gig, only: %i[show edit update destroy]

  def index
    @gigs = current_user.gigs.chronological
  end

  def show
    @entries = @gig.entries.order(entry_date: :desc)
  end

  def new
    @gig = current_user.gigs.new(start_date: Date.current)
  end

  def create
    @gig = current_user.gigs.new(gig_params)

    respond_to do |format|
      if @gig.save
        format.html { redirect_to @gig, notice: "Gig created." }
        format.turbo_stream
      else
        format.html { render :new, status: :unprocessable_entity }
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            "new_gig_quick_form",
            partial: "gigs/quick_create_form",
            locals: { gig: @gig }
          ), status: :unprocessable_entity
        end
      end
    end
  end

  def edit; end

  def update
    if @gig.update(gig_params)
      redirect_to @gig, notice: "Gig updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @gig.destroy
    redirect_to gigs_path, notice: "Gig deleted.", status: :see_other
  end

  private

  def set_gig
    @gig = current_user.gigs.find(params[:id])
  end

  def gig_params
    params.require(:gig).permit(
      :name, :venue, :city, :country_code,
      :start_date, :end_date, :fee_amount, :fee_currency, :status
    )
  end
end
