
puts "dates init..."

ActiveSupport::CoreExtensions::Time::Conversions::DATE_FORMATS.merge! :long_nice => lambda { |time| 
    puts "time time time: #{time} #{time.hour}";
    time.strftime("%B #{time.day.ordinalize}, %Y %l:%M#{time.hour < 12 ? 'am' : 'pm'}")
  },
  :brief => '%a %d %b, %H:%M'
