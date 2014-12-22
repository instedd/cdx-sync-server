module CDXSync
  def self.rrsync_location
    '/usr/bin/rrsync'
  end

  def self.default_sync_dir_path
    nil
  end

  def self.default_authorized_keys_path
    nil
  end
end

require_relative './cdx_sync/client.rb'
require_relative './cdx_sync/sync_directory.rb'
require_relative './cdx_sync/file_watcher.rb'
require_relative './cdx_sync/authorized_keys.rb'
