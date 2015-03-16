require_relative 'spec_helper'

require 'ostruct'

describe SyncDirectory do

  describe 'basic_ops' do
    let(:dir) { SyncDirectory.new('tmp/sync') }
    let(:client) { OpenStruct.new(id: 'foo') }

    it { expect(dir.outbox_glob).to eq 'tmp/sync/**/outbox/**' }

    it { expect(dir.inbox_glob).to eq 'tmp/sync/**/inbox/**' }

    it { expect(dir.inbox_path(client.id)).to eq 'tmp/sync/foo/inbox' }

    it { expect(dir.outbox_path(client.id)).to eq 'tmp/sync/foo/outbox' }

    it { expect(dir.error_path(client.id)).to eq 'tmp/sync/foo/error' }

    it { expect(dir.sync_path).to eq 'tmp/sync' }

  end

  describe 'filters' do
    let(:path) { 'spec/data/sync' }
    let(:results) { [] }
    let(:collect) { lambda { |client_id, path| results << [client_id, path] } }

    describe '#if_inbox_file' do
      let(:dir) { SyncDirectory.new(path) }

      it 'runs if file matches' do
        dir.if_inbox_file("#{path}/12345/inbox/foo.csv", &collect)
        expect(results).to eq [%W(12345 #{path}/12345/inbox/foo.csv)]
      end

      it 'runs if file matches with glob' do
        dir.if_inbox_file("#{path}/12345/inbox/foo.csv", '*.csv', &collect)
        expect(results).to eq [%W(12345 #{path}/12345/inbox/foo.csv)]
      end

      it 'does not run if file not matches glob' do
        dir.if_inbox_file("#{path}/12345/inbox/foo.csv", '*.json', &collect)
        expect(results).to eq []
      end

      it 'does not run if file not matches inbox' do
        dir.if_inbox_file("#{path}/12345/outbox/foo.csv", &collect)
        expect(results).to eq []
      end
    end

    describe '#each_inbox_file' do
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

    describe '#move_inbox_file_to_error' do
      let(:dir) { SyncDirectory.new(path) }
      let(:filename) { File.join(path, '123', 'inbox', 'err.csv') }
      let(:target) { File.join(path, '123', 'error', 'err.csv') }

      before(:each) { File.open(filename, 'w') { |io| io.write("foo") } }
      after(:each)  { FileUtils.rm_rf(File.join(path, '123', 'error')) }

      it "should move file to new error folder" do
        dir.move_inbox_file_to_error(filename)
        expect(File.exist?(filename)).to be false
        expect(File.exist?(target)).to be true
        expect(File.read(target)).to eq('foo')
      end

    end

  end
end
