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
