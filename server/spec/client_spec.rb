require 'rspec'

require_relative '../lib/cdx_sync'

include CDXSync

describe Client do
  let(:dir) { SyncDirectory.new('tmp/sync') }

  context 'when public key is valid' do
    let(:key) { 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC4hzyCbJQ5RgrZPFz+rTscTuJ5NPuBIKiinXwkA38CE9+N37L8q9kMqxsbDumVFbamYVlS9fsmF1TqRRhobfJfZGptkcthQde83FWHQGaEQn8T4SG055N5SWNRjQTfMaK0uTTQ28BN44dhLluF/zp4UDHOKRVBrJY4SZq1M5ytkMc6mlZWbCAzqtIUUJOMKz4lHn5Os/d8temlYskaKQ1n+FuX5qJXNr1SW8euH72fjQndu78DCwVNwnnrG+nEe3a9m2QwL5xnX8f1ohAZ9IG41hwIOvB5UcrFenqYIpMPBCCOnizUcyIFJhegJDWh2oWlBo041emGOX3VCRjtGug3 fbulgarelli@Manass-MacBook-2.local' }
    let(:client) { Client.new('myclient', key) }

    before { client.validate! }

    it { expect(client.authorized_keys_entry(dir)).to include 'command="/usr/bin/rrsync tmp/sync/myclient",no-agent-forwarding,no-port-forwarding,no-pty,no-user-rc,no-X11-forwarding ssh-rsa ' }
  end

  context 'when public key is not valid' do
    let(:client) { Client.new('myclient', 'foobar') }

    it { expect { client.validate! }.to raise_error }
  end
end

