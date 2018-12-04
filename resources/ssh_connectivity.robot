*** Keywords ***
# private:
Open All Connections
  ${CONNECTIONS} =            Create Dictionary
  Set Suite Variable          ${CONNECTIONS}
  Log Start Message           Open All Connections

  ${HOST_LIST_LENGTH} =        Get Length  ${HOST_MANAGEMENT_IP_LIST}
  Set Suite Variable           ${HOST_LIST_LENGTH}

  # Asynchronously start all hosts.
  Start All Hosts

  # Wait until they all start.
  Shallow Wait For All Hosts
  Wait Until Keyword Succeeds     ${WAIT_FOR_HOST_RETRIES}  ${WAIT_FOR_HOST_TIME}  Open Default Connection To Orchestration Manager
  Wait Until Keyword Succeeds     ${WAIT_FOR_HOST_RETRIES}  ${WAIT_FOR_HOST_TIME}  Open Default Connection To All Hosts
  Log End Message


Open Default Connection To Orchestration Manager
  ${ORCHESTRATION_MANAGER} =  Open Default Connection To Host  ${ORCHESTRATION_MANAGER_MANAGEMENT_IP}
  Set Suite Variable          ${ORCHESTRATION_MANAGER}
  Set To Dictionary  ${CONNECTIONS}  ${ORCHESTRATION_MANAGER}  Orchestration-Manager-${ORCHESTRATION_MANAGER_MANAGEMENT_IP}


Open Default Connection To All Hosts
  ${HOST_LIST} =         Create List
  Set Suite Variable     ${HOST_LIST}
  :FOR  ${ip}  IN  @{HOST_MANAGEMENT_IP_LIST}
  \  ${connection_id} =  Open Default Connection To Host  ${ip}
  \  Append To List      ${HOST_LIST}  ${connection_id}


Open Default Connection To Host
  [Arguments]  ${ip}
  ${connection_id} =  Open Connection To Host  ${ip}  ${SSH_USER}  ${SSH_KEY}  ${SSH_PASSKEY}
  [Return]            ${connection_id}


Open Connection To Host
  [Arguments]  ${ip}  ${username}  ${keyfile}  ${keypassword}
  ${connection_id} =     Open Connection  ${ip}
  Login With Public Key  ${username}  ${keyfile}  ${keypassword}
  [Return]               ${connection_id}


Empty SSH Command To Host
  [Arguments]  ${host}
  Run Command On Remote Host  true  ${host}
