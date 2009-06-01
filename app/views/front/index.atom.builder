atom_feed do |feed|
  feed.title("roro")
  feed.updated(@meetups.first.updated_at)

  for meetup in @meetups
    feed.entry(meetup) do |entry|
      entry.title(meetup.title)
      entry.content(meetup.body_html, :type => 'html')

      entry.author do |author|
        author.name("roro")
      end
    end
  end
end

