class CalendarsHitchesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_calendars_hitch, only: [:show, :edit, :update, :destroy]
  before_action :set_calendar
  # GET /calendars_hitches
  # GET /calendars_hitches.json
  def index
    @calendars_hitches = CalendarsHitch.all
  end

  # GET /calendars_hitches/1
  # GET /calendars_hitches/1.json
  def show
  end

  # GET /calendars_hitches/new
  def new
    @calendars_hitch = CalendarsHitch.new
    @calendar = Calendar.find(params[:calendar_id])
    @hitches = Hitch.joins('left outer join "CALENDARS_HITCHES" on "CALENDARS_HITCHES"."HITCH_ID" = "HITCHES"."HITCH_ID" and "CALENDARS_HITCHES"."CALENDAR_ID" = '+ @calendar.id.to_s).where('"CALENDARS_HITCHES"."CAL_HITCH_ID" is null')
  end

  # GET /calendars_hitches/1/edit
  def edit
    @hitches = Hitch.joins('left outer join "CALENDARS_HITCHES" on "CALENDARS_HITCHES"."HITCH_ID" = "HITCHES"."HITCH_ID" and "CALENDARS_HITCHES"."CALENDAR_ID" = '+ @calendar.id.to_s).where('"CALENDARS_HITCHES"."CAL_HITCH_ID" is null')
    @hitches << @calendars_hitch.hitch
    @calendar = Calendar.find(params[:calendar_id])
  end

  # POST /calendars_hitches
  # POST /calendars_hitches.json
  def create
    @calendars_hitch = @calendar.calendars_hitches.new(calendars_hitch_params)
  
    respond_to do |format|
      if @calendars_hitch.save
        format.html { redirect_to @calendar, notice: 'hitch was successfully added.' }
        format.json { render :show, status: :created, location: @calendars_hitch }
      else
        format.html { render :new }
        format.json { render json: @calendars_hitch.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /calendars_hitches/1
  # PATCH/PUT /calendars_hitches/1.json
  def update
    @calendars_hitch.assign_attributes(calendars_hitch_params)
    if !params[:calendars_hitch].key? :initial_days_on
      @calendars_hitch.initial_days_on = nil
    end
    if !params[:calendars_hitch].key? :initial_days_off
      @calendars_hitch.initial_days_off = nil
    end
    respond_to do |format|
      if @calendars_hitch.save
        format.html { redirect_to @calendar, notice: 'Calendars hitch was successfully updated.' }
        format.json { render :show, status: :ok, location: @calendar }
      else
        format.html { render :edit }
        format.json { render json: @calendars_hitch.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /calendars_hitches/1
  # DELETE /calendars_hitches/1.json
  def destroy
    @calendars_hitch.destroy
    respond_to do |format|
      format.html { redirect_to calendars_hitches_url, notice: 'Calendars hitch was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_calendars_hitch
      @calendars_hitch = CalendarsHitch.find(params[:id])
    end

    def set_calendar
      @calendar = Calendar.find(params[:calendar_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def calendars_hitch_params
      params.require(:calendars_hitch).permit(:calendar_id, :hitch_id, :initial_days_on, :initial_days_off)
    end
end
