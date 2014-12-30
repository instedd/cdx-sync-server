require 'bundler'
require 'rspec/core/rake_task'
require_relative './lib/cdx_sync'

Bundler::GemHelper.install_tasks
RSpec::Core::RakeTask.new(:test)

task :default => :test

namespace :demo do

  desc "Inform when new files ar in the inbox"

  task :watch_files do

    sync_dir = SynDirectory.new('tmp/cdxsync')
    sync_dir.init_sync_path

    watcher = CDXSync::FileWatcher.new(sync_dir, debug_paths: true)
    watcher.watch do |file|
      puts 'new file detected'
    end
  end

end
