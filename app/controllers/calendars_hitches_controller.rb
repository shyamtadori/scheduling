class CalendarsHitchesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_calendars_hitch, only: [:show, :edit, :update, :destroy]

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
  end

  # GET /calendars_hitches/1/edit
  def edit
    @calendar = Calendar.find(params[:calendar_id])
  end

  # POST /calendars_hitches
  # POST /calendars_hitches.json
  def create
    @calendars_hitch = CalendarsHitch.new(calendars_hitch_params)
    @calendar = Calendar.find(params[:calendars_hitch][:calendar_id])

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
    respond_to do |format|
      if @calendars_hitch.update(calendars_hitch_params)
        format.html { redirect_to @calendars_hitch, notice: 'Calendars hitch was successfully updated.' }
        format.json { render :show, status: :ok, location: @calendars_hitch }
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

    # Never trust parameters from the scary internet, only allow the white list through.
    def calendars_hitch_params
      params.require(:calendars_hitch).permit(:calendar_id, :hitch_id, :initial_days_on, :initial_days_off)
    end
end
