if ENV['FIREBASE_SECRET']
  $generator = Firebase::FirebaseTokenGenerator.new ENV['FIREBASE_SECRET']
end
