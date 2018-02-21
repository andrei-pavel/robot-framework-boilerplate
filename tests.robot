*** Settings ***
Documentation  Robot Framework boilerplate

Library  Collections
Library  OperatingSystem
Library  SSHLibrary
Library  String

Resource  resources/filesystem_management.robot
Resource  resources/general.robot
Resource  resources/host_management.robot
Resource  resources/logging.robot
Resource  resources/process_management.robot
Resource  resources/service_management.robot
Resource  resources/ssh_connectivity.robot

Variables  ./environment.yaml

Suite Setup     Suite Setup
Suite Teardown  Suite Teardown


*** Test Cases ***
Test-Case-1-Testing-Framework-Works
    Start Up
    Wrap Up


Test-Case-2-Remote-Hosts-Are-Linux-Distributions
    Start Up
    :FOR  ${host}  IN  @{HOST_LIST}
    \  ${output} =                 Run Command On Remote Host  cat /proc/version | cut -d ' ' -f 1  ${host}
    \  Should Be Equal As Strings  ${output}  Linux
    Wrap Up

