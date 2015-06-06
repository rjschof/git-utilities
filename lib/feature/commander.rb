require_relative './start'
require_relative './end'
require_relative './rebase'
require_relative './merge_to'
require_relative './branch'

module Feature

  class Commander
    attr_reader :subcommand

    def initialize (argv)
      @subcommand = case argv[0]
        when "start"  then Feature::Start.new(argv)
        when "end"    then Feature::End.new(argv)
        when "rebase" then Feature::Rebase.new(argv)
        when "merge"  then Feature::MergeTo.new(argv)
        else               Feature::Branch.new(argv)
      end
    end

    def valid?
      subcommand.valid?
    end

    def help
      subcommand.help
    end

    def execute
      subcommand.execute
    end
  end

end