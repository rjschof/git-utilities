require 'ostruct'
require 'optparse'

class Commander

  attr_accessor :options

  def initialize
    @options = OpenStruct.new
    options.debug = false
    options.git_grep = %w{-E}
    options.pathspec = []
    options.environment = default_environment

    @option_parser = OptionParser.new do |op|
      op.banner = "Usage: xgrep options term(s)"

      op.on('-a','--asset') do |argument|
        options.pathspec << :asset
      end

      op.on('-b','--db') do |argument|
        options.pathspec << :db
      end

      op.on('-c','--controller') do |argument|
        options.pathspec << :controller
      end

      op.on('-d','--[no-]debug') do |argument|
        options.debug = argument
      end

      op.on('-f','--file') do |argument|
        options.git_grep << "-L"
      end

      op.on('-g','--config') do |argument|
        options.pathspec << :config
      end

      op.on('-i','--invert') do |argument|
        options.git_grep << '-v'
      end

      op.on('-l','--lib') do |argument|
        options.pathspec << :lib
      end

      op.on('-m','--model') do |argument|
        options.pathspec << :model
      end

      op.on('-o','--core') do |argument|
        options.pathspec << :core
      end

      op.on_tail('-h','--help') do |argument|
        puts op
        exit
      end

    end

    @option_parser.parse!(ARGV)
    options.terms = ARGV # must be after parse!
  end

  def valid?
    options.terms.size > 0
  end

  def help
    puts @option_parser
    exit
  end

  def execute
    env = Object.const_get(options.environment).new
    env.update_pathspec(options.pathspec)

    ands = []
    ors  = []
    nots = []
    current_op = ands

    options.terms.each do |x|
      case x
      when 'and'               then current_op = ands
      when 'or'                then current_op = ors
      when 'not'               then current_op = nots
      when /^-+(and|or|not)$/i then current_op << $1
      else                          current_op << x
      end
    end

    ands = ands.map { |x| "-e \"#{x}\"" }
    ors  = ors.map { |x| "-e \"#{x}\"" }
    nots = nots.map { |x| "-e \"#{x}\"" }

    ands << "\\( #{ors.join(' --or ')} \\)"        unless ors.empty?
    ands << "--not \\( #{nots.join(' --or ')} \\)" unless nots.empty?

    command = "git grep #{options.git_grep.join(' ')} #{ands.join(' --and ')} -- #{env.pathspec.sort.join(' ')}"
  end

  private

  def default_environment
    if File.exist?('./.xgrep')
      "CustomEnv"
    elsif File.exist?("Gemfile") and File.exist?("package.json")
      "NodeEnv"
    elsif File.exist?("Gemfile")
      "RailsEnv"
    elsif File.exist?("package.json")
      "NodeEnv"
    else
      "RailsEnv"
    end
  end
end
