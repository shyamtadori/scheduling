class PilotsHitchesController < ApplicationController
  before_action :set_pilots_hitch, only: [:show, :edit, :update, :destroy]

  # GET /pilots_hitches
  def index
    @pilots_hitches = PilotsHitch.all
  end

  # GET /pilots_hitches/1
  def show
  end

  # GET /pilots_hitches/new
  def new
    @hitch = Hitch.find(params[:hitch_id])
    @pilots_hitch = PilotsHitch.new
    @hitch_pilots = @hitch.pilots.pluck(:user_id)
    @all_pilots = User.pilot
  end

  # GET /pilots_hitches/1/edit
  def edit
  end

  # POST /pilots_hitches
  def create
    @hitch = Hitch.find(params[:hitch_id])
    existing_pilot_ids = @hitch.pilots.pluck(:user_id)

    if params.has_key?(:hitch_pilots)
      selected_pilot_ids = params[:hitch_pilots][:checkbox_user_ids]
    else
      selected_pilot_ids = []
    end

    deleted_pilot_ids = existing_pilot_ids - selected_pilot_ids
    
    puts '@@@@@@@@@@@@@@@@@@@@@@@@'
    puts existing_pilot_ids
    puts "@@@@@@@@@@@@@@@@@@@@@@@@"
    puts selected_pilot_ids
    puts "@@@@@@@@@@@@@@@@@@@@@@@@"
    puts deleted_pilot_ids
    puts '@@@@@@@@@@@@@@@@@@@@@@@@'

    PilotsHitch.where("hitch_id = ? and user_id in (?)", @hitch.id, deleted_pilot_ids).destroy_all

    new_pilot_ids = selected_pilot_ids - existing_pilot_ids

    new_pilot_ids.each do |new_pilot_id|
      puts '*'*90
      puts new_pilot_id
      @hitch.pilots << User.where(:user_id => new_pilot_id).first
    end

    respond_to do |format|
      format.html { redirect_to new_hitch_pilots_hitch_path(@hitch), notice: 'Pilots updated successfully.' }
    end
  end

  # PATCH/PUT /pilots_hitches/1
  def update
    respond_to do |format|
      if @pilots_hitch.update(pilots_hitch_params)
        format.html { redirect_to @pilots_hitch, notice: 'Pilots hitch was successfully updated.' }
        format.json { render :show, status: :ok, location: @pilots_hitch }
      else
        format.html { render :edit }
        format.json { render json: @pilots_hitch.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pilots_hitches/1
  def destroy
    @pilots_hitch.destroy
    respond_to do |format|
      format.html { redirect_to pilots_hitches_url, notice: 'Pilots hitch was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pilots_hitch
      @pilots_hitch = PilotsHitch.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def pilots_hitch_params
      params.require(:pilots_hitch).permit(:hitch_id, :user_id, :effective_start_date, :effective_end_date)
    end
end
