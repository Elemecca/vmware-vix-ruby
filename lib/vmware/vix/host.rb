# vim:ft=ruby:sts=2:sw=2:
#
# Copyright 2015 Sam Hanes
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'vmware/vix/libvix'

module VMware
module Vix

  class Host < Handle
    def self.connect_workstation
      job = LibVix.VixHost_Connect(
          LibVix::API_VERSION,
          :vmware_workstation,
          nil, 0, # no connection info
          nil, nil, # no auth info
          0, # options
          LibVix::INVALID_HANDLE, # no properties
          nil, nil # no callback
        )

      host_ptr = Vix::Handle::Pointer.new
      err = LibVix.VixJob_Wait( job,
          :VixPropertyID, :job_result_handle,
            :pointer, host_ptr,
          :VixPropertyID, :none
        )

      LibVix.Vix_ReleaseHandle( job )
      job = LibVix::INVALID_HANDLE

      if LibVix.failed? err
        raise LibVix::Error.new( err )
      end

      self.new host_ptr.to_handle
    end

    def self.finalizer (handle)
      # for reasons I don't entirely understand, hosts require
      # VixHost_Disconnect but not Vix_ReleaseRef
      proc { LibVix.VixHost_Disconnect( handle ) }
    end
  end

end # module Vix
end # module VMware
