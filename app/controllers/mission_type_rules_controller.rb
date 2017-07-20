class MissionTypeRulesController < ApplicationController
	before_action :set_mission_type_rule, only: [:show, :edit, :update, :destroy]
  before_action :set_mission_type

	def destroy
    @mission_type_rule.destroy
    respond_to do |format|
      format.html { redirect_to @mission_type, notice: 'Mission type was successfully unassociated.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mission_type_rule
      @mission_type_rule = MissionTypeRule.find(params[:id])
    end

    def set_mission_type
      @mission_type = MissionType.find(params[:mission_type_id])
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def mission_type_rule_params
      params.require(:mission_type).permit(:misson_type_id, :effective_start_date, :effective_end_date, :created_by, :last_updated_by, mission_type_rules_attributes: [:mission_type_id, :rule_id], rules_attributes: [:name, :description])
    end
end