# deepsecurity

## CHANGELOG (notable new features or fixes)

### 0.0.24

* Send debug logs to STDERR
* Unparseable Array should work now

### 0.0.23

* Fix call for warn_unparseable_data()

### 0.0.22

* Use Ruby 1.9.3-p448 on Windows for installer
* Use "real" InnoSetup in Windows VM

### 0.0.21

* Extended `-fields` to accept a filename to read the fields from
* Added warning for unparseable entries

### 0.0.20

* `dsc` command refactoring
* SOAP Interface refactoring
* Extracted savon TypeMapping functionality/DSL into seperate classes
* Added `--detail_level` flag for `host_detail` command
* Added `-time_format` flag to specifiy time format


### 0.0.19

* Updated documentation
* Streamlined search API (e.g. `find(id)` vs. `find_by_id(id)`
* host_group hint accessor for hosts/host_details


### 0.0.18

* Added automatic build of Windows Installer