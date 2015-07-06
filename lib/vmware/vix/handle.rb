# vim:ft=ruby:sts=2:sw=2:et:
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

  class Handle
    def self.magic (handle)
      type = LibVix.Vix_GetHandleType( handle )
      case type
      when :host
        Vix::Host.new handle
      when :vm
        Vix::VM.new handle
      when :job
        Vix::Job.new handle
      else
        Vix::Handle.new handle
      end
    end

    def self.finalizer (handle)
      proc { LibVix.Vix_ReleaseHandle( handle ) }
    end

    def initialize (handle)
      @handle = handle

      ObjectSpace.define_finalizer(
        self, self.class.finalizer( handle ) )
    end


    # Gets the underlying LibVix handle for this object.
    #
    # The handle's refcount is incremented so the returned handle is
    # independent of the current object. The caller is therefore
    # responsible for calling LibVix.Vix_ReleaseHandle. Failure to
    # release handles correctly will result in memory leaks.
    def handle
      LibVix.Vix_AddRefHandle( @handle )
      @handle
    end


    def property (prop)
      case prop
      when Symbol
        prop = LibVix::PropertyID[ prop ]
      when Fixnum
        # already fine
      else
        raise TypeError.new "argument must be a property symbol or ID"
      end

      type_ptr = FFI::MemoryPointer.new :int
      err = LibVix.Vix_GetPropertyType( @handle, prop, type_ptr )
      if LibVix.failed? err
        raise LibVix::Error.new err
      end

      type = type_ptr.read_int
      type = LibVix::PropertyType.from_native( type, nil ) || type

      value_type = type
      case type
      when :integer
        value_type = :int
      when :string
        value_type = :pointer
      when :bool
      when :handle
        value_type = :int
      when :int64
      else
        raise TypeError.new "unsupported property type " + type.to_s
      end

      value_ptr = FFI::MemoryPointer.new value_type
      err = LibVix.Vix_GetProperties( @handle,
          :VixPropertyID, prop, :pointer, value_ptr,
          :VixPropertyID, :none
        )
      if LibVix.failed? err
        raise LibVix::Error.new err
      end

      value = value_ptr.send( 'read_' + value_type.to_s )

      case type
      when :string
        pointer = value
        value = pointer.read_string_to_null
        LibVix.Vix_FreeBuffer pointer
      when :handle
        value = Handle.magic value
      end

      value
    end
  end

  class Handle::Pointer < FFI::MemoryPointer
    def initialize
      super :int
      write_int LibVix::INVALID_HANDLE
    end

    def to_handle
      read_int
    end
  end

end # module Vix
end # module VMware
