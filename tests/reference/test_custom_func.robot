*** Test Cases ***
Test Custom Python Functions
    ${timestamp}    Get Current Timestamp
    Log    Current timestamp: ${timestamp}

    ${json_dict}    Convert JSON To Dict    {"name": "John", "age": 30}
    Log    Converted JSON: ${json_dict}

    ${response}    Make Get Request    https://api.example.com/data
    Log    API Response: ${response}

    ${write_result}    Write To File    test_file.txt    This is a test message.
    Log    ${write_result}

    ${file_exists}    Check If File Exists    test_file.txt
    Log    File Exists: ${file_exists}

    ${file_content}    Read From File    test_file.txt
    Log    File Content: ${file_content}
