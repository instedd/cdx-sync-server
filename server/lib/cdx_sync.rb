module CDXSync
  def rrsync_location
    '/usr/bin/rrsync'
  end
end

require_relative './cdx_sync/client.rb'
require_relative './cdx_sync/sync_directory.rb'
require_relative './cdx_sync/file_watcher.rb'
require_relative './cdx_sync/authorized_keys.rb'
