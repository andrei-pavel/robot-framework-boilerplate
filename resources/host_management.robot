*** Keywords ***
# public:
Start All Hosts
  :FOR  ${i}  IN RANGE  1  ${HOST_LIST_LENGTH} + 1
  \  Start Hosts  ${HOST_PREFIX}${i}${HOST_SUFFIX}

# private:
Start Hosts
  [Arguments]  @{hosts}
  :FOR  ${host}  IN  @{hosts}
  \  Host Action  start  ${host}


Stop Hosts
  [Arguments]  @{hosts}
  :FOR  ${host}  IN  @{hosts}
  \  Host Action  destroy  ${host}


Host Action
  [Arguments]  ${action}  @{hosts}
  :FOR  ${host}  IN  @{hosts}
  \  Log Start Message          Host Action ${action} ${host}
  \  Run Command Ignore Errors  virsh ${action} ${host}
  \  Log End Message


Wait For Hosts
  [Arguments]  @{hosts}
  :FOR  ${host}  IN  @{hosts}
  \  Log Start Message            Wait For Hosts  ${host}
  \  Wait Until Keyword Succeeds  ${WAIT_FOR_HOST_RETRIES}  ${WAIT_FOR_HOST_TIME}  Empty SSH Command To Host  ${host}
  \  Log End Message


Shallow Wait For All Hosts
  :FOR  ${i}  IN RANGE  1  ${HOST_LIST_LENGTH} + 1
  \  ${host} =  Catenate  ${HOST_PREFIX}${i}${HOST_SUFFIX}
  \  Wait Until Keyword Succeeds  ${WAIT_FOR_HOST_RETRIES}  ${WAIT_FOR_HOST_TIME}  Host Should Be Running  ${host}


Shallow Wait For Hosts
  [Arguments]  @{hosts}
  :FOR  ${host}  IN  @{hosts}
  \  Log Start Message            Shallow Wait For Hosts  ${host}
  \  Wait Until Keyword Succeeds  ${WAIT_FOR_HOST_RETRIES}  ${WAIT_FOR_HOST_TIME}  Host Should Be Running  ${host}
  \  Log End Message


Host Should Be Running
  [Arguments]  ${host}
  ${state} =  Get Host Status  ${host}
  Should Be Equal As Strings  ${state}  running  msg=Host ${host} is not running


Get Host Status
  [Arguments]  ${host}
  ${state}  ${rc} =  Run Command  virsh domstate ${host} | head -n 1
  [Return]           ${state}


Get Host Name
  [Arguments]  ${host}
  ${index} =      Get Index From List  ${HOST_LIST}  ${host}
  ${host_name} =  Get From List  ${MANAGEMENT_IP_LIST}  ${index}
  [Return]        ${host_name}
