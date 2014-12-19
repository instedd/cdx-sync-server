require 'rspec'
require 'ostruct'

require_relative '../lib/cdx_sync'

describe SyncDirectory do
  let(:dir) { SyncDirectory.new('tmp/sync') }
  let(:client) { OpenStruct.new(id: 'foo') }

  it { expect(dir.outbox_glob).to eq 'tmp/sync/**/outbox/**' }

  it { expect(dir.inbox_glob).to eq 'tmp/sync/**/inbox/**' }

  it { expect(dir.inbox_path(client)).to eq 'tmp/sync/foo/inbox' }

  it { expect(dir.outbox_path(client)).to eq 'tmp/sync/foo/outbox' }

  it { expect(dir.sync_path).to eq 'tmp/sync' }

end