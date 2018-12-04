*** Keywords ***
# public:
No Other Robot Should Run
  Log Start Message            No Other Robot Should Run
  ${pids_string}  ${rc} =      Run command  pgrep -f "/usr/bin/python .*robot"
  ${pids_list} =               Split String  ${pids_string}  ${SPACE}
  ${pid_count} =               Get Length  ${pids_list}
  Should Be Equal As Integers  ${pid_count}  1
  Log End Message


# private:
Kill Processes On Remote Hosts
  [Arguments]  ${process}  @{hosts}
  Log Start Message                          Kill Processes On Remote Hosts ${process}  @{hosts}
  :FOR  ${host}  IN  @{hosts}
  \  # Ignore Errors because we aren't always guaranteed to kill something.
  \  Run Command Ignore Errors On Remote Host  killall ${process}  ${host}
  Log End Message


Kill Processes By Regular Expression Pattern On Remote Hosts
  [Arguments]  ${regexp}  @{hosts}
  Log Start Message                            Kill Processes By Regular Expression Pattern On Remote Hosts ${regexp}  @{hosts}
  :FOR  ${host}  IN  @{hosts}
  \  # Ignore Errors because we aren't always guaranteed to kill something.
  \  Run Command Ignore Errors On Remote Host  pkill -f ${regexp}  ${host}
  Log End Message


Kill Processes
  [Arguments]  ${process}
  Log Start Message          Kill Processes ${process}
  # Ignore Errors because we aren't always guaranteed to kill something.
  Run Command Ignore Errors  killall ${process}
  Log End Message


Kill Processes By Regular Expression Pattern
  [Arguments]  ${regexp}
  Log Start Message          Kill Processes By Regular Expression Pattern ${regexp}
  # Ignore Errors because we aren't always guaranteed to kill something.
  Run Command Ignore Errors  pkill -f ${regexp}
  Log End Message


Wait For Process On Remote Hosts
  [Arguments]  ${process}  @{hosts}
  :FOR  ${host}  IN  @{hosts}
  \  Log Start Message            Wait For Process On Remote Hosts ${process}  ${host}
  \  Wait Until Keyword Succeeds  ${WAIT_FOR_SERVICE_RETRIES}  ${WAIT_FOR_SERVICE_TIME}  Process Should Run On Remote Hosts  ${process}  ${host}
  \  Log End Message


Process Should Run On Remote Hosts
  [Arguments]  ${process}  @{hosts}
  :FOR  ${host}  IN  @{hosts}
  \  # Ignore Errors because we aren't always guaranteed to kill something.
  \  Run Command On Remote Host  pgrep -f ${process}  ${host}
