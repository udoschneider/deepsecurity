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

The `--fields` flag takes a list of comma-separated values of fields to display. You can check available fields usind the `schema` subcommand.
You can also get further output by separating method calls with a dot `.`. E.g.: If the field itself is called `host_name` you can also
specify `host_name.size` which would call the `size()` method returning the length of the String.

### TIME FILTER

The `--time_filter` flag allows you to specify the time to be queried. One of

* last_hour
* last_24_hours
* last_7_days
* last_day

Please note the difference between `last_24_hours` and `last_day`. `last_24_hours` returns events from the current time yesterday to now.
`last_day` returns events from yesterday 00:00:00UTC to 23:59:59UTC.

### DETAIL LEVEL

The `--detail_level` flag allows you to specify the ammount of data queried for some commands. Possible options are

* low
* medium
* high

Please note that this is especially interesting if you are querying lots of objects as this reduces the ammount of data
queried from the database as well as the network traffic.

Please also note that if certain fields are empty it might be worth using higher query levels if you need that data.

### TIME FORMAT

The `--time_format` allows you to specify a `strftime()` compatible string to use for outputting date/time. Please check
http://www.ruby-doc.org/core-2.0/Time.html#method-i-strftime for possible parameters.

# TIPS & TRICKS

## DEFINE ROLE/USER FOR SOAP ACCESS

TODO

## UNLOCK A LOCKED ACCOUNT

[How to unlock a username that has been locked out](http://esupport.trendmicro.com/solution/en-us/1055084.aspx)




