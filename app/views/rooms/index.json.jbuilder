json.array!(@rooms) do |room|
  json.(room, :id, :name, :public)
  json.owners room.owners, :id, :username
  json.url room_url(room, format: :json)
end
