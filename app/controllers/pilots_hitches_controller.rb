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
    @pilots_hitch = PilotsHitch.new
  end

  # GET /pilots_hitches/1/edit
  def edit
  end

  # POST /pilots_hitches
  def create
    @pilots_hitch = PilotsHitch.new(pilots_hitch_params)

    respond_to do |format|
      if @pilots_hitch.save
        format.html { redirect_to @pilots_hitch, notice: 'Pilots hitch was successfully created.' }
        format.json { render :show, status: :created, location: @pilots_hitch }
      else
        format.html { render :new }
        format.json { render json: @pilots_hitch.errors, status: :unprocessable_entity }
      end
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
      params.require(:pilots_hitch).permit(:hitch_id, :employee_id, :effective_start_date, :effective_end_date)
    end
end
