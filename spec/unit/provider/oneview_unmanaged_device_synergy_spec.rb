################################################################################
# (C) Copyright 2016-2017 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
################################################################################

require 'spec_helper'
require_relative '../../support/fake_response'
require_relative '../../shared_context'

provider_class = Puppet::Type.type(:oneview_unmanaged_device).provider(:synergy)
resourcetype = OneviewSDK::UnmanagedDevice

describe provider_class, unit: true do
  include_context 'shared context'

  context 'given the add parameters' do
    let(:resource) do
      Puppet::Type.type(:oneview_unmanaged_device).new(
        name: 'Unmanaged Device',
        ensure: 'found',
        data:
            {
              'name' => 'Unmanaged Device',
              'model' => 'Procurve 4200VL',
              'deviceType' => 'Server',
              'uri' => '/rest/fake'
            },
        provider: 'synergy'
      )
    end

    let(:provider) { resource.provider }

    let(:instance) { provider.class.instances.first }

    let(:test) { resourcetype.new(@client, name: resource['data']['name']) }

    before(:each) do
      allow(resourcetype).to receive(:find_by).and_return([test])
      allow_any_instance_of(resourcetype).to receive(:update).and_return([test])
      provider.exists?
    end

    it 'should be an instance of the provider' do
      expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_unmanaged_device).provider(:synergy)
    end

    it 'should be able to find the resource' do
      provider.exists?
      expect(provider.found).to be
    end

    it 'should not be able to find the resource' do
      allow(resourcetype).to receive(:find_by).and_return([])
      provider.exists?
      expect { provider.found }.to raise_error(/No UnmanagedDevice with the specified data were found on the Oneview Appliance/)
    end

    it 'should delete/remove the resource' do
      allow_any_instance_of(resourcetype).to receive(:remove).and_return(true)
      expect(provider.destroy).to be
    end

    it 'should create/add the resource' do
      allow(resourcetype).to receive(:find_by).and_return([])
      allow_any_instance_of(resourcetype).to receive(:add).and_return(test)
      provider.exists?
      expect(provider.create).to be
    end

    it 'should update the resource' do
      unique_ids = { 'name' => resource['data']['name'], 'uri' => resource['data']['uri'] }
      expect(resourcetype).to receive(:find_by).with(anything, resource['data']).and_return([])
      expect(resourcetype).to receive(:find_by).with(anything, unique_ids).and_return([test])
      provider.exists?
      expect(provider.create).to be
    end

    it 'should be able to get the environmental configuration' do
      allow_any_instance_of(resourcetype).to receive(:environmental_configuration).and_return(['test'])
      provider.exists?
      expect(provider.get_environmental_configuration).to be
    end
  end
end
