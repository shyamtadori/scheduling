class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :add_hitches]

  def index
    @users = User.where("status <> 'INACTIVE'").order(:last_name)
    @customers = Customer.active
  end

  def show
  	@associated_hitches = @user.pilots_hitches.includes(:hitch)
  end

  def add_hitches
  	# @unassociated_hitches = MissionType.joins('left outer join "MISSION_TYPE_RULES" on "MISSION_TYPE_RULES"."MISSION_TYPE_ID" = "MISSION_TYPES"."MISSION_TYPE_ID" and "MISSION_TYPE_RULES"."RULE_ID" = '+ @rule.id.to_s).where('"MISSION_TYPE_RULES"."MISSION_TYPE_ID" is null').order('"MISSION_TYPES"."NAME"')
  	# @unassociated_pilots = User.joins('left outer join "PILOTS_HITCHES" on "PILOTS_HITCHES"."USER_ID" = "TRN_USERS"."USER_ID" and "PILOTS_HITCHES"."HITCH_ID" = '+ @hitch.id.to_s).where('"PILOTS_HITCHES"."HITCH_ID" is null and "TRN_USERS"."PILOT" = 1').order('"TRN_USERS"."FIRST_NAME"')

  	@unassociated_hitches = Hitch.joins('left outer join "PILOTS_HITCHES" on "PILOTS_HITCHES"."HITCH_ID" = "HITCHES"."HITCH_ID" and "PILOTS_HITCHES"."USER_ID" = '+ @user.id.to_s).where('"PILOTS_HITCHES"."USER_ID" is null')
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end
end