*** Settings ***
Library           SSHLibrary
Suite Setup       Open SSH Session
Suite Teardown    Close All Connections

*** Variables ***
${HOST}       127.0.0.1
${PORT}       2222
${USERNAME}   tester
${KEYFILE}    ${CURDIR}/keys/robot_test

*** Keywords ***
Open SSH Session
    Open Connection    ${HOST}    port=${PORT}
    Login With Public Key    ${USERNAME}    ${KEYFILE}

*** Test Cases ***
Normal Temperature Returns Normal Status
    ${result}=    Execute Command
    ...    /usr/local/bin/sensor_app 25
    ...    return_stderr=True
    ...    return_rc=True
    Should Be Equal    ${result}[0]    STATUS: NORMAL
    Should Be Equal As Integers    ${result}[2]    0

High Temperature Returns Warning
    ${result}=    Execute Command
    ...    /usr/local/bin/sensor_app 85
    ...    return_stderr=True
    ...    return_rc=True
    Should Be Equal    ${result}[0]    WARNING: HIGH_TEMPERATURE
    Should Be Equal As Integers    ${result}[2]    0

Invalid Temperature Is Rejected
    ${result}=    Execute Command
    ...    /usr/local/bin/sensor_app abc
    ...    return_stderr=True
    ...    return_rc=True
    Should Contain    ${result}[1]    ERROR: invalid temperature
    Should Be Equal As Integers    ${result}[2]    2
