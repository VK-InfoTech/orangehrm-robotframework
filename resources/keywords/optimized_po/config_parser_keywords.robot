*** Settings ***
Documentation    Library for parsing the network topology information.
Library         String
Library         ../../../resources/data/config_parser.py
Variables       ../../../resources/data/config_reader.py
Resource        ../../../resources/keywords/optimized_po/base.robot

*** Variables ***
${LOCATORS_FILE}    ${CURDIR}/../../../resources/data/locators.yaml
${TEST_DATA_FILE}   ${CURDIR}/../../../resources/data/test_data.yaml
${ROOT_FOLDER}      orangehrm-robotframework

*** Test Cases ***
Parse Locators and Test Data
    [Documentation]    Parses locators and test data from YAML files.
    Set Root Directory
    Parse Locators
    Parse Test Data

Verify Locator and Data Parsing
    [Documentation]    Verifies if test data and locators are parsed successfully.
    Parse Locators
    Validate Parsed Data    ${locators_data}
    Parse Test Data
    Validate Parsed Data    ${test_data}

*** Keywords ***
Set Root Directory
    [Documentation]    Sets the root directory for the project dynamically.
    ${root_directory}=    Fetch From Left    ${CURDIR}    ${ROOT_FOLDER}
    ${root_folder_directory}=    Set Variable       ${root_directory}${/}${ROOT_FOLDER}
    Set Suite Variable    ${root_directory}  ${root_folder_directory}

Parse Locators
    [Documentation]    Parses locator information from the YAML file.
    Set Log Level    NONE
    ${locators_data}    Parse Yaml    ${root_directory}${/}resources${/}data${/}locators.yaml
    Set Log Level    INFO
    Set Suite Variable    ${locators_data}
    Log    Locators parsed: ${locators_data}

Parse Test Data
    [Documentation]    Parses test data configuration from the YAML file.
    Set Log Level    NONE
    ${test_data}    Parse Yaml    ${root_directory}${/}resources${/}data${/}test_data.yaml
    Set Log Level    INFO
    Set Suite Variable    ${test_data}
    Log    Test data parsed: ${test_data}

Validate Parsed Data
    [Arguments]    ${data}
    [Documentation]    Validates parsed data to ensure it is not empty or invalid.
    Run Keyword If    len(${data}) == 0    Fail    Parsed data is empty.
    Log    Parsed data is valid: ${data}
