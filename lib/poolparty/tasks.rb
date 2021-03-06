module PoolParty
  class Tasks
    include Callbacks
    
    # Setup and define all the tasks
    def initialize
      yield self if block_given?
    end
    # Define the tasks in the rakefile
    # From the rakefile
    def define_tasks
      # Run the command on the local system
      def run(cmd)
        Kernel.system(cmd.runnable)
      end
      # Basic setup action
      def setup_application
        @options ||= PoolParty.options(ARGV.dup)
      end
      
      # Require the poolparty specific tasks
      compiled_rakefile
      
      desc "Reload the static variables"
      task :reload do
        reload!
      end
      true
    end
    
    def reload!
      @compiled_rakefile = nil
    end
    
    def compiled_rakefile
      rake_str = []
      
      Dir["#{File.expand_path(File.dirname(__FILE__))}/tasks/*.rake"].each { |t| rake_str << open(t).read }
      plugin_rakefiles
      
      @compiled_rakefile ||= eval(rake_str.join("\n")) # Not ideal
    end
    def plugin_rakefiles
      Dir["#{PoolParty.plugin_dir}/*/Rakefile"].each {|t| load t }
    end
  end
end