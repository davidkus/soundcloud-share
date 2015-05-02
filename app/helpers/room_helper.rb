module RoomHelper

  def my_rooms_class(current_type)
    current_type == 'owner' ? 'active orange' : ''
  end

  def shared_rooms_class(current_type)
    current_type == 'access' ? 'active orange' : ''
  end

  def public_rooms_class(current_type)
    current_type != 'access' && current_type != 'owner' ? 'active orange' : ''
  end

end
