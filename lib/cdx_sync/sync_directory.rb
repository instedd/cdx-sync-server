class CDXSync::SyncDirectory

  attr_accessor :sync_path, :inbox_path, :outbox_path

  def initialize(sync_path = CDXSync.default_sync_dir_path)
    @sync_path = sync_path
  end

  # Executes the given block with the client_id and
  # file path for each file in the inbox directory
  # that matches the given glob
  def each_inbox_file(glob='*')
    Dir.glob(File.join inbox_glob, glob) do |path|
      client_id = /#{sync_path}\/(.+)\/inbox\/.*/.match(path)[1]
      yield client_id, path
    end
  end

  # Answers the outbox directory path for
  # a given client
  def outbox_path(client)
    path_for client, 'outbox'
  end

  # Answers the inbox directory path
  # for a given client
  def inbox_path(client)
    path_for client, 'inbox'
  end

  # A generic glob for the path to any outbox,
  # regardless of the client
  def inbox_glob
    glob_for 'inbox'
  end

  # A generic glob for the path to any outbox,
  # regardless of the client
  def outbox_glob
    glob_for 'outbox'
  end

  # The path where client's inbound and outbox are 
  def client_sync_path(client)
    File.join sync_path, client.id
  end

  # Ensures that the sync_path exists
  # This method creates it if it does not exist
  def init_sync_path!
    FileUtils.mkdir_p sync_path unless Dir.exists? sync_path
  end

  def init_client_sync_paths!(client)
    inbox_path = self.inbox_path client
    outbox_path = self.outbox_path client

    Dir.mkdir inbox_path unless Dir.exists? inbox_path
    Dir.mkdir outbox_path unless Dir.exists? outbox_path
  end

  private

  def path_for(client, area)
    File.join client_sync_path(client), area
  end

  def glob_for(area)
    "#{sync_path}/**/#{area}/**"
  end
end