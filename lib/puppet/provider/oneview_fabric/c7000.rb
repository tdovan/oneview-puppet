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

Puppet::Type::Oneview_fabric.provide :c7000 do
  desc 'Provider for OneView Fabrics using the C7000 variant of the OneView API'

  confine true: login[:hardware_variant] == 'C7000'

  mk_resource_methods

  def initialize(*args)
    super(*args)
    @client = OneviewSDK::Client.new(login)
    api_version = login[:api_version] || 200
    @resourcetype ||= if api_version == 200
                        OneviewSDK::API200::Fabric
                      else
                        Object.const_get("OneviewSDK::API#{api_version}::C7000::Fabric")
                      end
    # Initializes the data so it is parsed only on exists and accessible throughout the methods
    # This is not set here due to the 'resources' variable not being accessible in initialize
    @data ||= {}
  end

  def exists?
    @data = data_parse
    !@resourcetype.find_by(@client, @data).empty?
  end

  def create
    raise('This resource relies on others to be created.')
  end

  def destroy
    raise('This resource relies on others to be destroyed.')
  end

  def found
    find_resources
  end

  def get_reserved_vlan_range
    raise('This method is unavailable for the C7000 API')
  end

  def set_reserved_vlan_range
    raise('This method is unavailable for the C7000 API')
  end
end
