class AdminController < ApplicationController
  layout "admin"
  respond_to :json, :html
  before_action :verify_admin
  authorize_resource class: false

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { head :forbidden, content_type: "text/html" }
      format.html {
        redirect_to root_url, notice: exception.message
      }
      format.js   { head :forbidden, content_type: "text/html" }
    end
  end

  def verify_admin
    redirect_to root_url unless current_user.admin?
  end

  private

  def set_admin_ability
    if admin_signed_in?
      @current_ability ||= Ability.new current_admin
    end
  end
end
