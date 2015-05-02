module FirebaseService

  def self.delete_room(room)
    $firebase.delete("rooms/#{room.sync_id}")
  end

  def self.delete_chat(room)
    $firebase.delete("chats/#{room.chat_id}")
  end

end
