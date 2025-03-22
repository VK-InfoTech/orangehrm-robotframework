*** Settings ***
Library         SeleniumLibrary
Library         OperatingSystem
Library         DateTime
Library         String
Library         Collections
Library         RequestsLibrary
Library         BuiltIn
Variables       ../../../resources/data/config_parser.py
Variables       ../../../resources/data/config_reader.py
Variables       ../../../resources/libraries/config_manager.py
Variables       ../../../resources/libraries/database_manager.py
Variables       ../../../resources/libraries/excel_manager.py
Variables       ../../../resources/libraries/utility_functions.py
Variables       ../../../resources/data/api_helper.py
Resource        ../../../resources/keywords/optimized_po/base.robot
#Resource        ../../../resources/keywords/optimized_po/config_parser_keywords.robot
#Resource        ../../../resources/keywords/optimized_po/api_integration.robot
#Resource        ../../../resources/keywords/optimized_po/landing_page.robot

*** Variables ***
${short_timeout}=   5 seconds
${timeout} =    10.0s
${long_timeout}=    90.0s

*** Keywords ***
Initialize Configuration Parameters
    [Documentation]    
    Set Root Directory
    Parse Locators
    Parse Test Data
    ${environment}    Call Method    ${ObjConfigReader}    environment
    Run Keyword If    '${environment}' == 'WEB'    Run Keywords    
    ...    Config Reader For Login User
    ...    End URL API Call
    ...    User Login API Call
    
Log Report
    [Documentation]    
    Log To Console    Start Running...

To Reload The Current Page
    [Documentation]    
    Reload Page
    Sleep    ${timeout}

Wait Until Spinner Wheel Disappears
    [Documentation]    
    Wait Until Page Does Not Contain Element    //div[@class='spinner-border text-primary']    3m

Scroll To Element with Axis By Using JavaScript
    [Documentation]    
    [Arguments]    ${locator}
    ${x_axis}    Get Horizontal Position    ${locator}
    ${y_axis}    Get Vertical Position    ${locator}
    Execute Javascript    window.scrollTo(${x_axis}, ${y_axis})

Scroll To Element
    [Documentation]    
    [Arguments]    ${locator}
    Scroll Element Into View    ${locator}
    Sleep    2s
    Wait Until Element Is Visible    ${locator}
            
Capture The Screen
    [Documentation]    
    [Arguments]    ${image_name}
    Sleep    1 second
    Capture Page Screenshot    ${image_name}.png
 
## Click Actions   
Click Element Until Visible
    [Documentation]  Wait until element is visible and then click element 
    [Arguments]    ${locator}
    Wait Until Element Is Visible    ${locator}
    Click Element    ${locator}
    Sleep    2s
    
Click Element Until Enabled
    [Documentation]  Wait until element is enabled and then click element
    [Arguments]    ${locator}
    Wait Until Element Is Enabled    ${locator}
    Click Element    ${locator}
    Sleep    2s
    
Click Element By Using JavaScript
    [Documentation]    
    [Arguments]    ${locator}
    # Escape " characters of Xpath
    ${locator}    Replace String    ${locator}    \"  \\\"
    Execute Javascript    document.evaluate("${locator}", document, null, XpathResult.ORDERED_NODE_SNAPSHOT_TYPE, null).snapshotItem(0).click();
    ## If the above lines are not working use the below commanded lines (Another Options)
#    Assign Id To Element    ${locator}    id=elementTest
#    Execute Javascript    document.getElementById('elementTest').click();
    Sleep    2s 
    
Click Element By Using JavaScript With Xpath
    [Documentation]    
    [Arguments]    ${locator}
    ${element}    Get Webelement    ${locator}
    Execute Javascript    arguments[0].click();    ARGUMENTS    ${element}
    
Click Element Using JavaScript With Element By ID
    [Documentation]    
    [Arguments]    ${element_by_id}
    Execute Javascript    document.getElementById("${element_by_id}").onclick()
    
Click Element DOM With Class Name
    [Documentation]    
    [Arguments]    ${locator}
    Click Element Until Visible    dom=document.getElementByClassName("${locator}")[0]
    
Click Element DOM With Text
    [Documentation]    
    [Arguments]    ${locator}
    Click Element Until Visible    dom=document.data:"${locator}"

Double Click The Web Element
    [Documentation]    
    [Arguments]    ${locator}
    Wait Until Element Is Visible    ${locator}    timeout=${timeout}
    Double Click Element    ${locator}
    Sleep    1s

Click The First Record From Filter
    [Documentation]    
    [Arguments]    ${search_input}
    Execute Javascript    $('td:contains(${search_input})').first().click()
    
## Checkbox Actions 
JS Clicking The Checkbox
    [Documentation]    
    [Arguments]    ${checkbox_locator}    ${previous_statusOf_checkbox}
    Click Element By Using JavaScript    ${checkbox_locator}
    Assign Id To Element    ${checkbox_locator}    id=CheckboxSelect
    ${new_statusOf_checkbox}    Execute Javascript    return document.getElementById('CheckboxSelect').checked;
    Log    checkbox status: ${new_statusOf_checkbox}
    Should Not Be Equal    ${new_statusOf_checkbox}    ${previous_statusOf_checkbox}
    Capture The Screen    Checkbox_Checked

Page Should Contain The Checkbox Element
    [Documentation]    
    [Arguments]    ${checkbox_locator}
#    Wait Until Element Is Visible    ${checkbox_locator}
    Sleep    2s
    Page Should Contain Checkbox    ${checkbox_locator}

Checkbox Element Should not Selected
    [Documentation]    
    [Arguments]    ${checkbox_locator}
#    Assign Id To Element    ${checkbox_locator}    id=checkbox_not_selected
#    ${checkbox_status}    Execute Javascript    return document.getElementById('checkbox_not_selected').checked;
#    Log    Checkbox Status: ${checkbox_status}
#    Should Not Be True    ${checkbox_status}
    ## If the below line is not working use the above commanded lines (Another Options)
    Checkbox Should Not Be Selected    ${checkbox_locator}

Checkbox Element Should Selected
    [Documentation]    
    [Arguments]    ${checkbox_locator}
#    Assign Id To Element    ${checkbox_locator}    id=checkbox_selected
#    ${checkbox_status}    Execute Javascript    return document.getElementById('checkbox_selected').checked;
#    Log    Checkbox Status: ${checkbox_status}
#    Should Be True    ${checkbox_status}
    ## If the below line is not working use the above commanded lines (Another Options)
    Checkbox Should Be Selected    ${checkbox_locator}
    
Select The Checkbox Element
    [Documentation]    
    [Arguments]    ${checkbox_by_id}
    Wait Until Element Is Visible    ${checkbox_by_id}
    Select Checkbox    ${checkbox_by_id}
    ## If the above lines are not working use the below commanded lines (Another Options)
#    Assign Id To Element    ${checkbox_by_id}    id=checkbox_selecting
#    ${checkbox_status}    Execute Javascript    return document.getElementById('checkbox_selecting').checked;
#    Log    Checkbox Status: ${checkbox_status}
#    Run Keyword If    '${checkbox_status}' == 'False'    JS Clicking The Checkbox    ${checkbox_by_id}    ${checkbox_status}

Unselect The Checkbox Element
    [Documentation]
    [Arguments]    ${checkbox_by_id}
    Wait Until Element Is Visible    ${checkbox_by_id}
    Unselect Checkbox    ${checkbox_by_id}
    ## If the above lines are not working use the below commanded lines (Another Options)
#    Assign Id To Element    ${checkbox_by_id}    id=checkbox_unselecting
#    ${checkbox_status}    Execute Javascript    return document.getElementById('checkbox_unselecting').checked;
#    Log    Checkbox Status: ${checkbox_status}
#    Run Keyword If    '${checkbox_status}' == 'True'    JS Clicking The Checkbox    ${checkbox_by_id}    ${checkbox_status}

Get Checkbox
    [Documentation]    
    [Arguments]    ${checkbox_locator}
    ${value}    Run Keyword And Return Status    Checkbox Element Should Selected    ${checkbox_locator}
    RETURN    ${value}
    
Set Checkbox
    [Documentation]    
    [Arguments]    ${checkbox_locator}    ${visible_locator}    ${value}
    ${actual_value}    Get Checkbox    ${checkbox_locator}
    Run Keyword Unless    '${actual_value}' == '${value}'    Click Element    ${visible_locator}
    Log    Original: ${actual_value}, Set To:${value}

## Textbox Actions 
Enter The Value Until Visible
    [Documentation]    
    [Arguments]    ${locator}    ${value}
    Wait Until Element Is Visible    ${locator}
    Input Text    ${locator}    ${value}
    
Enter Multiple Value In The Input Fields
    [Documentation]    
    [Arguments]    ${locators}    ${values}
    ${countOf_text_box}    Get Length    ${locators}
    FOR    ${i}    IN RANGE    0    ${countOf_text_box}
        Enter The Value Until Visible    ${locators}[${i}]    ${values}[${i}]
        Capture The Screen    Entered_Value_${i}
    END     

Edit Multiple Input Fields Values
    [Documentation]    
    [Arguments]    ${locators}    ${values}
    ${countOf_text_box}    Get Length    ${locators}
    FOR    ${i}    IN RANGE    0    ${countOf_text_box}
        Press Keys    ${locators}[${i}]    CTRL+a+BACKSPACE
        Enter The Value Until Visible    ${locators}[${i}]    ${values}[${i}]
        Capture The Screen    Entered_Value_${i}
    END     

Entered Value Should Be Equal
    [Documentation]    
    [Arguments]    ${locator}    ${expected_value}
    ${actual_value}    Get Element Attribute    ${locator}    value    
    Should Be Equal    ${expected_value}    ${actual_value}
    
Check All Elements Of Attribute Value Of Text Fields
    [Documentation]    
    [Arguments]    ${countOf_text_boxes}    ${locators}    ${values}
    FOR    ${i}    IN RANGE    1    ${countOf_text_boxes}
        Entered Value Should Be Equal    ${locators}[${i}]    ${values}[${i}]
    END
    
Get Text By ID
    [Documentation]
    [Arguments]    ${element_by_id}
    ${value}    Execute Javascript    return $("#${element_by_id}").val()
    RETURN    ${value}    
    
Modify Input Text
    [Documentation]    
    [Arguments]    ${locator}    ${expected_value}
    ${actual_value}    Get Text By ID    ${locator}
    Log    Actual Value: ${actual_value}, Set To: ${expected_value}
    Run Keyword Unless    '${actual_value}' == '${expected_value}'   Enter The Value Until Visible    ${locator}    ${expected_value}
    
Input Text By ID Should be Equal
    [Documentation]    
    [Arguments]    ${element_by_id}    ${expected_text}
    ${actual_text}    Get Text By ID    ${element_by_id}
    Should Be Equal    ${expected_text}    ${actual_text}

## Page Should Keywords 
Page Should Contain The Item
    [Documentation]    
    [Arguments]    ${item}
    Sleep    2s
    Page Should Contain    ${item}
    Capture The Screen    Contain_Item
    
Page Should Not Contain The Item
    [Documentation]    
    [Arguments]    ${item}
    Sleep    2s
    Page Should Not Contain    ${item}
    Capture The Screen    Not_Contain_Item

Page Should Contain Multiple Element
    [Documentation]    
    [Arguments]    @{locators}
    FOR    ${locator}    IN    @{locators}
        Page Should Contain Element    ${locator}
    END
    
Page Should Contain Multiple Text
    [Documentation]    
    [Arguments]    @{values}
    FOR    ${value}    IN    ${values}
        Wait Until Page Contains    ${value}    timeout=${timeout}
    END

Page Should Not Contain Multiple Text
    [Documentation]    
    [Arguments]    @{values}
    FOR    ${text}    IN    @{values}
        Page Should Not Contain    ${text}
        Capture The Screen    ${text}
    END   
        
Page Should Not Contain Multiple Element
    [Documentation]    
    [Arguments]    @{locators}
    FOR    ${locator}    IN    @{locators}
        Wait Until Page Does Not Contain Element    ${locator}    timeout=${timeout}
    END

Page Should Contain The Checkbox Element
    [Documentation]    
    [Arguments]    ${checkbox_locator}
#    Wait Until Element Is Visible    ${checkbox_locator}
    Sleep    3s
    Page Should Contain Checkbox    ${checkbox_locator}

Wait Until Page Contain Elements
    [Documentation]    
    [Arguments]    @{locators}
    FOR    ${locator}    IN    @{locators}
        Wait Until Page Contains Element    ${locator}    timeout=${timeout}
    END

Wait Until Page Contains Multiple Text
    [Documentation]    
    [Arguments]    @{values}
    FOR    ${value}    IN    @{values}
        Wait Until Page Contains    ${value}    timeout=${timeout}
    END
    
## Table    
Table Header should Multiple Text
    [Documentation]    
    [Arguments]    ${locator}    ${values}
    FOR    ${value}    IN    ${values}
        Table Header Should Contain    ${locator}    ${value}
    END

Handle Table Data Without API Call
    [Documentation]    
    [Arguments]    ${row_locator}    ${column_locator}
    @{table_list}    Create List    
    ${columns_count}    Get Element Count    ${column_locator}
    FOR    ${column}    IN RANGE    1    ${columns_count}
        ${table_data}    Get Text    xpath=//tbody//tr[${row_locator}]//td[${column}]
        Append To List    ${table_list}    ${table_data}
    END
    RETURN    ${table_list}
    
Get Table Data Without API Call
    [Documentation]    
    [Arguments]    ${row_locator}    ${column_locator}
    ${table_list}    Create List    
    ${columns_count}    Get Element Count    ${row_locator}
    FOR    ${row}    IN RANGE    1    ${columns_count}
        ${table_data}    Handle Table Data Without API Call    ${row}    ${column_locator}
        Append To List    ${table_list}    ${table_data}
    END
    RETURN    ${table_data}

Handle Table Data Without API Data With Last Column
    [Documentation]    
    [Arguments]    ${row_locator}    ${column_locator}
    @{table_list}    Create List    
    ${columns_count}    Get Element Count    ${column_locator}
    FOR    ${column}    IN RANGE    1    ${columns_count}+1
        ${table_data}    Get Text    xpath=//tbody//tr[${row_locator}]//td[${column}]
        Append To List    ${table_list}    ${table_data}
        ${row_data}    Evaluate    ${row_locator}-${1}
        ${column_data}    Evaluate    ${column}-${1}
    END
    RETURN    ${table_list}

Get Table Data Without API Call Data With Last Column
    [Documentation]    
    [Arguments]    ${row_locator}    ${column_locator}
    @{table_list}    Create List    
    ${columns_count}    Get Element Count    ${row_locator}
    FOR    ${row}    IN RANGE    1    ${columns_count}
        ${table_data}    Handle Table Data Without API Data With Last Column    ${row}    ${column_locator}
        Append To List    ${table_list}    ${table_data}
    END
    RETURN    ${table_list}

Handle Table Data
    [Documentation]
    [Arguments]    ${row_locator}    ${column_locator}    ${response_table_data}
    @{table_list}    Create List    
    ${columns_count}    Get Element Count    ${column_locator}
    FOR    ${column}    IN RANGE    1    ${columns_count}
        ${table_data}    Get Text    xpath=//tbody//tr[${row_locator}]//td[${column}]
        Append To List    ${table_list}    ${table_data}
        ${row_data}    Evaluate    ${row_locator}-${1}
        ${column_data}    Evaluate    ${column}-${1}
#        ${convert_data}    Convert To String    ${response_table_data}[1][${row_data}] [${column_data}]
#        Should Contain    ${convert_data}    ${table_data}
        Log    ${table_data}
    END
    RETURN    ${table_list}

Get The Full Table Data
    [Documentation]    
    [Arguments]    ${row_locator}    ${column_locator}    ${api_helper_object}    ${method_name}
    @{table_list}    Create List    
    ${response}    Call Method    ${api_helper_object}    ${method_name}
    ${columns_count}    Get Element Count    ${row_locator}
    FOR    ${row}    IN RANGE    1    ${columns_count}+1
        ${table_data}    Handle Table Data    ${row}    ${column_locator}    ${response}
        Append To List    ${table_list}    ${table_data}
    END
    RETURN    ${table_data}

Get Table Data Without Last Column
    [Documentation]    
    [Arguments]    ${row_locator}    ${column_locator}    ${method_name}
    @{table_list}    Create List
#    ${response}    Call Method    ${api_helper_call}    ${method_name}
    ${columns_count}    Get Element Count    ${row_locator}
    FOR    ${row}    IN RANGE    1    ${columns_count}+1
        ${table_data}    Handle Table Data    ${row}    ${column_locator}    ${method_name}
        Append To List    ${table_list}    ${table_data}
    END
    RETURN    ${table_list}
    
Get Table Row Index By Text
    [Documentation]    
    [Arguments]    ${table_css_locator}    ${text}
    #    Wait for table loading
    Sleep    2s
    ${row_index}    Execute Javascript    return ${table_css_locator}.find("td:contains(${text})").parent("tr").index()
    RETURN    ${row_index}

Table Row Should Contain Element
    [Documentation]    
    [Arguments]    ${table_css_locator}    ${row}    ${element_css}
    ${locator}    Set Variable    dom:${table_css_locator}.find('tr').eq(${row}).find('${element_css}')
    Wait Until Element Is Visible    ${locator}
    RETURN    ${locator}
    
Get Column Index By Table Header
    [Documentation]    
    [Arguments]    ${table_css_locator}    ${th}
    ${column_index}    Execute Javascript    return ${table_css_locator}.find("th:contains(${th})").index()
    RETURN    ${column_index}
    
Get Table Cell By JQuery
    [Documentation]    
    [Arguments]    ${table_css_locator}    ${row}    ${column}
    ${value}    Execute Javascript    return ${table_css_locator}.find("tr:not(:has(th))").eq(${row}).find("td").eq(${column}).text()
    RETURN    ${value}

Handle Table Drill Down
    [Documentation]    
    [Arguments]    ${row_locator}    ${test_response_retention_table_data}    ${column_locator}    ${table_ID}
    ${columns_count}    Get Element Count    ${column_locator}
    FOR    ${column}    IN RANGE    1    ${columns_count}
        ${table_data}    Get Text    //*[@id='${table_ID}']//tbody//tr[${row_locator}]//td[${column}]
        ${row_data}    Evaluate    ${row_locator}-${1}
        ${column_data}    Evaluate    ${column}-${1}
        ${convert_data}    Convert To String    ${test_response_retention_table_data}[1][${row_data}] [${column_data}]
        Should Contain    ${convert_data}    ${table_data}
    END
        
Table Data Validation With Drill Down Data
    [Documentation]    
    [Arguments]    ${row_locator}    ${column_locator}    ${method_name}    ${table_ID}
    ${response}    Call Method    ${api_helper_call}    ${method_name}
    Sleep    ${short_timeout}
    ${rows_count}    Get Element Count    ${row_locator}
    ${sum}    Set Variable    ${0}
    FOR    ${row}    IN RANGE    1    ${rows_count}
        Handle Table Drill Down    ${row}    ${response}    ${column_locator}    ${table_ID}
    END

Table Data Validation With Drill Down Data Limit
    [Documentation]
    [Arguments]    ${row_locator}    ${column_locator}    ${method_name}    ${table_ID}
    ${response}    Call Method    ${api_helper_call}    ${method_name}
    Sleep    ${short_timeout}
    ${rows_count}    Get Element Count    ${row_locator}
    Run Keyword If    ${rows_count} > 10    Validate Data When Greater Than 10    ${response}    ${column_locator}    ${table_ID}    ${rows_count}
    ...    ELSE    Validate Data When Less Than 10    ${response}    ${column_locator}    ${table_ID}    ${rows_count}
    ${sum}    Set Variable    ${0}
    FOR    ${row}    IN RANGE    1    ${rows_count}
        Handle Table Drill Down Limit    ${row_locator}    ${response}    ${column_locator}    ${table_ID}
    END

Validate Data When Greater Than 10
    [Documentation]    
    [Arguments]    ${response}    ${column_locator}    ${table_ID}    ${rows_count}
    ${sum}    Set Variable    ${0}
    FOR    ${row}    IN RANGE    1    ${rows_count}
        Handle Table Drill Down Limit    ${row}    ${response}    ${column_locator}    ${table_ID}
    END
    
Validate Data When Less Than 10
    [Documentation]    
    [Arguments]    ${response}    ${column_locator}    ${table_ID}    ${rows_count}
    ${sum}    Set Variable    ${0}
    FOR    ${row}    IN RANGE    1    ${rows_count}
        Handle Table Drill Down Limit    ${row}    ${response}    ${column_locator}    ${table_ID}
    END

Handle Table Drill Down Limit
    [Documentation]    
    [Arguments]    ${row_locator}    ${test_response_retention_table_data}    ${column_locator}    ${table_ID}
    ${columns_count}    Get Element Count    ${column_locator}
    FOR    ${column}    IN RANGE    1    ${columns_count}
        ${table_data}    Get Text    //*[@id='${table_ID}']//tbody//tr[${row_locator}]//td[${column}]
        ${row_data}    Evaluate    ${row_locator}-${1}
        ${column_data}    Evaluate    ${column}-${1}
        ${convert_data}    Convert To String    ${test_response_retention_table_data}[1][${row_data}] [${column_data}]
        Should Contain    ${convert_data}    ${table_data}
    END
    
Get Table Data From Row Using Table ID
    [Documentation]    
    [Arguments]    ${row_locator}    ${table_ID}
    @{table_list}    Create List    
    ${rows_count}    Get Element Count    ${row_locator}
    FOR    ${row}    IN RANGE    1    ${rows_count}
        ${table_data}    Get Text    xpath=${table_ID}//tbody//tr[${row}]
        Append To List    ${table_list}    ${table_data}
    END
        
Find The Data From The List
    [Documentation]    
    [Arguments]    ${data}
    Sleep    ${short_timeout}
    Execute Javascript    window.scrollTo(0,document.body.scrollHeight)
    Scroll To Element     ${locators_params['Settings']}[ShowEntries]
    ${countOf_text}    Get Text    ${locators_params['Settings']}[ShowEntries]
    Log    ${countOf_text}
    ${result}    Set Variable    False
    FOR    ${value}    IN RANGE    1    ${countOf_text}
        ${result}    Run Keyword And Return Status    Element Should Be Visible    //*[contains(text(),'${data}')]
        Run Keyword If    ${result}    Exit For Loop
        ...    ELSE    Click Element Until Visible    //*[@class='paginate_button next']
        Log    ${value}
    END
    RETURN    ${result}
    
Show All The Data From The Table
    [Documentation]    
    [Arguments]    ${option}    ${element_locator}    ${RowsPerPage_DDOption}    ${RowsPerPage_DDOptions}    ${RowsPerPage_DDArrow}    ${AllOption_RowsPerPage_DDValue}
    ${CancelBtn_Status}  run keyword and return status    Page Should Contain The Item    ${element_locator}
    run keyword if  ${CancelBtn_Status} == True  click element until visible  ${element_locator}
    Wait Until Element Is Visible    ${RowsPerPage_DDOptions}
    @{Options}  get webelements  ${RowsPerPage_DDOptions}
    ${Options_Count}  get element count  ${RowsPerPage_DDOptions}
    FOR  ${i}  IN RANGE  1  ${Options_Count}
        Wait Until Element Visible   ${RowsPerPage_DDArrow}
        sleep  3s
        ${Selected_Option}  format string   ${RowsPerPage_DDOption}   value=${option}
        Click Element Until Visible       ${RowsPerPage_DDArrow}
        Click Element Until Visible  ${Selected_Option}
        capture the screen  AllData
        ${All_OptionTxt}  get text  ${AllOption_RowsPerPage_DDValue}
        exit for loop if  '${All_OptionTxt}' == '${option}'
    END
    Capture The Screen    ShowAll_Data
    
Navigate To The Next Page Of The Table
    [Documentation]    
    [Arguments]    ${Pagination_NextButton}
    ${status}    Run Keyword And Return Status    Element Should Be Disabled    ${Pagination_NextButton}
    Run Keyword If    ${status} == True    Log    We Can't able to click the Pagination Next Button
    ...    ELSE    Run Keywords    Element Should Be Enabled    ${Pagination_NextButton}
    ...    AND    Click Element Until Visible    ${Pagination_NextButton}    