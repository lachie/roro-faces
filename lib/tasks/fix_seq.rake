task :fix_seq => :environment do
  c = ActiveRecord::Base.connection
  c.tables.each do |table|
    begin
      id = c.select_value("select max(id) from #{table}")
      next if nil
      c.execute("select setval('#{table}_id_seq',#{id})")
    rescue
    end
  end
end

task :fix_dates => :environment do
  now = Time.now
  Meeting.all.each do |m|
    if !m.analogue_blog.blank?
      m.blog_updated_at = m.blog_created_at = now
      m.save!
    end
  end
end
