class HitchesController < ApplicationController
  before_action :set_hitch, only: [:show, :edit, :update, :destroy]

  # GET /hitches
  def index
    @hitches = Hitch.all
  end

  # GET /hitches/1
  def show
  end

  # GET /hitches/new
  def new
    @hitch = Hitch.new
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
      params.require(:hitch).permit(:name, :days_on, :days_off, :mon, :tue, :wed, :thu, :fri, :sat, :sun, :hour_start, :hour_end)
    end
end
