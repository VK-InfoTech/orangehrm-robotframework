*** Settings ***
Documentation    Browser Configurations
Library         String
Library         ../../../resources/data/config_parser.py
Variables       ../../../resources/data/config_reader.py
Resource        ../../../resources/keywords/optimized_po/base.robot

*** Keywords ***
Configure Browser Options
    [Documentation]    Configure browser options for incognito/private mode and return the options object.
    [Arguments]    ${browser}    ${mode}
    ${options}    Set Variable    None
    Run Keyword If    '${browser.lower()}' == 'chrome'       Configure Chrome Options    ${mode}
        ...               ELSE IF    '${browser.lower()}' == 'firefox'    Configure Firefox Options    ${mode}
        ...               ELSE IF    '${browser.lower()}' == 'edge'       Configure Edge Options    ${mode}
        ...               ELSE IF    '${browser.lower()}' == 'opera'      Configure Opera Options    ${mode}
        ...               ELSE IF    '${browser.lower()}' == 'safari'     Configure Safari Options    ${mode}
        [Return]           ${options}

Configure Chrome Options
    [Documentation]    Configure Chrome browser options for the specified mode.
    [Arguments]        ${mode}
    ${options}=        Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    modules=sys
    Run Keyword If    '${mode.lower()}' == 'incognito'    Call Method    ${options}    add_argument    --incognito
    [Return]           ${options}

Configure Firefox Options
    [Documentation]    Configure Firefox browser options for the specified mode.
    [Arguments]        ${mode}
    ${options}=        Evaluate    sys.modules['selenium.webdriver'].FirefoxOptions()    modules=sys
    Run Keyword If    '${mode.lower()}' == 'incognito' or '${mode.lower()}' == 'private'    Call Method    ${options}    add_argument    -private
    [Return]           ${options}

Configure Edge Options
    [Documentation]    Configure Edge browser options for the specified mode.
    [Arguments]        ${mode}
    ${options}=        Evaluate    sys.modules['selenium.webdriver'].EdgeOptions()    modules=sys
    Run Keyword If    '${mode.lower()}' == 'incognito' or '${mode.lower()}' == 'private'    Call Method    ${options}    add_argument    --inprivate
    [Return]           ${options}

Configure Opera Options
    [Documentation]    Configure Opera browser options for the specified mode.
    [Arguments]        ${mode}
    ${options}=        Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    modules=sys
    Run Keyword If    '${mode.lower()}' == 'incognito' or '${mode.lower()}' == 'private'    Call Method    ${options}    add_argument    --private
    [Return]           ${options}

Configure Safari Options
    [Documentation]    Safari does not support private mode via WebDriver. Returns no options.
    [Arguments]        ${mode}
    Run Keyword If    '${mode.lower()}' == 'private' or '${mode.lower()}' == 'incognito'    Log    Safari does not support Private mode. Launching in normal mode.
    [Return]           None
