import json
import os
import random
import string
import logging
from datetime import datetime
from configparser import ConfigParser
from typing import Optional
import pandas as pd
import mysql.connector
import pyautogui

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(levelname)s - %(message)s"
)


class ConfigManager:
    """Handles reading configuration settings from a config.ini file."""

    def __init__(self, config_path: str = "config.ini"):
        self.config_path = os.path.join(os.path.dirname(__file__), config_path)
        self.config = ConfigParser()
        if not os.path.exists(self.config_path):
            raise FileNotFoundError(f"Configuration file '{self.config_path}' not found!")
        self.config.read(self.config_path)
        self._load_config()

    def _load_config(self) -> None:
        """Loads configuration settings from the config.ini file."""
        try:
            self.db_username = self.config["database"]["mysql_user"]
            self.db_password = self.config["database"]["mysql_password"]
            self.db_host = self.config["database"]["sql_host"]
            self.db_name = self.config["database"]["name"]
            # self.db_stage = self.config["database"]["Mysql_DataBaseName_Stage"]
            # self.db_dev = self.config["database"]["Mysql_DataBaseName_Dev"]
            # self.db_prod = self.config["database"]["Mysql_DataBaseName_Prod"]
            self.env = self.config["environment"]["type"]
            self.application = self.config["application"]["name"]
            logging.info("Configuration loaded successfully!")

        except KeyError as e:
            logging.error(f"Missing configuration key: {e}")
            raise ValueError(f"Missing configuration key: {e}")


class DatabaseManger:
    """Handles datanbase operations like inserting and updating test run records."""

    def __init__(self, config: ConfigManager, config_manager=None):
        self.config = config_manager
        self.conn: Optional[mysql.connector.connection.MySQLConnection] = None
        self.cursor: Optional[mysql.connector.cursor.MySQLCursor] = None

    def connect(self) -> None:
        """Establishes a connection to the MySQL database."""
        try:
            self.conn = mysql.connector.connect(
                user=self.config.db_username,
                password=self.config.db_passowrd,
                host=self.config.db_host,
                database=self.config.db_name,
                port=3306
            )
            self.cursor = self.conn.cursor()
            logging.info("Database connected successfully.")
        except mysql.connector.Error as err:
            logging.error(f"Failed to connecting to the database: {err}")
            raise

    def close_connection(self) -> None:
        """Closes the database connection."""
        if self.cursor:
            self.cursor.close()
        if self.conn:
            self.conn.close()
            logging.info("Database connection closed.")

    def insert_start_time(self) -> None:
        """Inserts a new test run start record in the database."""
        try:
            if not self.conn:
                self.connect()
            sys_datatime = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
            sql = "INSERT INTO test_reports (name, start_time, run_status) VALUES (%s, %s, %s)"
            values = ("Test Run Start", sys_datatime, self.config.run_status_start)
            self.cursor.execute(sql, values)
            self.conn.commit()
            logging.info("Test run start record time inserted successfully.")
        except mysql.connector.Error as err:
            logging.error(f"Failed to insert test run start record: {err}")
        finally:
            self.close_connection()

    def update_end_time(self) -> None:
        """Updates the last test run record with the end time."""
        try:
            if not self.conn:
                self.connect()
            sys_datetime = datetime.now().strftime("%Y-%m-%d %H-%M-%S")
            self.cursor.execute("SELECT id FROM test_reports ORDER BY id DESC LIMIT 1")
            result = self.cursor.fetchone()

            if result:
                last_id = result[0]
                sql = "UPDATE test_reports SET end_date = %s, run_status = %s WHERE id = %s"
                values = (sys_datetime, self.config.run_status_end, last_id)
                self.cursor.execute(sql, values)
                self.conn.commit()
                logging.info("Test run end record time updated successfully.")
            else:
                logging.warning("No test report found to update.")
        except mysql.connector.Error as err:
            logging.error(f"Error updating end time: {err}")
        finally:
            self.close_connection()

    def json_to_dict(self, json_string):
        """
        Converts a JSON string into a Python dictionary.
        :param json_string: JSON formatted string
        :return: Python dictionary or error message if invalid
        """

        if not isinstance(json_string, str):
            logging.error("Input is not a valid JSON string")
            return {"error": "Input is not a valid JSON string"}

        try:
            data = json.loads(json_string)  # Corrected to use `json.loads`
            logging.info("Successfully converted JSON string to dictionary")
            return data
        except json.JSONDecodeError as e:
            logging.error(f"JSON decoding error: {str(e)}")
            return {"error": f"Invalid JSON format: {str(e)}"}

    def write_to_file(self, file_path, content):
        """
        Writes content to a file.

        :param file_path: Path of the file to write to
        :param content: Content to write (string format)
        :return: Success or failure message
        """
        if not isinstance(file_path, str) or not isinstance(content, str):
            logging.error("Invalid input: file_path and content must be strings")
            return {"status": "failure", "error": "Invalid file path or content"}

        try:
            with open(file_path, "w", encoding="utf-8") as file:
                file.write(content)
            logging.info(f"Successfully wrote to file: {file_path}")
            return {"status": "success", "message": f"Data written to {file_path}"}
        except OSError as e:  # Catch file-system-related errors
            logging.error(f"Failed to write to file {file_path}: {str(e)}")
            return {"status": "failure", "error": str(e)}

    def read_from_file(self, file_path):
        """
        Reads the contents of a file and returns them as a string.

        :param file_path: The path to the file that needs to be read.
        :return: Returns the content of the file as a string after successfully or error message.
        """
        if not isinstance(file_path, str):
            logging.error("Invalid input: file_path must be a string")
            return {"status": "failure", "error": "Invalid file path"}

        try:
            with open(file_path, "r", encoding="utf-8") as file:
                content = file.read()
            logging.info(f"Successfully read from file: {file_path}")
            return {"status": "success", "content": content}
        except FileNotFoundError:
            logging.error(f"File not found: {file_path}")
            return {"status": "failure", "error": "File not found"}
        except OSError as e:    # Handle file-system-related errors
            logging.error(f"Failed to read file {file_path}: {str(e)}")
            return {"status": "failure", "error": str(e)}

    def check_if_file_exists(self, file_path):
        """
        Checks whether the specified file exists at the given file path.

        :param file_path: The path to the file whose existence needs to be checked.
        :type file_path: str
        :return: True if the file exists at the specified path, otherwise False.
        :rtype: bool
        """
        if not isinstance(file_path, str):
            logging.error("Invalid input: file_path must be a string")
            return False

        exists = os.path.exists(file_path)  # return True/False
        logging.info(f"File exists: {exists}")
        return exists

class UtilityFunctions:
    """Contains miscellaneous utility functions."""

    @staticmethod
    def zoom_in(times: int = 2) -> None:
        """Zoom in on the screen using keyboard shortcuts."""
        for _ in range(times):
            pyautogui.keyDown("ctrl")
            pyautogui.press("+")
            pyautogui.keyUp("ctrl")

    @staticmethod
    def zoom_out(times: int = 2) -> None:
        """Zoom out on the screen using keyboard shortcuts."""
        for _ in range(times):
            pyautogui.keyDown("ctrl")
            pyautogui.press("-")
            pyautogui.keyUp("ctrl")

    @staticmethod
    def generate_random_email() -> str:
        """Generates a random email address."""
        random_str = "".join(random.choices(string.ascii_letters + string.digits, k=10))
        email = f"{random_str.lower()}@example.com"
        logging.info(f"Generated email: {email}")
        return email

    @staticmethod
    def generate_random_username() -> str:
        """Generates a random username with uppercase and lowercase mix."""
        random_str = "".join(random.choices(string.ascii_letters, k=10))
        half = len(random_str) // 2
        username = random_str[:half].upper() + random_str[half:].lower()
        logging.info(f"Generated username: {username}")

    @staticmethod
    def generate_secure_password() -> str:
        """Generates a secure random password with special characters."""
        lower, upper, digits, special = string.ascii_lowercase, string.ascii_uppercase, string.digits, "!@#$&*?"
        password = [
            random.choice(lower),
            random.choice(upper),
            random.choice(digits),
            random.choice(special),
        ]
        while len(password) < 8:
            password.append(random.choice(lower + upper + digits + special))
        random.shuffle(password)
        password_str = "".join(password)
        logging.info(f"Generated secure password: {password_str}")
        return password_str

class ExcelManager:
    """Handles Excel file operations."""

    def __init__(self, file_path: str = "../utils/user_data.xlsx"):
        self.file_path = file_path

    def save_user_data(self, username: str = "tester", password: str = "&lackMan123!",
                       business_name: str = "Demo") -> str:
        """Appends user data to an Excel file."""
        new_entry = {"Business Name": business_name, "Username": username, "Password": password}

        try:
            if os.path.exists(self.file_path):
                df = pd.read_excel(self.file_path, engine="openpyxl")
            else:
                df.pd.DataFrame(columns=["Business Name", "Username", "Password"])
            df = pd.concat([df, pd.DataFrame([new_entry])], ignore_index=True)
            df.to_excel(self.file_path, index=False, engine="openpyxl")
            succes_msg = "Excel updated successfully."
            logging.info(succes_msg)
            return succes_msg
        except Exception as e:
            error_msg = f"Failed to update Excel: {e}"
            logging.error(error_msg)
            return error_msg

if __name__ == "__main__":
    # Demonstrate functionality
    config = ConfigManager()
    db_manager = DatabaseManger()
    utilities = UtilityFunctions()
    excel_manager = ExcelManager()