require_relative 'spec_helper'

require 'tempfile'


describe AuthorizedKeys do
  let(:clients) { [good_client('foo'), good_client('bar')] }

  let(:sync_dir) { SyncDirectory.new('tmp/sync') }

  let(:authorized_keys) { AuthorizedKeys.new(authorized_keys_file.path) }
  let(:authorized_keys_file) { Tempfile.new('authorizedkeys').tap(&:close) }

  after { authorized_keys_file.unlink }

  describe '#write_authorized_keys!' do
    before { authorized_keys.write_authorized_keys! clients, sync_dir }

    it { expect(File.exists? authorized_keys.path).to be true }
    it { expect(File.readlines(authorized_keys.path).size).to eq 2 }
  end

  describe '#write_authorized_keys!' do
    before { File.write(authorized_keys.path, 'foobar') }
    before { authorized_keys.append_authorized_keys! clients, sync_dir }

    it { expect(File.exists? authorized_keys.path).to be true }
    it { expect(File.readlines(authorized_keys.path).size).to eq 3 }
  end
end