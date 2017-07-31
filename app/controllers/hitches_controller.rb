class HitchesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_hitch, only: [:show, :add_pilots, :edit, :update, :pilots_update, :destroy]

  # GET /hitches
  def index
    @hitches = Hitch.all
  end

  # GET /hitches/1
  def show
    # @pilots = @hitch.pilots
    @pilots_hitches = @hitch.pilots_hitches.includes(:pilot)
  end

  # GET /hitches/new
  def new
    @hitch = Hitch.new
  end


  # GET /hitches/:id/add_pilots
  def add_pilots
    # @unassociated_pilots = User.joins('left outer join "PILOTS_HITCHES" on "PILOTS_HITCHES"."USER_ID" = "TRN_USERS"."USER_ID" and "PILOTS_HITCHES"."HITCH_ID" = '+ @hitch.id.to_s).where('"PILOTS_HITCHES"."HITCH_ID" is null').order('"TRN_USERS"."FIRST_NAME"')
    @unassociated_pilots = User.joins('left outer join "PILOTS_HITCHES" on "PILOTS_HITCHES"."USER_ID" = "TRN_USERS"."USER_ID" and "PILOTS_HITCHES"."HITCH_ID" = '+ @hitch.id.to_s).where('"PILOTS_HITCHES"."HITCH_ID" is null and "TRN_USERS"."PILOT" = 1').order('"TRN_USERS"."FIRST_NAME"')
  end

  # GET /hitches/1/edit
  def edit
  end

  # POST /hitches
  def create
    @hitch = Hitch.new(hitch_params)

    respond_to do |format|
      if @hitch.save
        format.html { redirect_to @hitch, notice: 'Hitch was successfully created.' }
        format.json { render :show, status: :created, location: @hitch }
      else
        format.html { render :new }
        format.json { render json: @hitch.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH /hitches/1/pilots_update
  def pilots_update
    if hitch_params.key? 'pilot_ids'
      params[:hitch][:pilot_ids] = hitch_params[:pilot_ids] + @hitch.pilots.pluck(:user_id).map(&:to_s)
      if valid_date?(params[:effective_start_date]) 
        selected_start_date = params[:effective_start_date]
      else
        selected_start_date = Date.today.strftime("%m/%d/%Y")
      end
      selected_end_date = nil
      if valid_date?(params[:effective_end_date])
        selected_end_date = params[:effective_end_date]
      end  
      params[:effective_start_date] = selected_start_date
      params[:effective_end_date] = selected_end_date
    end
    respond_to do |format|
      if @hitch.update(hitch_params)
        @hitch.pilots_hitches.where(effective_start_date: nil, effective_end_date: nil)
                         .update_all(:effective_start_date => Date.strptime(selected_start_date, "%m/%d/%Y"),
                                     :effective_end_date => (Date.strptime(selected_end_date, "%m/%d/%Y") rescue nil))
        
        format.html { redirect_to @hitch, notice: 'Pilots added successfully.' }
        format.json { render :show, status: :ok, location: @hitch }
      else
        format.html { render :edit }
        format.json { render json: @hitch.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /hitches/1
  def update
    respond_to do |format|
      if @hitch.update(hitch_params)
        format.html { redirect_to @hitch, notice: 'Hitch was successfully updated.' }
        format.json { render :show, status: :ok, location: @hitch }
      else
        format.html { render :edit }
        format.json { render json: @hitch.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /hitches/1
  def destroy
    @hitch.destroy
    respond_to do |format|
      format.html { redirect_to hitches_url, notice: 'Hitch was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_hitch
      @hitch = Hitch.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def hitch_params
      params.require(:hitch).permit(:org_unit, :name, :days_on, :days_off, :mon, :tue, :wed, :thu, :fri, :sat, :sun, :hour_start, :hour_end, :pilot_ids => [], pilots_hitches_attributes: [:hitch_id, :user_id, :effective_start_date, :effective_end_date])
    end
end
