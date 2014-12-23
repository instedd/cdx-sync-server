require 'thread'
require 'filewatcher'

module CDXSync
  class FileWatcher
    def initialize(sync_dir, options = {})
      @jobs = Queue.new

      @sync_dir = sync_dir
      @debug_paths = options[:debug_paths]
      @remove_processed_files = options[:remove_processed_files]
    end

    def watch
      puts "Watching #{@sync_dir.sync_path}"

      enqueue_preexisting_files
      start_monitoring
      while true
        next_file = @jobs.pop
        yield next_file
        FileUtils.rm_rf next_file if @remove_processed_files
      end
    end

    private

    def watch_expression
      @sync_dir.inbox_glob
    end

    def enqueue_preexisting_files
      preexisting_files = Dir[watch_expression]
      if preexisting_files.any?
        puts "Enqueuing #{preexisting_files.size} preexisting file(s)."
        preexisting_files.each do |f|
          @jobs << f
        end
      end
    end

    def start_monitoring
      Thread.start do
        puts "Monitoring of #{watch_expression} started"
        begin
          ::FileWatcher.new([watch_expression], @debug_paths).watch do |path, event|
            if event == :new
              puts "New file detected: #{path}."
              @jobs << path
            end
          end
        ensure
          puts 'Monitoring ended'
        end
      end
    end
  end
end
