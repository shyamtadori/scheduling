class HolidaysController < ApplicationController
  before_action :set_holiday, only: [:show, :edit, :update, :destroy]
  # before_action :set_calendar, only: [:new, :create]

  # GET /holidays/new
  # def new
  #   @holiday = Holiday.new
  # end

  # GET /holidays/1/edit
  # def edit
  # end

  # POST /holidays
  # def create
  #   if params[:holiday].has_key?(:holiday_date)
  #     params[:holiday][:holiday_date] = Date.strptime(params[:holiday][:holiday_date], "%m/%d/%Y") rescue nil
  #   end
    
  #   @holiday = Holiday.new(holiday_params)
  #   respond_to do |format|
  #     if @holiday.save
  #       @calendar.holidays << @holiday
  #       format.html { redirect_to @calendar, notice: 'Holiday was successfully created.' }
  #       format.json { render :show, status: :created, location: @calendar }
  #     else
  #       format.html { render :new }
  #       format.json { render json: calendar_holiday.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # PATCH/PUT /holidays/1
  # def update
  #   respond_to do |format|
  #     if @holiday.update(holiday_params)
  #       format.html { redirect_to @holiday, notice: 'Holiday was successfully updated.' }
  #       format.json { render :show, status: :ok, location: @holiday }
  #     else
  #       format.html { render :edit }
  #       format.json { render json: @holiday.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # DELETE /holidays/1
  def destroy
    @holiday.destroy
    respond_to do |format|
      format.html { redirect_to holidays_url, notice: 'Holiday was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_holiday
      @holiday = Holiday.find(params[:id])
    end

    # def set_calendar
    #   @calendar = Calendar.find(params[:calendar])
    # end

    # Never trust parameters from the scary internet, only allow the white list through.
    def holiday_params
      params.require(:holiday).permit(:name, :description, :holiday_date)
    end
end
