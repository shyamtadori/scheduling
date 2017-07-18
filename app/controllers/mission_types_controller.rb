class MissionTypesController < ApplicationController
  before_action :set_mission_type, only: [:show, :edit, :update, :destroy]

  # GET /mission_types
  # GET /mission_types.json
  def index
    @mission_types = MissionType.all
  end

  # GET /mission_types/1
  # GET /mission_types/1.json
  def show
    @mission_type_rules = @mission_type.mission_type_rules.includes(:rule)
  end

  # GET /mission_types/new
  def new
    @mission_type = MissionType.new
  end

  # GET /mission_types/1/edit
  def edit
  end

  # POST /mission_types
  # POST /mission_types.json
  def create
    @mission_type = MissionType.new(mission_type_params)

    respond_to do |format|
      if @mission_type.save
        format.html { redirect_to @mission_type, notice: 'Mission type was successfully created.' }
        format.json { render :show, status: :created, location: @mission_type }
      else
        format.html { render :new }
        format.json { render json: @mission_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /mission_types/1
  # PATCH/PUT /mission_types/1.json
  def update
    respond_to do |format|
      if @mission_type.update(mission_type_params)
        format.html { redirect_to @mission_type, notice: 'Mission type was successfully updated.' }
        format.json { render :show, status: :ok, location: @mission_type }
      else
        format.html { render :edit }
        format.json { render json: @mission_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /mission_types/1
  # DELETE /mission_types/1.json
  def destroy
    @mission_type.destroy
    respond_to do |format|
      format.html { redirect_to mission_types_url, notice: 'Mission type was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mission_type
      @mission_type = MissionType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def mission_type_params
      params.require(:mission_type).permit(:name, :description, :created_by, :last_updated_by, mission_type_rules_attributes: [:mission_type_id, :rule_id], rules_attributes: [:name, :description])
    end
end
