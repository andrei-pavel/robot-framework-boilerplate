*** Keywords ***
# private:
Service Should Exist On Remote Hosts
  [Arguments]  ${service}  @{hosts}
  :FOR  ${host}  IN  @{hosts}
  \  ${loaded}  ${rc} =              Run Command On Remote Host  service ${service} status | grep Loaded: | tr -s " " | cut -d " " -f 3  ${host}
  \  ${host_name} =                  Get Host Name  ${host}
  \  Should Not Be Equal As Strings  ${loaded}  not-found  msg=Service ${service} does not exist on host ${host_name}


Start Service On Remote Hosts
  [Arguments]  ${service}  @{hosts}
  Service Action On Remote Hosts  start  ${service}  @{hosts}


Restart Service On Remote Hosts
  [Arguments]  ${service}  @{hosts}
  Service Action On Remote Hosts  restart  ${service}  @{hosts}


Restart SysV-init Service On Remote Hosts
  [Arguments]  ${service}  @{hosts}
  SysV-init Service Action On Remote Hosts  restart  ${service}  @{hosts}


Stop Service On Remote Hosts
  [Arguments]  ${service}  @{hosts}
  Service Action On Remote Hosts  stop  ${service}  @{hosts}


Service Action On Remote Hosts
  [Arguments]  ${action}  ${service}  @{hosts}
  :FOR  ${host}  IN  @{hosts}
  \  Log Start Message   Service Action On Remote Hosts ${action} ${service}  ${host}
  \  ${pid}  ${rc} =     Run Command Ignore Errors On Remote Host  pidof systemd  ${host}
  \  ${has_systemd} =    Get Length  ${pid}
  \  # Ignore Errors because we aren't always guaranteed to succeed in running a service action
  \  Run Keyword If      ${has_systemd}  Run Command Ignore Errors On Remote Host  systemctl ${action} ${service}  ${host}
  \  Run Keyword Unless  ${has_systemd}  Run Command Ignore Errors On Remote Host  service ${service} ${action}  ${host}
  \  Log End Message


SysV-init Service Action On Remote Hosts
  [Arguments]  ${action}  ${service}  @{hosts}
  :FOR  ${host}  IN  @{hosts}
  \  Log Start Message   SysV-init Service Action On Remote Hosts ${action} ${service}  ${host}
  \  Run Command Ignore Errors On Remote Host  service ${service} ${action}  ${host}
  \  Log End Message


Wait For Service On Remote Hosts
  [Arguments]  ${service}  @{hosts}
  :FOR  ${host}  IN  @{hosts}
  \  Log Start Message            Wait For Service On Remote Hosts ${service}  ${host}
  \  Wait Until Keyword Succeeds  ${WAIT_FOR_SERVICE_RETRIES}  ${WAIT_FOR_SERVICE_TIME}  Service Should Be Running On Remote Hosts  ${service}  ${host}
  \  Log End Message


Service Should Be Running On Remote Hosts
  [Arguments]  ${service}  @{hosts}
  :FOR  ${host}  IN  @{hosts}
  \  ${state} =                  Get Service Status On Remote Host  ${service}  ${host}
  \  ${host_name} =              Get Host Name  ${host}
  \  Should Be Equal As Strings  ${state}  active (running)  msg=Service ${service} is not running on host ${host_name}


Get Service Status On Remote Host
  [Arguments]  ${service}  ${host}
  ${output}  ${rc} =  Run Command On Remote Host  systemctl status ${service} | grep Active: | tr -s " " | cut -d " " -f 3-4  ${host}
  [Return]            ${output}
