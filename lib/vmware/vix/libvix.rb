# vim:ft=ruby:sts=2:sw=2:et:
#
# This file is a conversion to Ruby FFI of `vix.h` as shipped in
# VMware Fusion 7. It's almost entirely an API declaration. If APIs
# are subject to copyright, this one is copyright 2008 VMware, Inc
# according to the comments in the original header file.
#
# Any creative elements unique to this file were written in 2015
# by Sam Hanes. To the extent possible under law, the author(s) have
# dedicated all copyright and related and neighboring rights to this
# software to the public domain worldwide. This software is distributed
# without any warranty.
#
# You should have received a copy of the CC0 Public Domain Dedication
# along with this software. If not, see
# <http://creativecommons.org/publicdomain/zero/1.0/>.

require 'ffi'

module VMware
module Vix

# FFI interface to the native VIX library.
#
# API documentation may be found at
# https://www.vmware.com/support/developer/vix-api/vix113_reference/
module LibVix
  extend FFI::Library

  ffi_lib [
      'libvixAllProducts.so',
      '/Applications/VMware Fusion.app/Contents/Public/libvixAllProducts.dylib',
    ]


  # opaque handle used to refer to most objects
  typedef :int, :VixHandle
  INVALID_HANDLE = 0

  enum :VixHandleType, [
      :none, 0,
      :host, 2,
      :vm, 3,
      :network, 5,
      :job, 6,
      :snapshot, 7,
      :property_list, 9,
      :metadata_container, 11,
    ]

  typedef :uint64, :VixError

  def self.error_code (code)
    code & 0xFFFF
  end

  def self.succeeded? (code)
    code == ErrorCode[ :ok ]
  end

  def self.failed? (code)
    code != ErrorCode[ :ok ]
  end

  ErrorCode = enum(
      :ok, 0,

      # General errors
      :fail, 1,
      :out_of_memory, 2,
      :invalid_arg, 3,
      :file_not_found, 4,
      :object_is_busy, 5,
      :not_supported, 6,
      :file_error, 7,
      :disk_full, 8,
      :incorrect_file_type, 9,
      :cancelled, 10,
      :file_read_only, 11,
      :file_already_exists, 12,
      :file_access_error, 13,
      :requires_large_files, 14,
      :file_already_locked, 15,
      :vmdb, 16,
      :not_supported_on_remote_object, 20,
      :file_too_big, 21,
      :file_name_invalid, 22,
      :already_exists, 23,
      :buffer_toosmall, 24,
      :object_not_found, 25,
      :host_not_connected, 26,
      :invalid_utf8_string, 27,
      :operation_already_in_progress, 31,
      :unfinished_job, 29,
      :need_key, 30,
      :license, 32,
      :vm_host_disconnected, 34,
      :authentication_fail, 35,
      :host_connection_lost, 36,
      :duplicate_name, 41,
      :argument_too_big, 44,

      # Handle Errors
      :invalid_handle, 1000,
      :not_supported_on_handle_type, 1001,
      :too_many_handles, 1002,

      # XML errors
      :not_found, 2000,
      :type_mismatch, 2001,
      :invalid_xml, 2002,

      # VM Control Errors
      :timeout_waiting_for_tools, 3000,
      :unrecognized_command, 3001,
      :op_not_supported_on_guest, 3003,
      :program_not_started, 3004,
      :cannot_start_read_only_vm, 3005,
      :vm_not_running, 3006,
      :vm_is_running, 3007,
      :cannot_connect_to_vm, 3008,
      :powerop_scripts_not_available, 3009,
      :no_guest_os_installed, 3010,
      :vm_insufficient_host_memory, 3011,
      :suspend_error, 3012,
      :vm_not_enough_cpus, 3013,
      :host_user_permissions, 3014,
      :guest_user_permissions, 3015,
      :tools_not_running, 3016,
      :guest_operations_prohibited, 3017,
      :anon_guest_operations_prohibited, 3018,
      :root_guest_operations_prohibited, 3019,
      :missing_anon_guest_account, 3023,
      :cannot_authenticate_with_guest, 3024,
      :unrecognized_command_in_guest, 3025,
      :console_guest_operations_prohibited, 3026,
      :must_be_console_user, 3027,
      :vmx_msg_dialog_and_no_ui, 3028,
      # :not_allowed_during_vm_recording, 3029, Removed in version 1.11
      # :not_allowed_during_vm_replay, 3030, Removed in version 1.11
      :operation_not_allowed_for_login_type, 3031,
      :login_type_not_supported, 3032,
      :empty_password_not_allowed_in_guest, 3033,
      :interactive_session_not_present, 3034,
      :interactive_session_user_mismatch, 3035,
      # :unable_to_replay_vm, 3039, Removed in version 1.11
      :cannot_power_on_vm, 3041,
      :no_display_server, 3043,
      # :vm_not_recording, 3044, Removed in version 1.11
      # :vm_not_replaying, 3045, Removed in version 1.11
      :too_many_logons, 3046,
      :invalid_authentication_session, 3047,

      # VM Errors
      :vm_not_found, 4000,
      :not_supported_for_vm_version, 4001,
      :cannot_read_vm_config, 4002,
      :template_vm, 4003,
      :vm_already_loaded, 4004,
      :vm_already_up_to_date, 4006,
      :vm_unsupported_guest, 4011,

      # Property Errors
      :unrecognized_property, 6000,
      :invalid_property_value, 6001,
      :read_only_property, 6002,
      :missing_required_property, 6003,
      :invalid_serialized_data, 6004,
      :property_type_mismatch, 6005,

      # Completion Errors
      :bad_vm_index, 8000,

      # Message errors
      :invalid_message_header, 10000,
      :invalid_message_body, 10001,

      # Snapshot errors
      :snapshot_inval, 13000,
      :snapshot_dumper, 13001,
      :snapshot_disklib, 13002,
      :snapshot_notfound, 13003,
      :snapshot_exists, 13004,
      :snapshot_version, 13005,
      :snapshot_noperm, 13006,
      :snapshot_config, 13007,
      :snapshot_nochange, 13008,
      :snapshot_checkpoint, 13009,
      :snapshot_locked, 13010,
      :snapshot_inconsistent, 13011,
      :snapshot_nametoolong, 13012,
      :snapshot_vixfile, 13013,
      :snapshot_disklocked, 13014,
      :snapshot_duplicateddisk, 13015,
      :snapshot_independentdisk, 13016,
      :snapshot_nonunique_name, 13017,
      :snapshot_memory_on_independent_disk, 13018,
      :snapshot_maxsnapshots, 13019,
      :snapshot_min_free_space, 13020,
      :snapshot_hierarchy_toodeep, 13021,
      :snapshot_rrsuspend, 13022,
      :snapshot_not_revertable, 13024,

      # Host Errors
      :host_disk_invalid_value, 14003,
      :host_disk_sectorsize, 14004,
      :host_file_error_eof, 14005,
      :host_netblkdev_handshake, 14006,
      :host_socket_creation_error, 14007,
      :host_server_not_found, 14008,
      :host_network_conn_refused, 14009,
      :host_tcp_socket_error, 14010,
      :host_tcp_conn_lost, 14011,
      :host_nbd_hashfile_volume, 14012,
      :host_nbd_hashfile_init, 14013,

      # Disklib errors
      :disk_inval, 16000,
      :disk_noinit, 16001,
      :disk_noio, 16002,
      :disk_partialchain, 16003,
      :disk_needsrepair, 16006,
      :disk_outofrange, 16007,
      :disk_cid_mismatch, 16008,
      :disk_cantshrink, 16009,
      :disk_partmismatch, 16010,
      :disk_unsupporteddiskversion, 16011,
      :disk_openparent, 16012,
      :disk_notsupported, 16013,
      :disk_needkey, 16014,
      :disk_nokeyoverride, 16015,
      :disk_notencrypted, 16016,
      :disk_nokey, 16017,
      :disk_invalidpartitiontable, 16018,
      :disk_notnormal, 16019,
      :disk_notencdesc, 16020,
      :disk_needvmfs, 16022,
      :disk_rawtoobig, 16024,
      :disk_toomanyopenfiles, 16027,
      :disk_toomanyredo, 16028,
      :disk_rawtoosmall, 16029,
      :disk_invalidchain, 16030,
      :disk_key_notfound, 16052, # metadata key is not found
      :disk_subsystem_init_fail, 16053,
      :disk_invalid_connection, 16054,
      :disk_encoding, 16061,
      :disk_cantrepair, 16062,
      :disk_invaliddisk, 16063,
      :disk_nolicense, 16064,
      :disk_nodevice, 16065,
      :disk_unsupporteddevice, 16066,
      :disk_capacity_mismatch, 16067,
      :disk_parent_notallowed, 16068,
      :disk_attach_rootlink, 16069,

      # Crypto Library Errors
      :crypto_unknown_algorithm, 17000,
      :crypto_bad_buffer_size, 17001,
      :crypto_invalid_operation, 17002,
      :crypto_random_device, 17003,
      :crypto_need_password, 17004,
      :crypto_bad_password, 17005,
      :crypto_not_in_dictionary, 17006,
      :crypto_no_crypto, 17007,
      :crypto_error, 17008,
      :crypto_bad_format, 17009,
      :crypto_locked, 17010,
      :crypto_empty, 17011,
      :crypto_keysafe_locator, 17012,

      # Remoting Errors.
      :cannot_connect_to_host, 18000,
      :not_for_remote_host, 18001,
      :invalid_hostname_specification, 18002,

      # Screen Capture Errors.
      :screen_capture_error, 19000,
      :screen_capture_bad_format, 19001,
      :screen_capture_compression_fail, 19002,
      :screen_capture_large_data, 19003,

      # Guest Errors
      :guest_volumes_not_frozen, 20000,
      :not_a_file, 20001,
      :not_a_directory, 20002,
      :no_such_process, 20003,
      :file_name_too_long, 20004,
      :operation_disabled, 20005,

      # Tools install errors
      :tools_install_no_image, 21000,
      :tools_install_image_inaccesible, 21001,
      :tools_install_no_device, 21002,
      :tools_install_device_not_connected, 21003,
      :tools_install_cancelled, 21004,
      :tools_install_init_failed, 21005,
      :tools_install_auto_not_supported, 21006,
      :tools_install_guest_not_ready, 21007,
      :tools_install_sig_check_failed, 21008,
      :tools_install_error, 21009,
      :tools_install_already_up_to_date, 21010,
      :tools_install_in_progress, 21011,
      :tools_install_image_copy_failed, 21012,

      # Wrapper Errors
      :wrapper_workstation_not_installed, 22001,
      :wrapper_version_not_found, 22002,
      :wrapper_serviceprovider_not_found, 22003,
      :wrapper_player_not_installed, 22004,
      :wrapper_runtime_not_installed, 22005,
      :wrapper_multiple_serviceproviders, 22006,

      # FuseMnt errors
      :mntapi_mountpt_not_found, 24000,
      :mntapi_mountpt_in_use, 24001,
      :mntapi_disk_not_found, 24002,
      :mntapi_disk_not_mounted, 24003,
      :mntapi_disk_is_mounted, 24004,
      :mntapi_disk_not_safe, 24005,
      :mntapi_disk_cant_open, 24006,
      :mntapi_cant_read_parts, 24007,
      :mntapi_umount_app_not_found, 24008,
      :mntapi_umount, 24009,
      :mntapi_no_mountable_partitons, 24010,
      :mntapi_partition_range, 24011,
      :mntapi_perm, 24012,
      :mntapi_dict, 24013,
      :mntapi_dict_locked, 24014,
      :mntapi_open_handles, 24015,
      :mntapi_cant_make_var_dir, 24016,
      :mntapi_no_root, 24017,
      :mntapi_loop_failed, 24018,
      :mntapi_daemon, 24019,
      :mntapi_internal, 24020,
      :mntapi_system, 24021,
      :mntapi_no_connection_details, 24022,
      # FuseMnt errors: Do not exceed 24299

      # VixMntapi errors
      :mntapi_incompatible_version, 24300,
      :mntapi_os_error, 24301,
      :mntapi_drive_letter_in_use, 24302,
      :mntapi_drive_letter_already_assigned, 24303,
      :mntapi_volume_not_mounted, 24304,
      :mntapi_volume_already_mounted, 24305,
      :mntapi_format_failure, 24306,
      :mntapi_no_driver, 24307,
      :mntapi_already_opened, 24308,
      :mntapi_item_not_found, 24309,
      :mntapi_unsupproted_boot_loader, 24310,
      :mntapi_unsupproted_os, 24311,
      :mntapi_codeconversion, 24312,
      :mntapi_regwrite_error, 24313,
      :mntapi_unsupported_ft_volume, 24314,
      :mntapi_partition_not_found, 24315,
      :mntapi_putfile_error, 24316,
      :mntapi_getfile_error, 24317,
      :mntapi_reg_not_opened, 24318,
      :mntapi_regdelkey_error, 24319,
      :mntapi_create_partitiontable_error, 24320,
      :mntapi_open_failure, 24321,
      :mntapi_volume_not_writable, 24322,

      # Success on operation that completes asynchronously
      :async, 25000,

      # Async errors
      :async_mixedmode_unsupported, 26000,

      # Network Errors
      :net_http_unsupported_protocol, 30001,
      :net_http_url_malformat, 30003,
      :net_http_couldnt_resolve_proxy, 30005,
      :net_http_couldnt_resolve_host, 30006,
      :net_http_couldnt_connect, 30007,
      :net_http_http_returned_error, 30022,
      :net_http_operation_timedout, 30028,
      :net_http_ssl_connect_error, 30035,
      :net_http_too_many_redirects, 30047,
      :net_http_transfer, 30200,
      :net_http_ssl_security, 30201,
      :net_http_generic, 30202,
    )

  attach_function :Vix_GetErrorText, [ :VixError, :string ], :string


  PropertyType = enum :VixPropertyType, [
      :any, 0,
      :integer, 1,
      :string, 2,
      :bool, 3,
      :handle, 4,
      :int64, 5,
      :blob, 6,
    ]

  PropertyID = enum :VixPropertyID, [
      :none, 0,

      # Properties used by several handle types.
      :meta_data_container, 2,

      # VIX_HANDLETYPE_HOST properties
      :host_hosttype, 50,
      :host_api_version, 51,
      :host_software_version, 52,

      # VIX_HANDLETYPE_VM properties
      :vm_num_vcpus, 101,
      :vm_vmx_pathname, 103,
      :vm_vmteam_pathname, 105,
      :vm_memory_size, 106,
      :vm_read_only, 107,
      :vm_name, 108,
      :vm_guestos, 109,
      :vm_in_vmteam, 128,
      :vm_power_state, 129,
      :vm_tools_state, 152,
      :vm_is_running, 196,
      :vm_supported_features, 197,
      # :vm_is_recording, 236, Removed in version 1.11
      # :vm_is_replaying, 237, Removed in version 1.11
      :vm_ssl_error, 293,

      # Result properties; these are returned by various procedures
      :job_result_error_code, 3000,
      :job_result_vm_in_group, 3001,
      :job_result_user_message, 3002,
      :job_result_exit_code, 3004,
      :job_result_command_output, 3005,
      :job_result_handle, 3010,
      :job_result_guest_object_exists, 3011,
      :job_result_guest_program_elapsed_time, 3017,
      :job_result_guest_program_exit_code, 3018,
      :job_result_item_name, 3035,
      :job_result_found_item_description, 3036,
      :job_result_shared_folder_count, 3046,
      :job_result_shared_folder_host, 3048,
      :job_result_shared_folder_flags, 3049,
      :job_result_process_id, 3051,
      :job_result_process_owner, 3052,
      :job_result_process_command, 3053,
      :job_result_file_flags, 3054,
      :job_result_process_start_time, 3055,
      :job_result_vm_variable_string, 3056,
      :job_result_process_being_debugged, 3057,
      :job_result_screen_image_size, 3058,
      :job_result_screen_image_data, 3059,
      :job_result_file_size, 3061,
      :job_result_file_mod_time, 3062,
      :job_result_extra_error_info, 3084,

      # Event properties; these are sent in the moreEventInfo for some events.
      :found_item_location, 4010,

      # VIX_HANDLETYPE_SNAPSHOT properties
      :snapshot_displayname, 4200,
      :snapshot_description, 4201,
      :snapshot_powerstate, 4205,
      # :snapshot_is_replayable, 4207, Removed in version 1.11

      :guest_sharedfolders_shares_path, 4525,

      # Virtual machine encryption properties
      :vm_encryption_password, 7001,
    ]

  enum :VixEventType, [
      :job_completed, 2,
      :job_progress, 3,
      :find_item, 8,
      :callback_signalled, 2, # Deprecated - Use VIX_EVENTTYPE_JOB_COMPLETED instead.
    ]

  # These are the property flags for each file.
  FileAttributes = enum(
      :attributes_directory, 0x0001,
      :attributes_symlink, 0x0002,
    )


  # Procedures of this type are called when an event happens on a handle.
  callback :VixEventProc, [
      :VixHandle, # handle
      :VixEventType, # eventType
      :VixHandle, # moreEventInfo,
      :pointer, # void *clientData
    ], :void


  attach_function :Vix_ReleaseHandle, [ :VixHandle ], :void

  attach_function :Vix_AddRefHandle, [ :VixHandle ], :void

  attach_function :Vix_GetHandleType, [ :VixHandle ], :VixHandleType

  attach_function :Vix_GetProperties, [ :VixHandle, :varargs ], :VixError

  attach_function :Vix_GetPropertyType, [
      :VixHandle,
      :VixPropertyID,
      :pointer, # VixPropertyType *propertyType
    ], :VixError

  attach_function :Vix_FreeBuffer, [ :pointer ], :void


  typedef :int, :VixHostOptions
  HostOptions = enum(
      :verify_ssl_cert, 0x4000,
    )

  enum :VixServiceProvider, [
      :default, 1,
      :vmware_server, 2,
      :vmware_workstation, 3,
      :vmware_player, 4,
      :vmware_vi_server, 10,
      :vmware_workstation_shared, 11,
    ]

  # VIX_API_VERSION tells VixHost_Connect to use the latest API version
  # that is available for the product specified in the VixServiceProvider
  # parameter.
  API_VERSION = -1

  attach_function :VixHost_Connect, [
      :int, # apiVersion
      :VixServiceProvider, # hostType
      :string, # const char *hostName
      :int, # hostPort
      :string, # const char *userName
      :string, # const char *password
      :VixHostOptions, # options
      :VixHandle, # propertyListHandle
      :VixEventProc, # callbackProc
      :pointer, # void *clientData
    ], :VixHandle

  attach_function :VixHost_Disconnect, [ :VixHandle ], :void


  attach_function :VixHost_RegisterVM, [
      :VixHandle, # hostHandle
      :string, # const char *vmxFilePath
      :VixEventProc, # callbackProc
      :pointer, # void *clientData
    ], :VixHandle

  attach_function :VixHost_UnregisterVM, [
      :VixHandle, # hostHandle
      :string, # const char *vmxFilePath
      :VixEventProc, # callbackProc
      :pointer, # void *clientData
    ], :VixHandle


  enum :VixFindItemType, [
      :running_vms, 1,
      :registered_vms, 4,
    ]

  attach_function :VixHost_FindItems, [
      :VixHandle, # hostHandle
      :VixFindItemType, # searchType
      :VixHandle, # searchCriteria
      :int32, # timeout
      :VixEventProc, # callbackProc
      :pointer, # void *clientData
    ], :VixHandle


  VMOpenOptions = enum :VixVMOpenOptions, [ :normal, 0 ]

  # VixHost_OpenVM() supersedes VixVM_Open() since it allows for
  # the passing of option flags and extra data in the form of a
  # property list.
  # It is recommended to use VixHost_OpenVM() instead of VixVM_Open().

  attach_function :VixHost_OpenVM, [
      :VixHandle, # hostHandle
      :string, # const char *vmxFilePathName
      :VixVMOpenOptions, # options
      :VixHandle, # propertyListHandle
      :VixEventProc, # *callbackProc
      :pointer, # void *clientData
    ], :VixHandle



  attach_function :VixPropertyList_AllocPropertyList, [
      :VixHandle, # hostHandle
      :pointer, # VixHandle *resultHandle
      :varargs, # int firstPropertyID, ...
    ], :VixError


  # deprecated: use VixHost_OpenVM instead
  attach_function :VixVM_Open, [
      :VixHandle, # hostHandle
      :string, # const char *vmxFilePathName
      :VixEventProc, # *callbackProc
      :pointer, # void *clientData
    ], :VixHandle


  typedef :int, :VixVMPowerOpOptions;
  VMPowerOpOptions = enum(
      :normal, 0,
      :from_guest, 0x0004,
      :suppress_snapshot_poweron, 0x0080,
      :launch_gui, 0x0200,
      :start_vm_paused, 0x1000,
    )

  attach_function :VixVM_PowerOn, [
      :VixHandle, # vmHandle
      :VixVMPowerOpOptions, # powerOnOptions
      :VixHandle, # propertyListHandle
      :VixEventProc, # *callbackProc
      :pointer, # void *clientData
    ], :VixHandle

  attach_function :VixVM_PowerOff, [
      :VixHandle, # vmHandle
      :VixVMPowerOpOptions, # powerOffOptions
      :VixEventProc, # *callbackProc
      :pointer, # void *clientData);
    ], :VixHandle

  attach_function :VixVM_Reset, [
      :VixHandle, # vmHandle
      :VixVMPowerOpOptions, # powerOffOptions
      :VixEventProc, # *callbackProc
      :pointer, # void *clientData);
    ], :VixHandle

  attach_function :VixVM_Suspend, [
      :VixHandle, # vmHandle
      :VixVMPowerOpOptions, # powerOffOptions
      :VixEventProc, # *callbackProc
      :pointer, # void *clientData);
    ], :VixHandle

  attach_function :VixVM_Pause, [
      :VixHandle, # vmHandle
      :VixVMPowerOpOptions, # powerOffOptions
      :VixHandle, # propertyList
      :VixEventProc, # *callbackProc
      :pointer, # void *clientData);
    ], :VixHandle

  attach_function :VixVM_Unpause, [
      :VixHandle, # vmHandle
      :VixVMPowerOpOptions, # powerOffOptions
      :VixHandle, # propertyList
      :VixEventProc, # *callbackProc
      :pointer, # void *clientData);
    ], :VixHandle


  typedef :int, :VixVMDeleteOptions
  VMDeleteOptions = enum(
      :disk_files, 0x0002,
    )


  attach_function :VixVM_Delete, [
      :VixHandle, # vmHandle
      :VixVMDeleteOptions, # deleteOptions
      :VixEventProc, # *callbackProc
      :pointer, # void *clientData
    ], :VixHandle


  typedef :int, :VixPowerState
  PowerState = enum(
      :powering_off, 0x0001,
      :powered_off, 0x0002,
      :powering_on, 0x0004,
      :powered_on, 0x0008,
      :suspending, 0x0010,
      :suspended, 0x0020,
      :tools_running, 0x0040,
      :resetting, 0x0080,
      :blocked_on_msg, 0x0100,
      :paused, 0x0200,
      :resuming, 0x0800,
    )

  typedef :int, :VixToolsState
  ToolsState = enum(
      :unknown, 0x0001,
      :running, 0x0002,
      :not_installed, 0x0004,
    )


  # These flags describe optional functions supported by different
  # types of VM.
  VMSupport = enum(
      :support_shared_folders, 0x0001,
      :support_multiple_snapshots, 0x0002,
      :support_tools_install, 0x0004,
      :support_hardware_upgrade, 0x0008,
    )



  attach_function :VixVM_WaitForToolsInGuest, [
      :VixHandle, # vmHandle
      :int, # timeoutInSeconds
      :VixEventProc, # *callbackProc
      :pointer, # void *clientData
    ], :VixHandle



  VMLoginInGuestOptions = enum(
      :require_interactive_environment, 0x08,
    )

  attach_function :VixVM_LoginInGuest, [
      :VixHandle, # vmHandle
      :string, # const char *userName
      :string, # const char *password
      :int, # options
      :VixEventProc, # *callbackProc
      :pointer, # void *clientData
    ], :VixHandle

  attach_function :VixVM_LogoutFromGuest, [
      :VixHandle, # vmHandle
      :VixEventProc, # *callbackProc
      :pointer, # void *clientData
    ], :VixHandle



  typedef :int, :VixRunProgramOptions
  RunProgramOptions = enum(
      :return_immediately, 0x0001,
      :activate_window, 0x0002,
    )

  attach_function :VixVM_RunProgramInGuest, [
      :VixHandle, # vmHandle
      :string, # const char *guestProgramName
      :string, # const char *commandLineArgs
      :VixRunProgramOptions, # options
      :VixHandle, # propertyListHandle
      :VixEventProc, # *callbackProc
      :pointer, # void *clientData
    ], :VixHandle

  attach_function :VixVM_ListProcessesInGuest, [
      :VixHandle, # vmHandle
      :int, # options
      :VixEventProc, # *callbackProc
      :pointer, # void *clientData
    ], :VixHandle

  attach_function :VixVM_KillProcessInGuest, [
      :VixHandle, # vmHandle,
      :uint64, # pid
      :int, # options
      :VixEventProc, # *callbackProc
      :pointer, # void *clientData
    ], :VixHandle

  attach_function :VixVM_RunScriptInGuest, [
      :VixHandle, # vmHandle
      :string, # const char *interpreter
      :string, # const char *scriptText
      :VixRunProgramOptions, # options
      :VixHandle, # propertyListHandle
      :VixEventProc, # *callbackProc
      :pointer, # void *clientData
    ], :VixHandle


  attach_function :VixVM_CopyFileFromHostToGuest, [
      :VixHandle, # vmHandle
      :string, # const char *hostPathName
      :string, # const char *guestPathName
      :int, # options
      :VixHandle, # propertyListHandle
      :VixEventProc, # *callbackProc
      :pointer, # void *clientData
    ], :VixHandle

  attach_function :VixVM_CopyFileFromGuestToHost, [
      :VixHandle, # vmHandle
      :string, # const char *guestPathName
      :string, # const char *hostPathName
      :int, # options
      :VixHandle, # propertyListHandle
      :VixEventProc, # *callbackProc
      :pointer, # void *clientData
    ], :VixHandle

  attach_function :VixVM_DeleteFileInGuest, [
      :VixHandle, # vmHandle
      :string, # const char *guestPathName
      :VixEventProc, # *callbackProc
      :pointer, # void *clientData
    ], :VixHandle

  attach_function :VixVM_FileExistsInGuest, [
      :VixHandle, # vmHandle
      :string, # const char *guestPathName
      :VixEventProc, # *callbackProc
      :pointer, # void *clientData
    ], :VixHandle

  attach_function :VixVM_RenameFileInGuest, [
      :VixHandle, # vmHandle
      :string, # const char *oldName
      :string, # const char *newName
      :int, # options
      :VixHandle, # propertyListHandle
      :VixEventProc, # *callbackProc
      :pointer, # void *clientData
    ], :VixHandle

  attach_function :VixVM_CreateTempFileInGuest, [
      :VixHandle, # vmHandle
      :int, # options
      :VixHandle, # propertyListHandle
      :VixEventProc, # *callbackProc
      :pointer, # void *clientData
    ], :VixHandle

  attach_function :VixVM_GetFileInfoInGuest, [
      :VixHandle, # vmHandle
      :string, # const char *pathName
      :VixEventProc, # *callbackProc
      :pointer, # void *clientData
    ], :VixHandle



  attach_function :VixVM_ListDirectoryInGuest, [
      :VixHandle, # vmHandle
      :string, # const char *pathName
      :int, # options
      :VixEventProc, # *callbackProc
      :pointer, # void *clientData
    ], :VixHandle

  attach_function :VixVM_CreateDirectoryInGuest, [
      :VixHandle, # vmHandle
      :string, # const char *pathName
      :VixHandle, # propertyListHandle
      :VixEventProc, # *callbackProc
      :pointer, # void *clientData
    ], :VixHandle

  attach_function :VixVM_DeleteDirectoryInGuest, [
      :VixHandle, # vmHandle
      :string, # const char *pathName
      :int, # options
      :VixEventProc, # *callbackProc
      :pointer, # void *clientData
    ], :VixHandle

  attach_function :VixVM_DirectoryExistsInGuest, [
      :VixHandle, # vmHandle
      :string, # const char *pathName
      :VixEventProc, # *callbackProc
      :pointer, # void *clientData
    ], :VixHandle



  enum :VariableType, [
      :vm_guest_variable, 1,
      :vm_config_runtime_only, 2,
      :guest_environment_variable, 3,
    ]

  attach_function :VixVM_ReadVariable, [
      :VixHandle, # vmHandle
      :VariableType, # int variableType
      :string, # const char *name
      :int, # options
      :VixEventProc, # *callbackProc
      :pointer, # void *clientData
    ], :VixHandle

  attach_function :VixVM_WriteVariable, [
      :VixHandle, # vmHandle
      :VariableType, # int variableType
      :string, # const char *valueName
      :string, # const char *value
      :int, # options
      :VixEventProc, # *callbackProc
      :pointer, # void *clientData
    ], :VixHandle



  attach_function :VixVM_GetNumRootSnapshots, [
      :VixHandle, # vmHandle
      :pointer, # int *result
    ], :VixError

  attach_function :VixVM_GetRootSnapshot, [
      :VixHandle, # vmHandle
      :int, # index
      :pointer, # VixHandle *snapshotHandle
    ], :VixError

  attach_function :VixVM_GetCurrentSnapshot, [
      :VixHandle, # vmHandle
      :pointer, # VixHandle *snapshotHandle
    ], :VixError

  attach_function :VixVM_GetNamedSnapshot, [
      :VixHandle, # vmHandle
      :string, # const char *name
      :pointer, # VixHandle *snapshotHandle
    ], :VixError


  typedef :int, :VixRemoveSnapshotOptions
  RemoveSnapshotOptions = enum(
      :remove_children, 0x0001,
    )

  attach_function :VixVM_RemoveSnapshot, [
      :VixHandle, # vmHandle
      :VixHandle, # snapshotHandle
      :VixRemoveSnapshotOptions, # options
      :VixEventProc, # *callbackProc
      :pointer, # void *clientData
    ], :VixHandle

  attach_function :VixVM_RevertToSnapshot, [
      :VixHandle, # vmHandle
      :VixHandle, # snapshotHandle
      :VixVMPowerOpOptions, # options
      :VixHandle, # propertyListHandle
      :VixEventProc, # *callbackProc
      :pointer, # void *clientData
    ], :VixHandle

  typedef :int, :VixCreateSnapshotOptions
  CreateSnapshotOptions = enum(
      :include_memory, 0x0002,
    )

  attach_function :VixVM_CreateSnapshot, [
      :VixHandle, # vmHandle
      :string, # const char *name
      :string, # const char *description
      :VixCreateSnapshotOptions, # options
      :VixHandle, # propertyListHandle
      :VixEventProc, # *callbackProc
      :pointer, # void *clientData
    ], :VixHandle


  typedef :int, :VixMsgSharedFolderOptions
  SharedFolderOptions = enum(
      :write_access, 0x04,
    )

  attach_function :VixVM_EnableSharedFolders, [
      :VixHandle, # vmHandle
      :bool, # Bool enabled
      :int, # options
      :VixEventProc, # *callbackProc
      :pointer, # void *clientData
    ], :VixHandle

  attach_function :VixVM_GetNumSharedFolders, [
      :VixHandle, # vmHandle
      :VixEventProc, # *callbackProc
      :pointer, # void *clientData
    ], :VixHandle

  attach_function :VixVM_GetSharedFolderState, [
      :VixHandle, # vmHandle
      :int, # index
      :VixEventProc, # *callbackProc
      :pointer, # void *clientData
    ], :VixHandle

  attach_function :VixVM_SetSharedFolderState, [
      :VixHandle, # vmHandle
      :string, # const char *shareName
      :string, # const char *hostPathName
      :VixMsgSharedFolderOptions, # flags
      :VixEventProc, # *callbackProc
      :pointer, # void *clientData
    ], :VixHandle

  attach_function :VixVM_AddSharedFolder, [
      :VixHandle, # vmHandle
      :string, # const char *shareName
      :string, # const char *hostPathName
      :VixMsgSharedFolderOptions, # flags
      :VixEventProc, # *callbackProc
      :pointer, # void *clientData
    ], :VixHandle

  attach_function :VixVM_RemoveSharedFolder, [
      :VixHandle, # vmHandle
      :string, # const char *shareName
      :int, # flags
      :VixEventProc, # *callbackProc
      :pointer, # void *clientData
    ], :VixHandle


  CaptureScreenFormat = enum(
      :png, 0x01,
      :png_nocompress, 0x02,
  )

  attach_function :VixVM_CaptureScreenImage, [
      :VixHandle, # vmHandle
      :int, # captureType
      :VixHandle, # additionalProperties
      :VixEventProc, # *callbackProc
      :pointer, # void *clientdata
    ], :VixHandle



  enum :VixCloneType, [
      :full, 0,
      :linked, 1,
    ]

  attach_function :VixVM_Clone, [
      :VixHandle, # vmHandle
      :VixHandle, # snapshotHandle
      :VixCloneType, # cloneType
      :string, # const char *destConfigPathName
      :int, # options
      :VixHandle, # propertyListHandle
      :VixEventProc, # *callbackProc
      :pointer, # void *clientData
    ], :VixHandle



  attach_function :VixVM_UpgradeVirtualHardware, [
      :VixHandle, # vmHandle
      :int, # options
      :VixEventProc, # *callbackProc
      :pointer, # void *clientData
    ], :VixHandle

  InstallToolsOptions = enum(
      :mount_tools_installer, 0x00,
      :auto_upgrade, 0x01,
      :return_immediately, 0x02,
    )

  attach_function :VixVM_InstallTools, [
      :VixHandle, # vmHandle
      :int, #  options
      :string, # const char *commandLineArgs
      :VixEventProc, # *callbackProc
      :pointer, # void *clientData
    ], :VixHandle



  attach_function :VixJob_Wait, [
      :VixHandle, #  jobHandle
      :varargs # int propertyID, ...
    ], :VixError

  attach_function :VixJob_CheckCompletion, [
      :VixHandle, # jobHandle
      :pointer, # Bool *complete
    ], :VixError


  attach_function :VixJob_GetError, [ :VixHandle ], :VixError

  attach_function :VixJob_GetNumProperties, [
      :VixHandle, # jobHandle
      :int, # resultPropertyID
    ], :int

  attach_function :VixJob_GetNthProperties, [
      :VixHandle, # jobHandle
      :int, # index
      :varargs # int propertyID, ...
    ], :VixError



  attach_function :VixSnapshot_GetNumChildren, [
      :VixHandle, # parentSnapshotHandle
      :pointer, # int *numChildSnapshots
    ], :VixError

  attach_function :VixSnapshot_GetChild, [
      :VixHandle, # parentSnapshotHandle
      :int, # index
      :pointer, # VixHandle *childSnapshotHandle
    ], :VixError

  attach_function :VixSnapshot_GetParent, [
      :VixHandle, # snapshotHandle
      :pointer, # VixHandle *parentSnapshotHandle
    ], :VixError

  class Error < StandardError
    attr_reader :errno

    def initialize (errno)
      @errno = errno
      super( LibVix.Vix_GetErrorText( errno, nil ) )
    end
  end

end # module LibVix
end # module Vix
end # module VMware
