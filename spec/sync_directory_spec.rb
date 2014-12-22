require_relative 'spec_helper'

require 'ostruct'

describe SyncDirectory do

  describe 'basic_ops' do
    let(:dir) { SyncDirectory.new('tmp/sync') }
    let(:client) { OpenStruct.new(id: 'foo') }

    it { expect(dir.outbox_glob).to eq 'tmp/sync/**/outbox/**' }

    it { expect(dir.inbox_glob).to eq 'tmp/sync/**/inbox/**' }

    it { expect(dir.inbox_path(client)).to eq 'tmp/sync/foo/inbox' }

    it { expect(dir.outbox_path(client)).to eq 'tmp/sync/foo/outbox' }

    it { expect(dir.sync_path).to eq 'tmp/sync' }
  end

  describe '#each_inbox_file' do
    let(:path) { 'spec/data/sync' }
    let(:results) { [] }
    let(:collect) { lambda { |client_id, path| results << [client_id, path] } }

    context 'when sync path is relative' do
      let(:dir) { SyncDirectory.new(path) }

      it 'visits each file' do
        dir.each_inbox_file &collect
        expect(results).to include %W(123 #{path}/123/inbox/bar.csv),
                                   %W(123 #{path}/123/inbox/foo.json),
                                   %W(343 #{path}/343/inbox/baz.rb)
      end

      it 'visits each file that matched' do
        dir.each_inbox_file('*.csv', &collect)
        expect(results).to eq [%W(123 #{path}/123/inbox/bar.csv)]
      end
    end

    context 'when sync path is absolute' do
      let(:dir) { SyncDirectory.new(File.absolute_path(path)) }

      it 'visits each file' do
        dir.each_inbox_file &collect
        expect(results).to include ['123', File.absolute_path("#{path}/123/inbox/bar.csv")],
                                   ['123', File.absolute_path("#{path}/123/inbox/foo.json")],
                                   ['343', File.absolute_path("#{path}/343/inbox/baz.rb")]
      end

      it 'visits each file that matched' do
        dir.each_inbox_file('*.csv', &collect)
        expect(results).to eq [['123', File.absolute_path("#{path}/123/inbox/bar.csv")]]
      end
    end
  end

end