class AccessController < ApplicationController

  expose(:sharing_code) { SharingCode.find_by code: params[:code] }
  expose(:room) { sharing_code.room }

  def grant_access
    if sharing_code && !sharing_code.expired?
      current_or_guest_user.add_role :access, room
    end

    respond_to do |format|
      if !sharing_code
        flash[:alert] = I18n.t 'sharing.invalid_link'
        format.html { redirect_to root_path }
        format.json { render json: "", status: :not_found }
      elsif current_or_guest_user.has_role? :access, room
        format.html { redirect_to room }
        format.json { render json: "", status: :ok }
      else
        flash[:alert] = I18n.t 'sharing.invalid_link'
        format.html { redirect_to root_path }
        format.json { render json: "", status: :unauthorized }
      end
    end
  end

end
