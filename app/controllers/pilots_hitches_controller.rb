class PilotsHitchesController < ApplicationController
  before_action :set_pilots_hitch, only: [:show, :destroy]
  before_action :set_hitch

  # GET /pilots_hitches/1
  def show
  end

  # GET /pilots_hitches/new
  def new
    @pilots_hitch = PilotsHitch.new
    @hitch_pilots = @hitch.pilots.pluck(:user_id)
    @all_pilots = User.pilot
  end


  # POST /pilots_hitches
  def create
    existing_pilot_ids = @hitch.pilots.pluck(:user_id)

    if params.has_key?(:hitch_pilots)
      selected_pilot_ids = params[:hitch_pilots][:checkbox_user_ids].map(&:to_i)
    else
      selected_pilot_ids = []
    end

    deleted_pilot_ids = existing_pilot_ids - selected_pilot_ids

    PilotsHitch.where("hitch_id = ? and user_id in (?)", @hitch.id, deleted_pilot_ids).destroy_all if deleted_pilot_ids.length > 0

    new_pilot_ids = selected_pilot_ids - existing_pilot_ids

    new_pilot_ids.each do |new_pilot_id|
      @hitch.pilots << User.where(:user_id => new_pilot_id).first
    end

    selected_start_date = params[:pilots_hitch][:effective_start_date] || DateTime.now
    selected_end_date = params[:pilots_hitch][:effective_end_date] || DateTime.now + 1.month

    @hitch.pilots_hitches.where(effective_start_date: nil, effective_end_date: nil)
                         .update_all(:effective_start_date => Date.strptime(selected_start_date, "%m/%d/%Y"),
                                     :effective_end_date => Date.strptime(selected_end_date, "%m/%d/%Y"))
    
    respond_to do |format|
      format.html { redirect_to new_hitch_pilots_hitch_path(@hitch), notice: 'Pilots updated successfully.' }
    end
  end

  def destroy
    @pilots_hitch.destroy
    redirect_to @hitch, notice: 'Pilot removed successfully.' 
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
      params.require(:pilots_hitch).permit(:effective_start_date, :effective_end_date)
    end
end
