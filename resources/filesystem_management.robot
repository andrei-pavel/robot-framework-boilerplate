*** Keywords ***
# private:
Sed Replace In File
  [Arguments]  ${replace_what}  ${replace_with}  ${file}
  Log Start Message  Sed Replace In File ${replace_what} ${replace_with} ${file}
  Run Command        sed --in-place 's+${replace_what}+${replace_with}+g' ${file}
  Log End Message


Remove File
  [Arguments]  ${file}
  Run Command  rm --force ${file}


Remove File On Remote Host
  [Arguments]  ${file}  ${host}
  Run Command On Remote Host  rm --force ${file}  ${host}


Remove All In Directory
  [Arguments]  ${directory}
  Run Command                  rm --recursive --force ${directory}/*
  ${file_count} =              Count Files In Directory  ${directory}
  Should Be Equal As Integers  ${file_count}  0


Remove All In Directory On Remote Host
  [Arguments]  ${directory}  ${host}
  Run Command On Remote Host   rm --recursive --force ${directory}/*  ${host}
  ${file_count} =              Count Files In Directory On Remote Host  ${directory}  ${host}
  Should Be Equal As Integers  ${file_count}  0


Count Files
  [Arguments]  ${directory}
  Run Command             mkdir --parents ${directory}
  ${file_count}  ${rc} =  Run Command  find ${directory} -mindepth 1 | wc --lines
  [Return]                ${file_count}


Count Files In Directory On Remote Host
  [Arguments]  ${directory}  ${host}
  Run Command On Remote Host   mkdir --parents ${directory}  ${host}
  ${file_count}  ${rc} =       Run Command On Remote Host  find ${directory} -mindepth 1 | wc --lines  ${host}
  [Return]                     ${file_count}


Truncate All Logs
  Log Start Message                Truncate All Logs
  Log End Message


Truncate Syslog
  Truncate File  ${SYSLOG_FILE}


Truncate Syslog On Remote Hosts
  [Arguments]  @{hosts}
  Truncate File On Remote Hosts  ${SYSLOG_FILE}  @{hosts}


Truncate File
  [Arguments]  ${file}
  Run Command  truncate --size=0 ${file}


Truncate File On Remote Hosts
  [Arguments]  ${file}  @{hosts}
  :FOR  ${host}  IN  @{hosts}
  \  Run Command On Remote Host  truncate --size=0 ${file}  ${host}


File Should Exist On Remote Host
   [Arguments]  ${host}  ${path}
   Switch Connection  ${host}
   ${output} =        SSHLibrary.File Should Exist  ${path}


File Should Not Exist On Remote Host
   [Arguments]  ${host}  ${path}
   Switch Connection  ${host}
   ${output} =        SSHLibrary.File Should Not Exist  ${path}


Directory Should Exist On Remote Host
   [Arguments]  ${host}  ${path}
   Switch Connection  ${host}
   ${output} =        SSHLibrary.Directory Should Exist  ${path}


Directory Should Not Exist On Remote Host
   [Arguments]  ${host}  ${path}
   Switch Connection  ${host}
   ${output} =        SSHLibrary.Directory Should Not Exist  ${path}


Copy File To Remote Host
   [Arguments]  ${host}  ${source}  ${destination}  ${mode}
   Switch Connection  ${host}
   ${output} =        SSHLibrary.Put File  ${source}  ${destination}  ${mode}


Copy Directory To Remote Host
   [Arguments]  ${host}  ${source}  ${destination}
   Switch Connection  ${host}
   ${output} =        SSHLibrary.Put Directory  ${source}  ${destination}  recursive=True


Copy File From Remote Host
  [Arguments]  ${host}  ${source}  ${destination}
  Switch Connection  ${host}
  ${output} =        SSHLibrary.Get File  ${source}  ${destination}


Copy Directory From Remote Host
  [Arguments]  ${host}  ${source}  ${destination}
  Switch Connection  ${host}
  ${output} =        SSHLibrary.Get Directory  ${source}  ${destination}
