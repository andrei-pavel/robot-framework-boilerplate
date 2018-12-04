*** Keywords ***
# public:
Suite Setup
  Minimal Suite Setup
  Log Start Message  Suite Setup
  Supply All Services
  Sanity Checks
  Close All Connections
  Log End Message


Minimal Suite Setup
  Initialize Logging
  Resolve Variables
#  No Other Robot Should Run
  Open All Connections


Recreate Snapshots
  ${snapshot_name} =  Catenate  ready-for-testing-framework
  Run Command  for host in $(virsh list --all | grep q-test | tr -s ' ' | cut -d ' ' -f 3); do virsh destroy \${host}; virsh snapshot-delete ${snapshot_name}; virsh snapshot-create-as \${host} ${snapshot_name}; done


Suite Teardown
  Log Start Message  Suite Teardown
  Close All Connections
  Log End Message


Start Up
  Log Start Message  ${INITIAL_CLEANUP_LABEL}
  Open All Connections
  Shallow Wait For All Hosts
  Log End Message


Wrap Up
  Log Start Message  Wrap Up
  Open All Connections
  Stop All Services
  Prepare Log
  Run Log Analyzer
  Close All Connections
  Log End Message


# private:
Resolve Variables
  Log Start Message  Resolve Variables

  # Root directory
  # ${Rootdir}/../.. == dt-testing-framework/
  ${ROOTDIR} =        Unscramble Path  ${CURDIR}/../..
  Set Suite Variable  ${ROOTDIR}

  # SSH information
  ${SSH_KEY} =        Replace Rootdir  ${SSH_KEY}
  Set Suite Variable  ${SSH_KEY}

  Log End Message


Replace Rootdir
  [Arguments]  ${variable}
  ${replaced} =  Replace String  ${variable}  _ROOTDIR  ${ROOTDIR}
  [Return]       ${replaced}


Unscramble Path
  [Arguments]  ${path}
  ${unscrambled_path}  ${rc} =  Run Command  pushd ${path} &> /dev/null; pwd; popd &> /dev/null
  [Return]                      ${unscrambled_path}


Sanity Checks
  Log Start Message                       Sanity Checks
  OperatingSystem.File Should Exist       ${SSH_KEY}
  Log End Message


Run Command
  [Arguments]  ${command}
  ${rc}  ${output} =  Run And Return Rc And Output  bash -c '${command}'
  Check Rc            ${command}  ${rc}  ${output}
  [Return]            ${output}  ${rc}


Run Command On Remote Host
  [Arguments]  ${command}  ${host}
  Switch Connection              ${host}
  ${stdout}  ${stderr}  ${rc} =  SSHLibrary.Execute Command  bash -c '${command}'  return_stdout=True  return_stderr=True  return_rc=True
  Check Rc                       ${command}  ${rc}  ${stdout} ${stderr}
  Should Be Empty                ${stderr}
  [Return]                       ${stdout}  ${rc}


Run Command Ignore Errors
  [Arguments]  ${command}
  ${rc}  ${output} =  Run And Return Rc And Output  bash -c '${command}'
  [Return]            ${output}  ${rc}


Run Command Ignore Errors On Remote Host
  [Arguments]  ${command}  ${host}
  Switch Connection              ${host}
  ${stdout}  ${stderr}  ${rc} =  SSHLibrary.Execute Command  bash -c '${command}'  return_stdout=True  return_stderr=True  return_rc=True
  [Return]                       ${stdout}  ${rc}


Check Rc
  [Arguments]  ${command}  ${rc}  ${command_output}
  Should Be Equal As Integers  ${rc}  0  msg=${command} exited with code ${rc}.\n\Reason:\n${command_output}\n


List To CSV String
  [Arguments]  @{list}
  ${string} =     Catenate  ${EMPTY}
  :FOR  ${element}  IN  @{list}
  \  ${string} =  Catenate  ${string}${element},
  ${string} =     Get Substring  ${string}  0  -1
  [Return]        ${string}


List To Colon Separated String
  [Arguments]  @{list}
  ${string} =     Catenate  ${EMPTY}
  :FOR  ${element}  IN  @{list}
  \  ${string} =  Catenate  ${string}${element}:
  ${string} =     Get Substring  ${string}  0  -1
  [Return]        ${string}


Jq
  [Arguments]  ${command}  ${file}
  Run Command  tmp=$(mktemp) && ${command} < ${file} > \${tmp} && mv \${tmp} ${file}


Do Nothing
    Run Command  true
