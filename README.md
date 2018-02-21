# Robot Framework

## Introduction
These tests are written robot framework is a language wrapper over `python`.
They run on the orchestration manager which has SSH access to all the remote
hosts.

---


## Installation
* On orchestrator:
    * `apt-get install python2-pip`
    * `pip install pyyaml`
    * `pip install robotframework`
    * `pip install robotframework-sshlibrary`

---


## Configuration
* Make sure:
    * all remote hosts are running Ubuntu 16.04 or newer
    * variables are configured in [environment.yaml](../environment.yaml); for
empty values, surround with single quotes (`'`); if you need to reference a path
relative to `dt-testing-framework`, use `_ROOTDIR`
    * all hosts have a name prefix and, optionally, a name suffix; the prefix is
followed by a sequential index starting with 1 which is followed by a suffix
(e.g. `test-host1-x`, `test-host2-x` for prefix `test-host` and
suffix `-x`); prefixes and suffixes are common to all other hosts that
belong to the same group.
* Install public SSH key [ssh-config/id_rsa.pub](ssh-config/id_rsa.pub) on the
orchestration manager and all the other remote hosts:
    * `ssh-copy-id -i ssh-config/id_rsa.pub ${HOST}`

---


## Execution
`../run-robot [-d|--debug] [-h|--help] [-o|--output-dir $output_directory] [-t|--test $test_name]`

OR

`robot [-h|--help] [-d|--outputdir $output_directory] [-t|--test $test_name] robot-framework/tests.robot`

`$output_directory` can be any directory with read & write permissions (defaults
to: `./output`) and after run it has the following structure:

```
. +
  |- log.html                                                                            : Log containing debug information for last run test cases
  |- output.xml                                                                          : Same debug log in XML format; used by Robot internally
  |- report.html                                                                         : A report specifying which tests have passed and which have failed
  |- Test-Case-1-Testing-Framework-Works +                                               : Directory containing test case 1 information
  |                       |- Test-Case-1-Testing-Framework-Works.log                     : Log collected with rsyslog
  |                       `- Test-Case-1-Testing-Framework-Works.rla                     : Log-analyzer result
  |                       `- Test-Case-1-Testing-Framework-Works.rsa                     : State-analyzer result
  |- Test-Case-2-Remote-Hosts-Are-Linux-Distributions +                                  : Directory containing test case 2 information
  |                             |- Test-Case-2-Remote-Hosts-Are-Linux-Distributions.log  : Log collected with rsyslog
  |                             `- Test-Case-2-Remote-Hosts-Are-Linux-Distributions.rla  : Log-analyzer result
  |                             `- Test-Case-2-Remote-Hosts-Are-Linux-Distributions.rsa  : State-analyzer result
  `- ...
```

* `$test_name` can have the following values:
    * `Test-Case-1-Testing-Framework-Works`
    * `Test-Case-2-Remote-Hosts-Are-Linux-Distributions`

---


## Development sources
Extension of the Robot framework would require changes to the following source
files:

| File                                                                                 | Description                                              |
|--------------------------------------------------------------------------------------|----------------------------------------------------------|
|  [../environment.yaml](../environment.yaml)                                          |  global variables that are used in keywords              |
|  [resources/filesystem_management.robot](resources/filesystem_management.robot)      |  keywords related to filesystem management               |
|  [resources/general.robot](resources/general.robot)                                  |  general or miscellaneous keywords                       |
|  [resources/host_management.robot](resources/host_management.robot)                  |  keywords related to filesystem management               |
|  [resources/logging.robot](resources/logging.robot)                                  |  log-processing keywords                                 |
|  [resources/process_management.robot](resources/process_management.robot)            |  keywords that handle processes                          |
|  [resources/service_management.robot](resources/service_management.robot)            |  keywords that handle services                           |
|  [resources/ssh_connectivity.robot](resources/ssh_connectivity.robot)                |  keywords that handle SSH connections                    |
|  [tests.robot](tests.robot)                                                          |  the implementations of the actual test cases            |

---

