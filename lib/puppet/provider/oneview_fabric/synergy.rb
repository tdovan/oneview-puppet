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

Puppet::Type.type(:oneview_fabric).provide :synergy, parent: :c7000 do
  desc 'Provider for OneView Fabrics using the Synergy variant of the OneView API'

  confine true: login[:hardware_variant] == 'Synergy'

  def initialize(*args)
    @resourcetype ||= Object.const_get("OneviewSDK::API#{login[:api_version]}::Synergy::Fabric")
    super(*args)
  end

  # TODO: Incorporate this into 'present' ensure method.
  def get_reserved_vlan_range
    pretty get_single_resource_instance.get_reserved_vlan_range
  end

  def set_reserved_vlan_range
    @resourcetype.find_by(@client, unique_id).first.set_reserved_vlan_range(@data['fabric_options'])
  end
end
