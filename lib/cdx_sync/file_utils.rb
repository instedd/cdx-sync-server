module FileUtils
  def self.ensure_path!(path)
    mkdir_p path unless Dir.exist? path
  end
end