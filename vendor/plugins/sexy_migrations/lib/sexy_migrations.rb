##
# inspired by hobo -- http://hobocentral.net
module SexyMigrations
  module Table
    def foreign_key(*args)
      options = args.last.is_a?(Hash) ? args.pop : {}
      args.each { |col| column("#{col}_id", :integer, options) }
    end
    alias :fkey :foreign_key

    def timestamps
      column :created_at, :datetime
      column :updated_at, :datetime
    end
    alias :timestamps! :timestamps
    alias :auto_dates  :timestamps
    alias :auto_dates! :timestamps

    def method_missing(name, *args)
      return super unless type = simplified_type(name)
      options = args.last.is_a?(Hash) ? args.pop : {}
      args.each { |col| column(col, type, options) }
    end

  private
    def simplified_type(type)
      ActiveRecord::ConnectionAdapters::Column.new(:type_check, false, type.to_s).type
    end
  end

  module Schema
    def create_table(name, options = {}, &block)
      table_definition = ActiveRecord::ConnectionAdapters::TableDefinition.new(self)
      table_definition.primary_key(options[:primary_key] || "id") unless options[:id] == false

      table_definition.instance_eval &block

      if options[:force]
        drop_table(name, options) rescue nil
      end

      create_sql = "CREATE#{' TEMPORARY' if options[:temporary]} TABLE "
      create_sql << "#{name} ("
      create_sql << table_definition.to_sql
      create_sql << ") #{options[:options]}"
      execute create_sql
    end
  end
end
