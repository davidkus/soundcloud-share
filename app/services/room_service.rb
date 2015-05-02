module RoomService

  def self.transfer_permissions(original_user, target_user)
    Room.with_role(:owner, original_user).each do |room|
      target_user.add_role :owner, room
    end

    Room.with_role(:access, original_user).each do |room|
      target_user.add_role :access, room
    end
  end

end
