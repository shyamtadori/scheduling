class PilotsHitchesController < ApplicationController
  before_action :set_pilots_hitch, only: [:show, :switch, :edit, :update, :destroy]
  before_action :set_hitch
  # before_action :set_pilot, only: [:destroy]

  # GET /pilots_hitches/1
  def show
  end

  def switch
    @hitches = Hitch.where('"HITCHES"."HITCH_ID" != ?', @hitch).order(:name)
    render layout: false
  end

  def edit
    render layout: false
  end

  def update
    if params[:pilots_hitch].has_key?(:effective_start_date)
      params[:pilots_hitch][:effective_start_date] = Date.strptime(params[:pilots_hitch][:effective_start_date], "%m/%d/%Y") rescue nil
    end
    if params[:pilots_hitch].has_key?(:effective_end_date)
      params[:pilots_hitch][:effective_end_date] = Date.strptime(params[:pilots_hitch][:effective_end_date], "%m/%d/%Y") rescue nil
    end
    @pilots_hitch.assign_attributes(pilots_hitch_params)
    if params.key? :new_hitch_id and pilots_hitch_params[:effective_end_date].present?
      new_hitch = Hitch.find(params[:new_hitch_id])
      new_pilots_hitch = new_hitch.pilots_hitches.new(user_id: @pilots_hitch.user_id, effective_start_date: @pilots_hitch.effective_end_date.beginning_of_day + 1.day)
      new_pilots_hitch.save
    end
    respond_to do |format|
      if @pilots_hitch.save
        format.html { redirect_to @hitch, notice: "Pilot's hitch was successfully updated." }
        format.json { render :show, status: :ok, location: @hitch }
      else
        format.html { render :edit }
        format.json { render json: @pilots_hitch.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /pilots_hitches/new
  # def new
  #   @pilots_hitch = PilotsHitch.new
  #   @hitch_pilots = @hitch.pilots.pluck(:user_id)
  #   @all_pilots = User.pilot
  # end


  # POST /pilots_hitches
  # def create
  #   existing_pilot_ids = @hitch.pilots.pluck(:user_id)

  #   if params.has_key?(:hitch_pilots)
  #     selected_pilot_ids = params[:hitch_pilots][:checkbox_user_ids].map(&:to_i)
  #   else
  #     selected_pilot_ids = []
  #   end

  #   deleted_pilot_ids = existing_pilot_ids - selected_pilot_ids

  #   PilotsHitch.where("hitch_id = ? and user_id in (?)", @hitch.id, deleted_pilot_ids).destroy_all if deleted_pilot_ids.length > 0

  #   new_pilot_ids = selected_pilot_ids - existing_pilot_ids

  #   new_pilot_ids.each do |new_pilot_id|
  #     @hitch.pilots << User.where(:user_id => new_pilot_id).first
  #   end

  #   if valid_date?(params[:pilots_hitch][:effective_start_date]) && valid_date?(params[:pilots_hitch][:effective_end_date])
  #     selected_start_date = params[:pilots_hitch][:effective_start_date]
  #     selected_end_date = params[:pilots_hitch][:effective_end_date]
  #   else
  #     selected_start_date = Date.today.strftime("%m/%d/%Y")
  #     selected_end_date = (Date.today + 1.month).strftime("%m/%d/%Y")
  #   end
  #   @hitch.pilots_hitches.where(effective_start_date: nil, effective_end_date: nil)
  #                        .update_all(:effective_start_date => Date.strptime(selected_start_date, "%m/%d/%Y"),
  #                                    :effective_end_date => Date.strptime(selected_end_date, "%m/%d/%Y"))
    
  #   respond_to do |format|
  #     # format.html { redirect_to new_hitch_pilots_hitch_path(@hitch), notice: 'Pilots updated successfully.' }
  #     format.html { redirect_to @hitch, notice: 'Pilots updated successfully.' }
  #   end
  # end

  def destroy
    @pilots_hitch.destroy
    if params[:is_from_pilot]
      @pilot = @pilots_hitch.pilot
      redirect_to @pilot, notice: 'Hitch removed successfully.' 
    else
      redirect_to @hitch, notice: 'Pilot removed successfully.' 
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pilots_hitch
      @pilots_hitch = PilotsHitch.find(params[:id])
    end

    def set_hitch
      @hitch = Hitch.find(params[:hitch_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def pilots_hitch_params
      params.require(:pilots_hitch).permit(:new_hitch_id ,:effective_start_date, :effective_end_date)
    end
end
