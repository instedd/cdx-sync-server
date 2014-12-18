class SyncDirectory 

  attr_accessor :sync_path, :inbox_path, :outbox_path

  def intialize(sync_path)
    @sync_path = sync_path
  end

  def outbox_path(client)
    path_for client, 'outbox'
  end

  def inbox_path(client)
    path_for client, 'inbox'
  end

  def inbox_glob
    glob_for 'inbox'
  end

  def outbox_glob
    glob_for 'outbox'
  end

  def client_sync_path(client)
    File.join sync_path, client.id
  end


  private

  def path_for(client, area)
    File.join client_sync_path(client), area
  end

  def glob_for(area)
    "#{sync_path}/**/#{area}/**"
  end

  def init_sync_path
    FileUtils.mkdir_p sync_path unless Dir.exists? sync_path
  end

  def init_client_sync_paths(client)
    inbox_path = self.inbox_path client
    outbox_path = self.outbox_path client

    Dir.mkdir inbox_path unless Dir.exists? inbox_path
    Dir.mkdir outbox_path unless Dir.exists? outbox_path
  end
end