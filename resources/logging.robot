*** Keywords ***
# public:
Logged Sleep
  [Arguments]  ${time}
  Log Start Message  Logged Sleep ${time}
  Sleep              ${time}
  Log End Message    Logged Sleep ${time}


# private:
Log Start Message
  [Arguments]  ${message}
  Log Message  Starting: ${message}


Log End Message
  [Arguments]  ${message}
  Log Message  Ending: ${message}


Log Message
  [Arguments]  ${message}
  Run Command  logger -t "${RSYSLOG_TAG}" "${message}"


Log Message On Remote Hosts
  [Arguments]  ${message}  @{hosts}
  :FOR  ${host}  IN  @{hosts}
  \  Run Command On Remote Host  logger "${message}"  ${host}

