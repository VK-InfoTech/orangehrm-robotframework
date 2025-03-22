*** Settings ***
Library         SeleniumLibrary
Library         OperatingSystem
Library         DateTime
Library         String
Library         Collections
Library         RequestsLibrary
Resource        ../../../resources/keywords/optimized_po/base.robot

*** Keywords ***
Verify The Title Of Login Page
    [Documentation]
    Title Should Be