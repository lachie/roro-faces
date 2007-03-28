desc "regenerate the thumbnails"
namespace :faces do
  task :redothumbs => :environment do
    User.regenerate_all_thumbnails
  end
end