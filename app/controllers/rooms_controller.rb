class RoomsController < ApplicationController
  after_action :verify_authorized, except: [:index]

  expose(:room, attributes: :room_params)

  expose(:firebase_url) { ENV['FIREBASE_URL'] }
  expose(:soundcloud_client_id) { ENV['SOUNDCLOUD_CLIENT_ID'] }
  expose(:current_type) { params[:type] }

  expose(:public_rooms) { Room.where public: true }
  expose(:owner_rooms) { Room.with_role :owner, current_or_guest_user }
  expose(:access_rooms) { Room.with_role :access, current_or_guest_user }

  # GET /rooms
  # GET /rooms.json
  def index
    case current_type
    when 'owner'
      @rooms = owner_rooms
    when 'access'
      @rooms = access_rooms
    else
      @rooms = public_rooms
    end
  end

  # GET /rooms/1
  # GET /rooms/1.json
  def show
    payload = {
      uid: current_or_guest_user.id.to_s,
      userId: current_or_guest_user.id,
      username: current_or_guest_user.username,
      avatar: current_or_guest_user.gravatar_url,
      canUpdateRoom: policy(room).update?,
      canAccessRoom: policy(room).show?,
      canUpdateChat: policy(room).show?,
      canAccessChat: policy(room).show?,
      roomId: room.sync_id,
      chatId: room.chat_id
    }

    @token = FirebaseTokenService.create_token(payload)
  end

  # GET /rooms/new
  def new
    room.share_link = true
  end

  # GET /rooms/1/edit
  def edit
  end

  # POST /rooms
  # POST /rooms.json
  def create
    respond_to do |format|
      if room.save
        current_or_guest_user.add_role :owner, room

        format.html { redirect_to room, notice: I18n.t('rooms.successfully_created') }
        format.json { render :show, status: :created, location: room }
      else
        format.html { render :new }
        format.json { render json: room.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rooms/1
  # PATCH/PUT /rooms/1.json
  def update
    respond_to do |format|
      if room.update(room_params)
        format.html { redirect_to room, notice: I18n.t('rooms.successfully_updated') }
        format.json { render :show, status: :ok, location: room }
      else
        format.html { render :edit }
        format.json { render json: room.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rooms/1
  # DELETE /rooms/1.json
  def destroy
    room.destroy
    respond_to do |format|
      format.html { redirect_to :back, notice: I18n.t('rooms.successfully_destroyed') }
      format.json { head :no_content }
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def room_params
      params.require(:room).permit :name, :public, :share_link
    end
end
