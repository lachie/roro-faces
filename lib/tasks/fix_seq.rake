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
