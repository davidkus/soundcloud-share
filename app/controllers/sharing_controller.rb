class SharingController < ApplicationController

  def show
    room = Room.find params[:room_id]

    if room.share_link && room.share_id == params[:id]
      current_or_guest_user.add_role :access, room
    end

    respond_to do |format|
      if room.share_link
        format.html { redirect_to room }
        format.json { render json: "", status: :ok }
      else
        flash[:alert] = I18n.t 'sharing.sharing_disabled'
        format.html { redirect_to rooms_path }
        format.json { render json: "", status: :ok }
      end
    end
  end

end
