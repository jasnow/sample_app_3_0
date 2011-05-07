# By using the symbol ':user', we get Factory Girl to simulate the User model.
Factory.define :user do |user|
  user.name                  "Al Snow"
  user.email_address         "jasnow@hotmail.com"
  user.password              "foobar"
  user.password_confirmation "foobar"
end