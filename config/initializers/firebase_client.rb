if ENV['FIREBASE_URL'] && ENV['FIREBASE_SECRET']
  $firebase = Firebase::Client.new ENV['FIREBASE_URL'], ENV['FIREBASE_SECRET']
end
