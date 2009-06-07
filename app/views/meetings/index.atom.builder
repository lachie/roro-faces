atom_feed do |feed|
  feed.title("roro")
  feed.updated(@meetups.first.updated_at)

  for meetup in @meetups
    feed.entry(meetup, :url => meetup.feed_url) do |entry|
      entry.title(meetup.feed_title)
      entry.content(meetup.feed_body, :type => 'html')

      entry.author do |author|
        author.name("roro")
      end
    end
  end
end

