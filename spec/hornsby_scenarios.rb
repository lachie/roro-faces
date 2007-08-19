scenario :valid_users do
 @carl_mugshot = Mugshot.create! :size => 10_000, :content_type => 'image/png', :filename => 'foo.png'
  
  @bob  = User.create! :email => 'bob@bob.com'  , :password => 'bobbob', :password_confirmation => 'bobbob'
  @carl = User.create! :email => 'carl@carl.com', :password => 'carl'  , :password_confirmation => 'carl', :mugshot => @carl_mugshot
  @dave = User.create! :email => 'dave@dave.com', :password => 'dave'  , :password_confirmation => 'dave', :irc_nick => "dave"
  @eddie = User.create! :email => 'eddie@eddie.com', :password => 'eddie'  , :password_confirmation => 'eddie', :irc_nick => "_eddie_"
  @fred = User.create! :email => 'fred@fred.com', :password => 'fred'  , :password_confirmation => 'fred', :irc_nick => "_fred_", :alternate_irc_nick => "_[NRE]fred_"

end