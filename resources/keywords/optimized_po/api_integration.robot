*** Settings ***
Library    RequestsLibrary

*** Keywords ***
Create Session
    [Arguments]    ${alias}    ${url}
    Create Session    ${alias}    ${url}

Get Request
    [Arguments]    ${alias}    ${endpoint}
    ${response}=    Get Request    ${alias}    ${endpoint}
    [Return]    ${response}