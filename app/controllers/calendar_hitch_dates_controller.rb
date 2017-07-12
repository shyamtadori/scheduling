class CalendarHitchDatesController < ApplicationController
  before_action :set_calendar_hitch_date, only: [:show, :edit, :update, :destroy]

  # GET /calendar_hitch_dates
  # GET /calendar_hitch_dates.json
  def index
    @calendar_hitch_dates = CalendarHitchDate.all
  end

  # GET /calendar_hitch_dates/1
  # GET /calendar_hitch_dates/1.json
  def show
  end

  # GET /calendar_hitch_dates/new
  def new
    @calendar_hitch_date = CalendarHitchDate.new
  end

  # GET /calendar_hitch_dates/1/edit
  def edit
  end

  # POST /calendar_hitch_dates
  # POST /calendar_hitch_dates.json
  def create
    @calendar_hitch_date = CalendarHitchDate.new(calendar_hitch_date_params)

    respond_to do |format|
      if @calendar_hitch_date.save
        format.html { redirect_to @calendar_hitch_date, notice: 'Calendar hitch date was successfully created.' }
        format.json { render :show, status: :created, location: @calendar_hitch_date }
      else
        format.html { render :new }
        format.json { render json: @calendar_hitch_date.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /calendar_hitch_dates/1
  # PATCH/PUT /calendar_hitch_dates/1.json
  def update
    respond_to do |format|
      if @calendar_hitch_date.update(calendar_hitch_date_params)
        format.html { redirect_to @calendar_hitch_date, notice: 'Calendar hitch date was successfully updated.' }
        format.json { render :show, status: :ok, location: @calendar_hitch_date }
      else
        format.html { render :edit }
        format.json { render json: @calendar_hitch_date.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /calendar_hitch_dates/1
  # DELETE /calendar_hitch_dates/1.json
  def destroy
    @calendar_hitch_date.destroy
    respond_to do |format|
      format.html { redirect_to calendar_hitch_dates_url, notice: 'Calendar hitch date was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_calendar_hitch_date
      @calendar_hitch_date = CalendarHitchDate.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def calendar_hitch_date_params
      params.require(:calendar_hitch_date).permit(:work_date, :cal_hitch_id)
    end
end
