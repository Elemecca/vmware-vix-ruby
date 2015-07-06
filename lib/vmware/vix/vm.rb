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

module VMware
module Vix

  class VM < Handle

    def power_state? (value)
      0 != (property( :vm_power_state ) & LibVix::PowerState[ value ])
    end

    def powered_off?
      power_state? :powered_off
    end

    def powering_off?
      power_state? :powering_off
    end

    def powered_on?
      power_state? :powered_on
    end

    def powering_on?
      power_state? :powering_on
    end

    def suspended?
      power_state? :suspended
    end

    def suspending?
      power_state? :suspending
    end

    def resetting?
      power_state? :resetting
    end

    def tools_running?
      power_state? :tools_running
    end


    def start()
      Vix::Job.call(
          :VixVM_PowerOn, @handle,
          :normal, # don't open the GUI
          LibVix::INVALID_HANDLE # no properties
        )

      self
    end

    def poweroff()
      Vix::Job.call(
          :VixVM_PowerOff, @handle,
          :normal, # don't shut down the guest, just power off
        )

      self
    end

    def shutdown()
      Vix::Job.call(
          :VixVM_PowerOff, @handle,
          :from_guest, # do a graceful shutdown via Tools
        )

      self
    end

    def reset()
      Vix::Job.call(
          :VixVM_Reset, @handle,
          :normal, # don't shut down the guest, just power off
        )

      self
    end

    def reboot()
      Vix::Job.call(
          :VixVM_Reset, @handle,
          :from_guest, # do a graceful shutdown via Tools
        )

      self
    end

    def suspend()
      Vix::Job.call(
          :VixVM_Suspend, @handle,
          0 # no options
        )

      self
    end

    def pause()
      Vix::Job.call(
          :VixVM_Pause, @handle,
          0, # no options
          LibVix::INVALID_HANDLE # no properties
        )

      self
    end

    def unpause()
      Vix::Job.call(
          :VixVM_Unpause, @handle,
          0, # no options
          LibVix::INVALID_HANDLE # no properties
        )

      self
    end



    def [] (key)
      job = Vix::Job.call(
          :VixVM_ReadVariable,
          @handle, :vm_config_runtime_only,
          key.to_s,
          0 # no options
        )

      job.property :job_result_vm_variable_string
    end

    def []= (key, value)
      Vix::Job.call(
          :VixVM_WriteVariable,
          @handle, :vm_config_runtime_only,
          key.to_s, value.to_s,
          0 # no options
        )

      value
    end
  end

end # module Vix
end # module VMware
