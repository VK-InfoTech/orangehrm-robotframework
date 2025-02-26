@ECHO OFF

REM Activate required Python v-environment for test execution
REM Uncomment next line and adjust NAME if you use "virtualenv"
REM and "virtualenvwrapper-win" 
REM call workon NAME_OF_YOUR_VIRTUALENV

REM Clean up Results folder before you start!
REM /Q options ensures that no confirmation by user is required
REM Uncomment next line if you use a "Results" folder
REM del /Q Results\*
set hh=%time:~-11,2%
 set /a hh=%hh%+100
 set hh=%hh:~1%
 Set mydir=%date:~10,4%-%date:~4,2%-%date:~7,2%-%hh%-%time:~3,2%-%time:~6,2%
SET REL_PATH=..\TestScripts\POS_Laundry
ECHO _
ECHO First test iteration
REM This will run every test case which robot can find in "TESTS" folder
REM NOTE: If you have your test in a single .robot file (or .txt or whatever)
REM       then replace "TESTS" at the end of this block by your target file.
REM NOTE: The "^" at the end of each line (except the last in the block) is required
REM       because the command is broken down in multiple lines
call pabot  --processes 22                ^
			--log log_1.html                ^
            --report NONE                   ^
            --output output_1.xml           ^
            --outputdir POS_Laundry%mydir%             ^
            --loglevel TRACE                ^
            --removekeywords WUKS           ^
            --variable SELENIUM_SPEED:0.01s ^
            --variable SELENIUM_TIMEOUT:3s  ^
            --variable PORTAL:test          ^
			--reporttitle POS_Laundry        ^
            --i Sanity                      ^
            %REL_PATH%

ECHO _
ECHO Second test iteration
REM Rerun only the failed test cases from first iteration
call pabot  --processes 22                ^
			--rerunfailed POS_Laundry%mydir%\output_1.xml ^
            --runemptysuite                    ^
            --log log_2.html                   ^
            --report NONE                      ^
            --output output_2.xml              ^
            --outputdir POS_Laundry%mydir%                ^
            --loglevel TRACE                   ^
            --removekeywords WUKS              ^
            --variable SELENIUM_SPEED:0.03s    ^
            --variable SELENIUM_TIMEOUT:6s     ^
            --variable PORTAL:test             ^
			--reporttitle POS_Laundry           ^
            --i Sanity                         ^
            %REL_PATH%


ECHO _
ECHO FINAL POST PROCESSING
REM Merge test result from all iterations and generate a final Report & Log
call rebot  --processemptysuite        ^
            --log    FINAL_LOG.html    ^
            --report FINAL_REPORT.html ^
            --output FINAL_OUTPUT.xml  ^
            --outputdir POS_Laundry%mydir%       ^
            --merge                    ^
            POS_Laundry%mydir%\*.xml

REM Clea up Results1 folder before you go!
del /Q POS_Laundry%mydir%\output_*.xml