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

require_relative '../login'
require_relative '../common'
require 'oneview-sdk'

Puppet::Type::Oneview_network_set.provide :c7000 do
  desc 'Provider for OneView Network Sets using the C7000 variant of the OneView API'

  mk_resource_methods

  def initialize(*args)
    super(*args)
    @client = OneviewSDK::Client.new(login)
    api_version = login[:api_version] || 200
    @resourcetype ||= if api_version == 200
                        OneviewSDK::API200::NetworkSet
                      else
                        Object.const_get("OneviewSDK::API#{api_version}::C7000::NetworkSet")
                      end
    @ethernet ||= if api_version == 200
                    OneviewSDK::API200::EthernetNetwork
                  else
                    Object.const_get("OneviewSDK::API#{api_version}::C7000::EthernetNetwork")
                  end
    @data ||= {}
  end

  def exists?
    # assignments and deletions from @data
    @data = data_parse
    network_uris
    empty_data_check([:found, :get_without_ethernet])
    !@resourcetype.find_by(@client, @data).empty?
  end

  def create
    return true if resource_update(@data, @resourcetype)
    @resourcetype.new(@client, @data).create
  end

  def destroy
    get_single_resource_instance.delete
  end

  def found
    find_resources
  end

  def get_without_ethernet
    Puppet.notice("\n\nNetwork Set Without Ethernet\n")
    if @data.empty?
      list = @resourcetype.get_without_ethernet(@client)
      raise('There is no Network Set without ethernet in the Oneview appliance.') if list.empty?
      list.each { |item| pretty item }
    else
      item = get_single_resource_instance.get_without_ethernet
      raise('There is no Network Set without ethernet in the Oneview appliance.') unless item
      pretty item
    end
    true
  end

  def network_uris
    return unless @data['networkUris']
    list = []
    @data['networkUris'].each do |item|
      net = OneviewSDK::EthernetNetwork.find_by(@client, name: item)
      raise('The network #{name} does not exist.') unless net.first
      list.push(net.first['uri'])
    end
    @data['networkUris'] = list
  end
end
