
namespace :faces do
  desc "refetch favicons"
  task :favicons => :environment do
    FacetKind.find(:all).each do |fk|
      #fk.get_favicon
      fk.save!
    end
  end
end