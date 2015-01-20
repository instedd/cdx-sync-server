require_relative 'spec_helper'

describe Client do
  let(:dir) { SyncDirectory.new('tmp/sync') }

  context 'when public key is valid' do
    let(:client) { good_client 'myclient' }

    before { client.validate! }

    it { expect(client.authorized_keys_entry(dir)).to include 'command="/usr/bin/rrsync tmp/sync/myclient",no-agent-forwarding,no-port-forwarding,no-pty,no-user-rc,no-X11-forwarding ssh-rsa ' }
  end

  context 'when public key is not valid' do
    let(:client) { bad_client 'myclient' }

    it { expect { client.validate! }.to raise_error(CDXSync::InvalidPublicKeyError) }
  end
end

