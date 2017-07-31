class CalendarsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_calendar, only: [:show, :add_holidays, :edit, :update, :holidays_update, :destroy]


  # GET /calendars
  # GET /calendars.json
  def index
    @calendars = Calendar.all
  end

  # GET /calendars/1
  # GET /calendars/1.json
  def show
    @calendars_hitches = @calendar.calendars_hitches.includes(:hitch)
    @calendar_holidays = @calendar.calendars_holidays.includes(:holiday)
  end

  # GET /calendars/new
  def new
    @calendar = Calendar.new
  end

  def add_holidays
    all_between_holidays = Holiday.time_between(@calendar.effective_start_date, @calendar.effective_end_date).order("holiday_date desc")
    associated_holiday_ids = CalendarsHoliday.where(calendar_id: @calendar.id).pluck(:holiday_id)
    if associated_holiday_ids.length > 0
      @unassociated_holidays = all_between_holidays.where("holiday_id not in (?)", associated_holiday_ids)
    else
      @unassociated_holidays = all_between_holidays
    end
    # @unassociated_holidays = Holiday.joins('left outer join "CALENDARS_HOLIDAYS" on "CALENDARS_HOLIDAYS"."HOLIDAY_ID" = "HOLIDAYS"."HOLIDAY_ID" and "CALENDARS_HOLIDAYS"."CALENDAR_ID" = '+ @calendar.calendar_id.to_s).where('"CALENDARS_HOLIDAYS"."CALENDAR_ID" is null and "HOLIDAYS"."HOLIDAY_DATE" >= '+ '"#{@calendar.effective_start_date}"' + ' and "HOLIDAYS"."HOLIDAY_DATE" <= '+ '"#{@calendar.effective_end_date}"').order('"HOLIDAYS"."HOLIDAY_DATE"')
  end

  # GET /calendars/1/edit
  def edit
  end

  # POST /calendars
  # POST /calendars.json
  def create
    @calendar = Calendar.new(calendar_params)
    if params[:calendar].has_key?(:effective_start_date)
      @calendar.effective_start_date = Date.strptime(params[:calendar][:effective_start_date], "%m/%d/%Y") rescue nil
    end
    if params[:calendar].has_key?(:effective_end_date)
      @calendar.effective_end_date = Date.strptime(params[:calendar][:effective_end_date], "%m/%d/%Y") rescue nil
    end
    respond_to do |format|
      if @calendar.save
        format.html { redirect_to @calendar, notice: 'Calendar was successfully created.' }
        format.json { render :show, status: :created, location: @calendar }
      else
        format.html { render :new }
        format.json { render json: @calendar.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH /calendars/1/holidays_update
  def holidays_update
    if calendar_params.key? 'holiday_ids'
      is_holiday_update = true
      params[:calendar][:holiday_ids] = calendar_params[:holiday_ids] + @calendar.holidays.pluck(:holiday_id).map(&:to_s)
    end
    respond_to do |format|
      if @calendar.update(calendar_params)# @calendar.save
        format.html { redirect_to @calendar, notice:  "Holidays updated successfully."}
        format.json { render :show, status: :ok, location: @calendar }
      else
        format.html { render :add_holidays }
      end
    end
  end

  # PATCH/PUT /calendars/1
  # PATCH/PUT /calendars/1.json
  def update
    if params[:calendar].has_key?(:effective_start_date)
      params[:calendar][:effective_start_date] = Date.strptime(params[:calendar][:effective_start_date], "%m/%d/%Y") rescue nil
    end
    if params[:calendar].has_key?(:effective_end_date)
      params[:calendar][:effective_end_date] = Date.strptime(params[:calendar][:effective_end_date], "%m/%d/%Y") rescue nil
    end
    respond_to do |format|
      if @calendar.update(calendar_params)# @calendar.save
        format.html { redirect_to @calendar, notice: "Calendar was successfully updated."}
        format.json { render :show, status: :ok, location: @calendar }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /calendars/1
  # DELETE /calendars/1.json
  def destroy
    @calendar.destroy
    respond_to do |format|
      format.html { redirect_to calendars_url, notice: 'Calendar was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_calendar
      @calendar = Calendar.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def calendar_params
      params.require(:calendar).permit(:org_unit, :name, :effective_start_date, :effective_end_date, :holiday_ids => [], calendars_holidays_attributes: [:calendar_id, :holiday_id], holidays_attributes: [:name, :description, :holiday_date])
    end
end
