class CalendarsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_calendar, only: [:show, :edit, :update, :destroy]


  # GET /calendars
  # GET /calendars.json
  def index
    @calendars = Calendar.all
  end

  # GET /calendars/1
  # GET /calendars/1.json
  def show
    @hitches = @calendar.hitches
  end

  # GET /calendars/new
  def new
    @calendar = Calendar.new
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

  # PATCH/PUT /calendars/1
  # PATCH/PUT /calendars/1.json
  def update
    @calendar.assign_attributes(calendar_params)
    if params[:calendar].has_key?(:effective_start_date)
      @calendar.effective_start_date = Date.strptime(params[:calendar][:effective_start_date], "%m/%d/%Y") rescue nil
    end
    if params[:calendar].has_key?(:effective_end_date)
      @calendar.effective_end_date = Date.strptime(params[:calendar][:effective_end_date], "%m/%d/%Y") rescue nil
    end
    respond_to do |format|
      if @calendar.save
        format.html { redirect_to @calendar, notice: 'Calendar was successfully updated.' }
        format.json { render :show, status: :ok, location: @calendar }
      else
        format.html { render :edit }
        format.json { render json: @calendar.errors, status: :unprocessable_entity }
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
      params.require(:calendar).permit(:name, :effective_start_date, :effective_end_date)
    end
end
