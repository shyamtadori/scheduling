class SchedulesController < ApplicationController
  before_action :set_schedule, only: [:show, :edit, :update, :destroy]

  # GET /schedules/:month/:year
  def monthly_schedule
    @start_date = "#{params[:year]}-#{params[:month]}-01".to_date
    @end_date = @start_date.end_of_month
    @no_of_days = (@end_date - @start_date).to_i + 1
    @month = params[:month]
    @year = params[:year]
    @jobs = Job.limit(100)
  end

  # POST /schedules
  def create
    puts '::::::::::::::::::::::::::::::::::::::::::::::::::;CREATE'
    @schedule = Schedule.new(schedule_params)

    job = Job.find(@schedule.job_idx)

    respond_to do |format|
      if @schedule.save
        format.html { redirect_to "/schedules/#{@schedule.schedule_date.month}/#{@schedule.schedule_date.year}", notice: 'Schedule was successfully updated.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /schedules/1
  # PATCH/PUT /schedules/1.json
  # def update
  #   respond_to do |format|
  #     if @schedule.update(schedule_params)
  #       format.html { redirect_to @schedule, notice: 'Schedule was successfully updated.' }
  #       format.json { render :show, status: :ok, location: @schedule }
  #     else
  #       format.html { render :edit }
  #       format.json { render json: @schedule.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # DELETE /schedules/1
  # DELETE /schedules/1.json
  # def destroy
  #   @schedule.destroy
  #   respond_to do |format|
  #     format.html { redirect_to schedules_url, notice: 'Schedule was successfully destroyed.' }
  #     format.json { head :no_content }
  #   end
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_schedule
      @schedule = Schedule.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def schedule_params
      params.require(:schedule).permit(:schedule_date, :location_idx, :job_idx, :model_idx, :mission_id, :asset_idx, :pic_id, :sic_id, :user_id, :status)
    end
end
