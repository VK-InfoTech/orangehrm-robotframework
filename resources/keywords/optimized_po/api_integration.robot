*** Settings ***
Library         RequestsLibrary
Library         SeleniumLibrary
Library         OperatingSystem
Library         DateTime
Library         BuiltIn
Library         String
Library         json
Variables       ../../../resources/libraries/config_manager.py
Variables       ../../../resources/libraries/database_manager.py
Variables       ../../../resources/libraries/excel_manager.py
Variables       ../../../resources/libraries/utility_functions.py
Resource        ../../../resources/keywords/optimized_po/base.robot
Resource        ../../../resources/keywords/optimized_po/config_parser_keywords.robot
Resource        ../../../resources/keywords/optimized_po/landing_page.robot

*** Keywords ***
Execution start time stage
    [Documentation]    Inserts the start time of execution to the database.
    ${startTime}=   call method    ${db_manager}   insert_start_time
    Log    Execution started at: ${startTime}

Execution end time
    [Documentation]    Updates and logs the end time of execution in the database.
    ${endTime}=   call method    ${db_manager}   update_end_time
    Log    Execution ended at: ${endTime}

Generate Random Email ID
    [Documentation]    Generates a random email using UtilityFunctions class.
    ${email}=   call method    ${utilities_manager}   generate_random_email
    Log    Generated email: ${email}

Save the new user login credential
    [Arguments]    ${username}    ${password}    ${business_name}
    [Documentation]    Saves a new user credential in the Excel file and returns a success message.
    ${response}=   call method    ${excel_manager}   save_user_data    ${username}    ${password}    ${business_name}
    Log    Saving credentials: ${response}

Zoom In the Page
    [Documentation]    Zooms in the screen using a keyboard shortcut.
    ${response}=   call method    ${utilities_manager}   zoom_in
    Log To Console    Zoomed in successfully.

Zoom Out the Page
    [Documentation]    Zooms out the screen using a keyboard shortcut.
    ${response}=   call method    ${utilities_manager}   zoom_out
    Log To Console    Zoomed out successfully.

Generate random string with special character
    [Documentation]    Generates a random string including special characters.
    ${response}=   call method    ${utilities_manager}   generate_secure_password
    Log To Console    Generated String with Special Characters: ${response}
    RETURN    ${response}