class SchedulesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_schedule, only: [:destroy]
  before_action :set_organization, only: [:index, :create, :monthly_schedule]
  before_action :set_base, only: [:index, :monthly_schedule]

  def index
    month = Date.today.month
    year = Date.today.year
    redirect_to "/schedules/#{month}/#{year}?org_unit=#{params[:org_unit]}"
  end

  # GET /schedules/:month/:year
  def monthly_schedule
    @start_date = "#{params[:year]}-#{params[:month]}-01".to_date
    @end_date = @start_date.end_of_month
    @no_of_days = (@end_date - @start_date).to_i + 1
    @month = params[:month]
    @year = params[:year]
    @bases = Location.active_bases(@organization.id)
    @jobs = Job.active_jobs_with_customers(@base, @organization)
    required_location_ids = ([@base.location_idx] if @base) || @bases.map(&:location_idx)
    @allotted_pilots = Schedule.allotted_pilots(@start_date, @end_date, required_location_ids)
  end

  # POST /schedules
  def create
    start_date = Date.strptime(params[:schedule][:schedule_date])
    org_unit = params[:org_unit]
    base_id = params[:filter_base_id]
    if params[:schedule_up_to] && valid_date?(params[:schedule_up_to])
      job = Job.find(params[:schedule][:job_idx])
      end_date = Date.strptime(params[:schedule_up_to], "%m/%d/%Y")
      errors = Schedule.create_schedules(start_date, end_date, job, schedule_params, params[:schedule_on_hitch], params[:schedule_on_free], @organization)
    else
      @schedule = Schedule.new(schedule_params)
      errors = @schedule.errors.full_messages if !@schedule.save
    end

    if !errors
      redirect_to "/schedules/#{start_date.month}/#{start_date.year}?org_unit=#{org_unit}&base_id=#{base_id}", notice: 'Schedule was successfully updated.'
    else
      render :status => 412, :json => {:errors => errors}
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

  # DELETE /schedules/:job_id/:user_id
  def destroy
    # start_date = Date.strptime(params[:date])
    # org_unit = params[:org_unit]
    # base_id = params[:base_id]
    if @schedule.destroy
      render :status => 200, :json => {message: 'Schedule updated successfully.'}
    else
      render :status => 500, :json => {message: 'Can not delete'}
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_schedule
      @schedule = Schedule.find_by(job_idx: params[:job_id], user_id: params[:user_id])
    end

    def set_organization
      org_unit = (params[:org_unit]) || Organization::ERA_ORGANIZATION_UNIT
      @organization = Organization.find(org_unit) rescue Organization.find(Organization::ERA_ORGANIZATION_UNIT)
      puts @organization.id
    end

    def set_base
      base_id = (params[:base_id]) || nil
      @base = Location.find_by_location_idx_and_org_unit(params[:base_id],@organization.org_unit) if base_id
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def schedule_params
      params.require(:schedule).permit(:schedule_date, :location_idx, :job_idx, :model_idx, :mission_id, :asset_idx, :assignment, :user_id, :status)
    end
end
