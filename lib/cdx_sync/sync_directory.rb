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
  def outbox_path(client_id)
    path_for client_id, 'outbox'
  end

  # Answers the inbox directory path
  # for a given client_id
  def inbox_path(client_id)
    path_for client_id, 'inbox'
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
  def client_sync_path(client_id)
    File.join sync_path, client_id
  end

  # Ensures that the sync_path exists
  # This method creates it if it does not exist
  def ensure_sync_path!
    FileUtils.ensure_path! sync_path
  end

  def ensure_client_sync_paths!(client_id)
    inbox_path = self.inbox_path client_id
    outbox_path = self.outbox_path client_id

    FileUtils.ensure_path! inbox_path
    FileUtils.ensure_path! outbox_path
  end

  private

  def path_for(client_id, area)
    File.join client_sync_path(client_id), area
  end

  def glob_for(area)
    "#{sync_path}/**/#{area}/**"
  end
end