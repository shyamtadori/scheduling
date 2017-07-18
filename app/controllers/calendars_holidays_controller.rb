class CalendarsHolidaysController < ApplicationController
  before_action :set_calendars_holiday, only: [:show, :edit, :update, :destroy]
  before_action :set_calendar

  # GET /calendars_holidays
  def index
    @calendars_holidays = CalendarsHoliday.all
  end

  # GET /calendars_holidays/1
  def show
  end

  # GET /calendars_holidays/new
  def new
    @all_holidays = Holiday.order("holiday_date desc")
    @calendar_holidays = @calendar.holidays.pluck(:holiday_id)
    @calendars_holiday = CalendarsHoliday.new
  end

  # GET /calendars_holidays/1/edit
  def edit
  end

   # POST /calendars_holidays
  def create
    existing_holiday_ids = @calendar.holidays.pluck(:holiday_id)

    if params.has_key?(:calendar_holidays)
      selected_holiday_ids = params[:calendar_holidays][:checkbox_holiday_ids].map(&:to_i)
    else
      selected_holiday_ids = []
    end

    deleted_holiday_ids = existing_holiday_ids - selected_holiday_ids

    CalendarsHoliday.where("calendar_id = ? and holiday_id in (?)", @calendar.id, deleted_holiday_ids).destroy_all if deleted_holiday_ids.length > 0

    new_holiday_ids = selected_holiday_ids - existing_holiday_ids

    new_holiday_ids.each do |new_holiday_id|
      @calendar.holidays << Holiday.where(:holiday_id => new_holiday_id).first
    end
    
    respond_to do |format|
      format.html { redirect_to @calendar, notice: 'Holidays updated successfully.' }
    end
  end

  # PATCH/PUT /calendars_holidays/1
  def update
    respond_to do |format|
      if @calendars_holiday.update(calendars_holiday_params)
        format.html { redirect_to @calendars_holiday, notice: 'Calendars holiday was successfully updated.' }
        format.json { render :show, status: :ok, location: @calendars_holiday }
      else
        format.html { render :edit }
        format.json { render json: @calendars_holiday.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /calendars_holidays/1
  def destroy
    @calendars_holiday.destroy
    respond_to do |format|
      format.html { redirect_to calendars_holidays_url, notice: 'Calendars holiday was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_calendars_holiday
      @calendars_holiday = CalendarsHoliday.find(params[:id])
    end

    def set_calendar
      @calendar = Calendar.find(params[:calendar_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def calendars_holiday_params
      params.require(:calendars_holiday).permit(:calendar_id, :holiday_id)
    end
end
