*** Settings ***
Library         SeleniumLibrary
Library         OperatingSystem
Library         DateTime
Library         String
Library         Collections
Library         RequestsLibrary
Library         BuiltIn
Resource        ../../../resources/keywords/optimized_po/common_wrapper.robot
Variables       ../../../resources/data/config_reader.py
Resource        ../../../resources/keywords/optimized_po/base.robot

*** Variables ***
${BROWSER}            chrome         # Default browser (Options: chrome, firefox, edge, opera, safari)
${MODE}               normal         # Default mode (Options: normal, incognito/private)
${START_URL}          about:blank    # Default opening URL for browsers.

*** Keywords ***
Login To User Application
    [Documentation]    Launch the browser and log in to the user application.
    Launch Browser
    Login To Application

Launch Browser
    [Documentation]    Launches the browser  in the specified mode (normal or incognito/private) and maximizes the window.
    ${browser}=    Call Method    ${ObjConfigReader}    get_browser
    ${mode}=    Call Method    ${ObjConfigReader}    get_browser_mode
    ${start_url}=    Call Method    ${ObjConfigReader}    get_start_url
#    Open Browser   ${start_url}    ${browser}    options=${mode}

    # Use default variables if no arguments are provided.
    ${browser}    Set Variable If    '${browser}'    == ''  or  ${browser} is None    ${BROWSER}     ${browser}   
    ${mode}    Set Variable If    '${mode}'    == ''  or  ${mode} is None    ${MODE}     ${mode}
    Log To Console    Launching browser: ${browser} in ${mode} mode.
       
    # Prepare browser options.
    ${options}    Configure Browser Options    ${browser}    ${mode}
    
    # Open the browser based on the provided arguments.
    Run Keyword If    '${browser.lower()}' in ['chrome', 'firefox', 'edge', 'opera', 'safari']
    ...    Open Browser    ${start_url}    ${browser.lower()}    options=${options}
    ...    ELSE    Fail    Browser ${browser} is not supported.
    Maximize Browser Window

Login To Application
    [Documentation]
    [Teardown]    Close All Browsers
    Set Selenium Timeout    20 seconds
    Set Selenium Implicit Wait    20 seconds
    Log TO Console    Running The Application...
    ${base_url}    Call Method    ${ObjConfigReader}    base_url
    ${login_url}    Call Method    ${ObjConfigReader}    login_url
    Go To    ${login_url}
    Sleep    5 seconds
#    Zoom Out The Page    # Optional
    Sleep    3 seconds
    Capture The Screen    Login_Page
    Verify The Title Of Login Page
    ${username}    Call Method    ${ObjConfigReader}    user_name
    ${password}    Call Method    ${ObjConfigReader}    password
