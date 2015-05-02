module FirebaseTokenService

  def self.create_token(payload)
    $generator.create_token(payload)
  end

end
