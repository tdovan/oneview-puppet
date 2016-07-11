################################################################################
# (C) Copyright 2016 Hewlett Packard Enterprise Development LP
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

oneview_logical_switch_group{'Logical Switch Group Create':
  ensure => 'present',
  data   =>
    {
      name               => 'Test Logical Switch Group',
      category           => 'logical-switch-groups',
      state              => 'Active',
      type               => 'logical-switch-group',
      groupingParameters =>
      {
        1 => 'Cisco Nexus 50xx'
      }
    }
}

oneview_logical_switch_group{'Logical Switch Group Found':
  ensure  => 'found',
  require => Oneview_logical_switch_group['Logical Switch Group Create'],
  data    =>
    {
      name     => 'OneViewSDK Test Logical Switch Group',
      category => 'logical-switch-groups',
      state    => 'Active',
      type     => 'logical-switch-group'
    }
}

oneview_logical_switch_group{'Logical Switch Group Get Schema':
  ensure  => 'get_schema',
  require => Oneview_logical_switch_group['Logical Switch Group Found'],
  data    =>
    {
      name     => 'OneViewSDK Test Logical Switch Group',
      category => 'logical-switch-groups',
      state    => 'Active',
      type     => 'logical-switch-group'
    }
}

oneview_logical_switch_group{'Logical Switch Group Get All':
  ensure => 'get_logical_switch_groups',
}

oneview_logical_switch_group{'Logical Switch Group Destroy':
  ensure  => 'absent',
  require => Oneview_logical_switch_group['Logical Switch Group Get Schema'],
  data    =>
    {
      name     => 'Test Logical Switch Group',
      category => 'logical-switch-groups',
      state    => 'Active',
      type     => 'logical-switch-group'
    }
}