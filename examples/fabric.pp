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

oneview_fabric{'Fabric Found':
    ensure => 'found'
    # Optional filters
    # data   =>
    # {
    #     name => 'DefaultFabric'
    # }
}

# This is specific to Synergy, will fail for C7000
oneview_fabric{'Fabric Reserved Vlan Range':
    ensure => 'get_reserved_vlan_range',
    data   =>
    {
        name => 'DefaultFabric'
    }
}

# This is specific to Synergy, will fail for C7000
oneview_fabric{'Fabric Set Reserved Vlan Range':
    ensure => 'set_reserved_vlan_range',
    data   =>
    {
        name           => 'DefaultFabric',
        fabric_options => {
          start  => 100,
          length => 100,
          type   => 'vlan-pool'
        }
    }
}
