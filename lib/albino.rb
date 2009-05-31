##
# Wrapper for the Pygments command line tool, pygmentize.
#
# Pygments: http://pygments.org/
#
# Assumes pygmentize is in the path.  If not, set its location
# with Albino.bin = '/path/to/pygmentize'
#
# Use like so:
#
#   @syntaxer = Albino.new('/some/file.rb', :ruby)
#   puts @syntaxer.colorize
#
# This'll print out an HTMLized, Ruby-highlighted version
# of '/some/file.rb'.
#
# To use another formatter, pass it as the third argument:
#
#   @syntaxer = Albino.new('/some/file.rb', :ruby, :bbcode)
#   puts @syntaxer.colorize
#
# You can also use the #colorize class method:
#
#   puts Albino.colorize('/some/file.rb', :ruby)
#
# Another also: you get a #to_s, for somewhat nicer use in Rails views.
#
#   ... helper file ...
#   def highlight(text)
#     Albino.new(text, :ruby)
#   end
#
#   ... view file ...
#   <%= highlight text %>
#
# The default lexer is 'text'.  You need to specify a lexer yourself;
# because we are using STDIN there is no auto-detect.
#
# To see all lexers and formatters available, run `pygmentize -L`.
#
# Chris Wanstrath // chris@ozmm.org 
#         GitHub // http://github.com
#
require 'open4'

class Albino
  @@bin = ENV['RACK_ENV'] != 'production' ? 'pygmentize' : '/usr/bin/pygmentize'

  def self.bin=(path)
    @@bin = path
  end

  def self.colorize(*args)
    options = (Hash === args.last ? args.pop : {})
    new(*args).colorize(options)
  end

  def initialize(target, lexer = :text, format = :html)
    lexer ||= 'text'
    
    @target  = File.exists?(target) ? File.read(target) : target rescue target
    @options = { :l => lexer, :f => format }
  end

  def execute(command)
    puts "command: #{command}"
    pid, stdin, stdout, stderr = Open4.popen4(command)

    puts "reading stdin"
    stdin.puts @target
    stdin.close
    puts "done reading stdin"
    
    
    begin
      err = stderr.read_nonblock(0)
    rescue EAGAIN
      puts "nothing on err"
      err = nil
    end
    puts "done reading stderr"
    
    if err && !err.empty?
      err += stderr.read
      puts "failed to convert using command #{command}"
      puts err
      "failed to convert: (#{command})"
    else
      puts "reading stdout"
      stdout.read.strip
    end
  end

  def colorize(options = {})
    execute @@bin + convert_options(options)
  end
  alias_method :to_s, :colorize

  def convert_options(options = {})
    @options.merge(options).inject('') do |string, (flag, value)|
      string + " -#{flag} #{value}"
    end
  end
end


module Haml::Filters::Textile
  DELIM_RE = %r[^----*(.*)$]

  def render_with_pygments(text)
    code       = ''
    non_code   = ''
    formatting = false
    language   = nil

    new_text = ''

    text.each do |line|

      if line[DELIM_RE]
        if !formatting
          language = $1.strip

          new_text << render_without_pygments(non_code)
          formatting = true
        else
          language = nil

          new_text << Albino.colorize( code, language, :O => 'linenos=table')
          formatting = false
        end

        non_code   = ''
        code       = ''

      elsif formatting
        code << line
      else
        non_code << line
      end

    end

    unless non_code.strip.empty?
      new_text << render_without_pygments(non_code)
    end

    new_text
  end

  alias :render_without_pygments :render
  alias :render :render_with_pygments
end


if $0 == __FILE__
  require 'rubygems'
  require 'test/spec'
  require 'mocha'
  begin require 'redgreen'; rescue LoadError; end

  context "Albino" do
    setup do
      @syntaxer = Albino.new(__FILE__, :ruby)
    end

    specify "defaults to text" do
      syntaxer = Albino.new(__FILE__)
      syntaxer.expects(:execute).with('pygmentize -f html -l text').returns(true)
      syntaxer.colorize
    end

    specify "accepts options" do
      @syntaxer.expects(:execute).with('pygmentize -f html -l ruby').returns(true)
      @syntaxer.colorize
    end

    specify "works with strings" do
      syntaxer = Albino.new('class New; end', :ruby)
      assert_match %r(highlight), syntaxer.colorize
    end

    specify "aliases to_s" do
      assert_equal @syntaxer.colorize, @syntaxer.to_s
    end

    specify "class method colorize" do
      assert_equal @syntaxer.colorize, Albino.colorize(__FILE__, :ruby)
    end
  end
end
