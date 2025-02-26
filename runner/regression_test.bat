@ECHO OFF

REM --------------------------------------------------------------------------
REM Activate Python virtual environment for test execution (if required)
REM Uncomment the next line and adjust NAME_OF_YOUR_VIRTUALENV
REM call workon NAME_OF_YOUR_VIRTUALENV
REM --------------------------------------------------------------------------

REM --------------------------------------------------------------------------
REM Clean up Results folder before starting the tests (if required)
REM Uncomment the next line if you want to clean a "Results" folder
REM del /Q Results\*
REM --------------------------------------------------------------------------

REM Setup timestamp for folder naming
set hh=%time:~-11,2%
set /a hh=%hh%+100
set hh=%hh:~1%
Set mydir=%date:~10,4%-%date:~4,2%-%date:~7,2%-%hh%-%time:~3,2%-%time:~6,2%

REM Set relative path to TestScripts folder
SET REL_PATH=..\TestScripts

ECHO _
ECHO Starting Test Iteration 1
REM --------------------------------------------------------------------------
REM First iteration: Run all test cases found in the specified folder
REM Adjust %REL_PATH% or provide the full directory or file path as needed
REM NOTE: The "^" at the end of each line (except the last in the block) is required
REM       because the command is broken down in multiple lines
REM --------------------------------------------------------------------------
call pabot --processes 22                  ^
            --log log_1.html               ^
            --report NONE                  ^
            --output output_1.xml          ^
            --outputdir orangehrm-robotframework%mydir% ^
            --loglevel TRACE               ^
            --removekeywords WUKS          ^
            --variable SELENIUM_SPEED:0.01s ^
            --variable SELENIUM_TIMEOUT:3s ^
            --variable PORTAL:test         ^
            --reporttitle orangehrm-robotframework      ^
            --i Regression                 ^
            %REL_PATH%

ECHO _
ECHO Starting Test Iteration 2
REM --------------------------------------------------------------------------
REM Second iteration: Run only failed test cases from the first iteration
REM --------------------------------------------------------------------------
call pabot --processes 22                  ^
            --rerunfailed orangehrm-robotframework%mydir%\output_1.xml ^
            --runemptysuite                ^
            --log log_2.html               ^
            --report NONE                  ^
            --output output_2.xml          ^
            --outputdir orangehrm-robotframework%mydir% ^
            --loglevel TRACE               ^
            --removekeywords WUKS          ^
            --variable SELENIUM_SPEED:0.03s ^
            --variable SELENIUM_TIMEOUT:6s ^
            --variable PORTAL:test         ^
            --reporttitle orangehrm-robotframework      ^
            --i Regression                 ^
            %REL_PATH%

ECHO _
ECHO Performing Final Post-Processing
REM --------------------------------------------------------------------------
REM Merge results from all test iterations and generate final log and report
REM --------------------------------------------------------------------------
call rebot --processemptysuite            ^
            --log FINAL_LOG.html           ^
            --report FINAL_REPORT.html     ^
            --output FINAL_OUTPUT.xml      ^
            --outputdir orangehrm-robotframework%mydir% ^
            --merge                        ^
            orangehrm-robotframework%mydir%\*.xml

REM --------------------------------------------------------------------------
REM Optional: Clean up intermediate result files
REM --------------------------------------------------------------------------
del /Q orangehrm-robotframework%mydir%\output_*.xml

ECHO All tasks completed successfully!