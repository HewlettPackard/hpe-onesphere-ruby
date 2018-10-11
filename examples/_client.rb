require_relative '../lib/onesphere'

@client = OneSphere::Client.new(
  url: 'https://onesphere.domain.example.com',
  user: 'username',
  password: 'password',
)

