*** Keywords ***
# public:
Add Traffic Control Delay To Interface
  [Arguments]  ${interface}  ${delay}  @{hosts}
  Remove Traffic Control Delay From Interface  ${interface}  @{hosts}
  :FOR  ${host}  IN  @{hosts}
  \  Run Command On Remote Host  tc qdisc add dev ${interface} root netem delay ${delay}  ${host}

Remove Traffic Control Delay From Interface
  [Arguments]  ${interface}  @{hosts}
  :FOR  ${host}  IN  @{hosts}
  \  Run Command Ignore Errors On Remote Host  tc qdisc delete dev ${interface} root netem  ${host}
