*** Keywords ***
Login With Valid Credentials
    Input Text    ${USERNAME_FIELD}    ${VALID_USERNAME}
    Input Text    ${PASSWORD_FIELD}    ${VALID_PASSWORD}
    Click Button    ${LOGIN_BUTTON}

Verify Login Successful
    Page Should Contain    Welcome, ${VALID_USERNAME}

Login With Invalid Credentials
    Input Text    ${USERNAME_FIELD}    invalid_user
    Input Text    ${PASSWORD_FIELD}    invalid_password
    Click Button    ${LOGIN_BUTTON}

Verify Login Failed
    Page Should Contain    Login Failed

Log Message
    [Arguments]    ${message}
    Log    ${message}