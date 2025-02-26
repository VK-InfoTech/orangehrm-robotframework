*** Settings ***
Library    SeleniumLibrary

*** Keywords ***
Open Browser To Login Page
    Open Browser    http://example.com/login    chrome

Input Username
    [Arguments]    ${username}
    Input Text    id:username    ${username}

Input Password
    [Arguments]    ${password}
    Input Text    id:password    ${password}

Click Login Button
    Click Button    id:login-button

Page Should Contain
    [Arguments]    ${text}
    Page Should Contain    ${text}