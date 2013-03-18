# dsc

`dsc` (Deep Security Client) is a command line client for Trend Micro's Deep Security product.
In its current version it allows you to query a Deep Security Manager for Host Status and Malware Event information.

## SYNOPSIS
    dsc [global options] command [command options] [arguments...]

### GLOBAL OPTIONS
    -P                      - Show progressbar
    -d, --debug=debug       - Enable client debug output. (One of debug, info, warn, error, fatal) (default: none)
    --help                  - Show this message
    -m, --manager=hostname  - Deep Security Manager Host (default: none)
    -o, --outfile=arg       - Output filename (default: --)
    -p, --password=password - Password (default: none)
    --port=port             - Webservice Port (default: 4119)
    -t, --tenant=tenat      - Tenat Name (default: )
    -u, --username=username - Username (default: MasterAdmin)
    --version               -

## COMMANDS

Most commands provide multiple subcommands. The most usefull are:

* `schema`
* `list`


### SUBCOMMANDS

#### `schema`

The `schema` subcommand displays a list of all known attributes with types and descriptions for the given command. E.g.:

    $ dsc host_detail schema
    anti_malware_classic_pattern_version (String): Current version of the classic Anti-Malware pattern
    anti_malware_engine_version (String): Current version of the Anti-Malware engine
    anti_malware_intelli_trap_exception_version (String): Current version of the IntelliTrap exception pattern
    anti_malware_intelli_trap_version (String): Current version of the IntelliTrap pattern
    anti_malware_smart_scan_pattern_version (String): Current version of the Smart Scan pattern
    anti_malware_spyware_pattern_version (String): Current version of the Spyware pattern
    [...]
    security_profile_id (int): Assigned SecurityProfileTransport ID
    security_profile_name (String): Name of the security profile assigned to the computer
    virtual_name (String): Internal virtual name (only populated if this is a computer provisioned through vCenter)
    virtual_uuid (String): Internal virtual UUID (only populated if this is a computer provisioned through vCenter)

These fields can be used in manual `--fields` definitions.

#### list

The `list` subcommand displays a list of entries for the given command - optionally filtered by additional filters.

### `host_detail list`

The `host_detail list` command dislays a list of host details.

    NAME
        list - List Host Details

    SYNOPSIS
        dsc [global options] host_detail list [command options]

    COMMAND OPTIONS
        --fields=arg - A comma separated list of fields to display. (Available fields: anti_malware_classic_pattern_version, anti_malware_engine_version, anti_malware_intelli_trap_exception_version, anti_malware_intelli_trap_version,
                       anti_malware_smart_scan_pattern_version, anti_malware_spyware_pattern_version, cloud_object_image_id, cloud_object_instance_id, cloud_object_internal_unique_id, cloud_object_security_group_ids, cloud_object_type,
                       component_klasses, component_names, component_types, component_versions, description, display_name, external, external_id, host_group_id, host_group_name, host_interfaces, host_light, host_type, id,
                       last_anit_malware_scheduled_scan, last_anti_malware_event, last_anti_malware_manual_scan, last_dpi_event, last_firewall_event, last_integrity_monitoring_event, last_ip_used, last_log_inspection_event,
                       last_web_reputation_event, light, locked, name, overall_anti_malware_status, overall_dpi_status, overall_firewall_status, overall_integrity_monitoring_status, overall_last_recommendation_scan,
                       overall_last_successful_communication, overall_last_successful_update, overall_last_update_required, overall_log_inspection_status, overall_status, overall_version, overall_web_reputation_status, platform,
                       security_profile_id, security_profile_name, virtual_name, virtual_uuid) (default:
                       name,display_name,anti_malware_classic_pattern_version,anti_malware_engine_version,anti_malware_intelli_trap_exception_version,anti_malware_intelli_trap_version,anti_malware_smart_scan_pattern_version,anti_malware_spyware_pattern_version,overall_last_successful_communication,platform,host_type,host_group_id)

If you don't specify an explicit list of fields, the following fields are used by default:

* name
* display_name
* anti_malware_classic_pattern_version
* anti_malware_engine_version
* anti_malware_intelli_trap_exception_version
* anti_malware_intelli_trap_version
* anti_malware_smart_scan_pattern_version
* anti_malware_spyware_pattern_version
* overall_last_successful_communication
* platform
* host_type
* host_group_id

### `anti_malware_event list`

The `anti_malware_event list`command displays a list of AntiMalware events.

    NAME
        list - List Anti Malware Events

    SYNOPSIS
        dsc [global options] anti_malware_event list [command options]

    COMMAND OPTIONS
        --fields=arg      - A comma separated list of fields to display. (Available fields: anti_malware_config_id, anti_malware_event_id, end_time, error_code, host, host_id, infected_file_path, infection_source, log_date, malware_name,
                            malware_type, protocol, quarantine_record_id, scan_action1, scan_action2, scan_result_action1, scan_result_action2, scan_type, spyware_items, start_time, summary_scan_result, tags) (default:
                            host.name,host.display_name,log_date,start_time,end_time,scan_action1,scan_action2,summary_scan_result,scan_result_action1,scan_result_action2,malware_name,malware_type,infected_file_path,infection_source)
        --time_filter=arg - A filter specifying the time interval to query (One of last_hour, last_24_hours, last_7_days, last_day) (default: last_day)

If you don't specify an explicit list of fields, the following fields are used by default:

* host.name
* host.display_name
* log_date
* start_time
* end_time
* scan_action1
* scan_action2
* summary_scan_result
* scan_result_action1
* scan_result_action2
* malware_name
* malware_type
* infected_file_path
* infection_source

Please note that if you don't specify a time filter all events of the previous day (00:00:00UTC-23:59:59UTC).


## COMMAND OPTIONS

### FIELDS

The `--fields` option takes a list of comma-separated values of fields to display. You can check available fields usind the `schema` subcommand.
You can also get further output by separating method calls with a dot `.`. E.g.: If the field itself is called `host_name` you can also
specify `host_name.size` which would call the `size()` method returning the length of the String.

### TIME FILTER

The `--time_filter` option allows you to specify the time to be queried. One of

* last_hour
* last_24_hours
* last_7_days
* last_day

Please note the difference between `last_24_hours` and `last_day`. `last_24_hours` returns events from the current time yesterday to now.
`last_day` returns events from yesterday 00:00:00UTC to 23:59:59UTC.

# TIPS & TRICKS

## DEFINE ROLE/USER FOR SOAP ACCESS

TODO

## UNLOCK A LOCKED ACCOUNT

[How to unlock a username that has been locked out](http://esupport.trendmicro.com/solution/en-us/1055084.aspx)




