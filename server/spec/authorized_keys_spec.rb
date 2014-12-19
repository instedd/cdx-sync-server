require 'rspec'
require 'tempfile'
require_relative '../lib/cdx_sync'


describe CDXSync::AuthorizedKeys do
  let(:keys) { ['todo', 'todo'] }

  describe '::write_authorized_keys!' do
    let(:authorized_keys_file) { Tempfile.new('authorizedkeys').tap(&:close) }  
    let(:authorized_keys_path) { authorized_keys_file.path }

    before { CDXSync::AuthorizedKeys.write_authorized_keys! keys, to: authorized_keys_path }
    after { authorized_keys_file.unlink }

    it { expect(File.exists? authorized_keys_path).to be_true }
    it { expect(File.read(authorized_keys_path).to include('todo'))}
  end

  describe '::authorized_keys_for' do
    let(:authorized_keys) { CDXSync::AuthorizedKeys.authorized_keys_for(keys) }
    it { expect(authorized_keys).to eq('todo') }
  end
end