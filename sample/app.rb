require "onesphere"

onesphere = OneSphere::Connect(
  host_url: "https://onesphere-host.com",
  username: "some username",
  password: "some password"
)


onesphere.disconnect()
