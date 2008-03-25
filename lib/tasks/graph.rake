
namespace :faces do
  namespace :graph do
    desc "regenerate the beergraph"
    task :beer => :environment do
      Thankyou.draw_graph(:all)
    end
  
    desc "regenerate the chattergraph"
    task :chatter => :environment do
      rm File.join(RAILS_ROOT,'public','images','chatter.png')
      User.draw_chatter
    end
  end
end