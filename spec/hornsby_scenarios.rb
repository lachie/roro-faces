scenario :valid_users do
  @carl_mugshot = Mugshot.create! :size => 10_000, :content_type => 'image/png', :filename => 'foo.png'
  
  @bob  = User.create! :email => 'bob@bob.com'  , :password => 'bobbob', :password_confirmation => 'bobbob'
  @carl = User.create! :email => 'carl@carl.com', :password => 'carl'  , :password_confirmation => 'carl', :mugshot => @carl_mugshot
end