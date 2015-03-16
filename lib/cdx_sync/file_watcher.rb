require 'thread'
require 'filewatcher'

module CDXSync
  class FileWatcher

    def initialize(sync_dir, options = {})
      @jobs = Queue.new

      @sync_dir = sync_dir
      @debug_paths = options[:debug_paths]
      @remove_processed_files = options[:remove_processed_files]
      @log = options[:logger] || Logger.new(STDOUT)
    end

    def watch
      @log.info "Watching #{@sync_dir.sync_path}"

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
        @log.info "Enqueuing #{preexisting_files.size} preexisting file(s)."
        preexisting_files.each do |f|
          @jobs << f
        end
      end
    end

    def start_monitoring
      Thread.start do
        @log.info "Monitoring of #{watch_expression} started"
        begin
          ::FileWatcher.new([watch_expression], @debug_paths).watch do |path, event|
            if event == :new
              @log.info "New file detected: #{path}."
              @jobs << path
            end
          end
        rescue => ex
          @log.error "Error monitoring #{watch_expression}:\n #{ex}"
          raise
        ensure
          @log.info 'Monitoring ended'
        end
      end
    end
  end
end
