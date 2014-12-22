module CDXSync
  class AuthorizedKeys
    attr_accessor :path

    def initialize(path = CDXSync.default_authorized_keys_path)
      @path = path
    end

    def append!(clients, sync_dir)
      open_and_write 'a', clients, sync_dir
    end

    def write!(clients, sync_dir)
      open_and_write 'w', clients, sync_dir
    end

    private

    def open_and_write(mode, clients, sync_dir)
      keys = authorized_keys_for(clients, sync_dir).join("\n")
      keys = "\n" + keys if mode == 'a'
      clients.each { |c| sync_dir.init_client_sync_paths!(c.id) }
      File.open(path, mode) do |file|
        file << keys
      end
    end

    def authorized_keys_for(clients, sync_dir)
      clients.map do |client|
        client.validate!
        client.authorized_keys_entry(sync_dir)
      end
    end
  end
end
