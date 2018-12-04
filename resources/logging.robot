*** Keywords ***
# public:
Initialize Logging
  ${LOG_STACK} =      Create List
  Set Suite Variable  ${LOG_STACK}


Sleep
  [Arguments]  ${time}
  Log Start Message  Sleep ${time}
  # Builtin.Sleep required to not come in conflict with this keyword and make
  # infinite recursion.
  Builtin.Sleep      ${time}
  Log End Message


# private:
Log Start Message
  [Arguments]  ${message}  @{hosts}
  ${HOSTS_STRING} =   Catenate
  Set Suite Variable  ${HOSTS_STRING}
  ${is_first} =       Evaluate  True
  :FOR  ${host}  IN  @{hosts}
  \  ${host_description} =  Get From Dictionary  ${CONNECTIONS}  ${host}
  \  Run Keyword If         ${is_first} == True  First Append To Hosts String  ${host_description}
  \  Run Keyword If         ${is_first} == False  Append To Hosts String  ${host_description}
  \  ${is_first} =          Evaluate  False
  ${message} =    Catenate  ${message} ${HOSTS_STRING}
  Log Message     ${ACTION_START_LABEL}: ${message}
  Append To List  ${LOG_STACK}  ${message}


First Append To Hosts String
  [Arguments]  ${host_description}
  Set Suite Variable  ${HOSTS_STRING}  on ${host_description}


Append To Hosts String
  [Arguments]  ${host_description}
  Set Suite Variable  ${HOSTS_STRING}  ${HOSTS_STRING}, ${host_description}


Log End Message
  ${message} =  Remove From List  ${LOG_STACK}  -1
  Log Message   ${ACTION_END_LABEL}: ${message}


Log Message
  [Arguments]  ${message}
  Run Command  logger -t "${RSYSLOG_TAG}" "${message}"


Log Message On Remote Hosts
  [Arguments]  ${message}  @{hosts}
  :FOR  ${host}  IN  @{hosts}
  \  Run Command On Remote Host  logger "${message}"  ${host}
