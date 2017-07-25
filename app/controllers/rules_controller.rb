class RulesController < ApplicationController
  before_action :set_rule, only: [:show, :edit, :add_mission_types, :update, :destroy]
  # GET /rules
  # GET /rules.json
  def index
    @rules = Rule.all
  end

  # GET /rules/1
  # GET /rules/1.json
  def show
    @mission_type_rules = @rule.mission_type_rules.includes(:mission_type)
  end

  # GET /rules/new
  def new
    @rule = Rule.new
  end

  def add_mission_types
    @unassociated_mission_types = MissionType.joins('left outer join "MISSION_TYPE_RULES" on "MISSION_TYPE_RULES"."MISSION_TYPE_ID" = "MISSION_TYPES"."MISSION_TYPE_ID" and "MISSION_TYPE_RULES"."RULE_ID" = '+ @rule.id.to_s).where('"MISSION_TYPE_RULES"."MISSION_TYPE_ID" is null').order('"MISSION_TYPES"."NAME"')
  end
  # GET /rules/1/edit
  def edit
  end

  # POST /rules
  # POST /rules.json
  def create
    @rule = Rule.new(rule_params)

    respond_to do |format|
      if @rule.save
        format.html { redirect_to @rule, notice: 'Rule was successfully created.' }
        format.json { render :show, status: :created, location: @rule }
      else
        format.html { render :new }
        format.json { render json: @rule.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rules/1
  # PATCH/PUT /rules/1.json
  def update
    debugger
    if rule_params.key? 'mission_type_ids'
      params[:rule][:mission_type_ids] = rule_params[:mission_type_ids] + @rule.mission_types.pluck(:mission_type_id).map(&:to_s)
    end
    respond_to do |format|
      if @rule.update(rule_params)
        format.html { redirect_to @rule, notice: 'Rule was successfully updated.' }
        format.json { render :show, status: :ok, location: @rule }
      else
        format.html { render :edit }
        format.json { render json: @rule.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rules/1
  # DELETE /rules/1.json
  def destroy
    @rule.destroy
    respond_to do |format|
      format.html { redirect_to rules_url, notice: 'Rule was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_rule
      @rule = Rule.find(params[:id])
    end

    def set_mission_type
      @mission_type = MissionType.find(params[:mission_type_id])
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def rule_params
      params.require(:rule).permit(:name, :description, :code_block, :created_by, :last_updated_by, :mission_type_ids => [])
    end
end
