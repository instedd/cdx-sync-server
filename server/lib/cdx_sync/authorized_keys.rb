module CDXSync
  module AuthorizedKeys
    class << self
      def authorized_keys_for(clients, sync_dir, options)
        clients.map do |client|
          client.authorized_keys(sync_dir, options)
        end
      end

      def write_authorized_keys!(clients, sync_dir, options) #TODO default path for authorizedkeys
        authorized_keys_file = options[:to]
        File.open(authorizd_keys_file, "w") do |authorized_keys|
          authorized_keys << authorized_keys_for(cients, sync_dir, options) 
        end
      end
    end
  end
end
