require 'pp'
require 'open-uri'

def import_github_data(user,data)
  data["repositories"].each do |repo|
    puts "#{user.nick} -> #{repo[:name]}"
    user.repos.create!(:username    => repo[:owner],
                       :name        => repo[:name],
                       :description => repo[:description],
                       :url         => repo[:url],
                       :fork        => repo[:fork],
                       :forks       => repo[:forks],
                       :watchers    => repo[:watchers]
                      )
  end
end

task :github => 'github:default'

namespace :github do
  task :default => :environment do
    FacetKind.first(:conditions => ["lower(name)=?",'github']).facets.each do |facet|
      user = facet.user

      if (username = facet.info["user"]) && !username.blank?
        Repo.transaction do
          user.repos.delete_all
          begin
            open("http://github.com/api/v2/yaml/repos/show/#{username}",'r') do |f|
              import_github_data(user,YAML.load(f.read))
            end
          rescue OpenURI::HTTPError
            puts "failed grabbing repos for #{username} [#{user.nick}] with #{$!}"
          end
        end

      end
    end

    Repo.delete_all('user_id is null')
  end

  task :recalc => :environment do
    Repo.all.each do |repo|
      repo.calculate_score
      repo.save!
    end
  end
end
