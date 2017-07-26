class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :add_hitches, :hitches_update]

  def index
    @users = User.where("status <> 'INACTIVE'").order(:last_name)
    @customers = Customer.active
  end

  def show
  	@associated_hitches = @user.pilots_hitches.includes(:hitch)

    existing_calendar_hitch_ids = @user.calendars_hitches.pluck(:cal_hitch_id).map(&:to_s)
  	@work_days = CalendarHitchDate.where('CAL_HITCH_ID IN (?)',existing_calendar_hitch_ids).group('WORK_DATE').pluck(:WORK_DATE).map(&:to_date)
    user_working_dates = @user.calendar_hitch_dates.includes(:calendars_hitch => :hitch).order("work_date asc")

  	@days_hash = {}
    user_working_dates.each do |record|
  		if @days_hash[record.work_date.to_date]
  			@days_hash[record.work_date.to_date] += [record.calendars_hitch.hitch.name] 
  		else
  			@days_hash[record.work_date.to_date] = [record.calendars_hitch.hitch.name] 
  		end
  	end

  	# calendar_ids = @user.calendars.pluck(:calendar_id).map(&:to_s)
    # @start_date = Calendar.where('CALENDAR_ID in (?)',calendar_ids).minimum('effective_start_date').to_datetime
    # @end_date = Calendar.where('CALENDAR_ID in (?)',calendar_ids).maximum('effective_end_date').to_datetime
    today = Date.today
    @start_date = today.beginning_of_year
    @end_date = today.end_of_year
    
    @holidays = @user.holidays.pluck(:holiday_date).map(&:to_date)
  end

  def add_hitches
  	@unassociated_hitches = Hitch.joins('left outer join "PILOTS_HITCHES" on "PILOTS_HITCHES"."HITCH_ID" = "HITCHES"."HITCH_ID" and "PILOTS_HITCHES"."USER_ID" = '+ @user.id.to_s).where('"PILOTS_HITCHES"."USER_ID" is null')
  end

  def hitches_update
  	if user_params.key? 'hitch_ids'
      params[:user][:hitch_ids] = user_params[:hitch_ids] + @user.hitches.pluck(:hitch_id).map(&:to_s)
      if valid_date?(params[:effective_start_date]) && valid_date?(params[:effective_end_date])
        selected_start_date = params[:effective_start_date]
        selected_end_date = params[:effective_end_date]
      else
        selected_start_date = Date.today.strftime("%m/%d/%Y")
        selected_end_date = (Date.today + 1.month).strftime("%m/%d/%Y")
      end
      params[:effective_start_date] = selected_start_date
      params[:effective_end_date] = selected_start_date
    end

    respond_to do |format|
      if @user.update(user_params)
        @user.pilots_hitches.where(effective_start_date: nil, effective_end_date: nil)
                         .update_all(:effective_start_date => Date.strptime(selected_start_date, "%m/%d/%Y"),
                                     :effective_end_date => Date.strptime(selected_end_date, "%m/%d/%Y"))
        
        format.html { redirect_to @user, notice: 'Hitches added successfully.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def available_pilots
    puts params[:job_id]
    puts params[:date]
    @schedule = Schedule.new
    @users = User.all
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:hitch_ids => [], pilots_hitches_attributes: [:hitch_id, :user_id, :effective_start_date, :effective_end_date])
    end
end