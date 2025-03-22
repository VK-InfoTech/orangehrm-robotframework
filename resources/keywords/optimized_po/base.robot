*** Settings ***
Resource    ../../../resources/keywords/optimized_po/api_integration.robot
Resource    ../../../resources/keywords/optimized_po/common_wrapper.robot
Resource    ../../../resources/keywords/optimized_po/config_parser_keywords.robot
Resource    ../../../resources/keywords/optimized_po/landing_page.robot
Resource    ../../../resources/keywords/optimized_po/page_title_keywords.robot
Resource    ../../../resources/keywords/optimized_po/browser_script.robot

Variables       ../../../resources/data/config_parser.py
Variables       ../../../resources/data/config_reader.py
Variables       ../../../resources/libraries/config_manager.py
Variables       ../../../resources/libraries/database_manager.py
Variables       ../../../resources/libraries/excel_manager.py
Variables       ../../../resources/libraries/utility_functions.py
Variables       ../../../resources/data/api_helper.py