import os
import json
import requests
import logging
from datetime import datetime

class CustomPythonLib:
    """
    A custom Python library for Robot Framework with utility functions
    such as handling API requests, JSON conversions, timestamp retrieval,
    and file operations.
    """

    def __init__(self):
        """Initialize logging settings"""
        logging.basicConfig(
            filename="custom_lib.log",
            level=logging.INFO,
            format="%(asctime)s - %(levelname)s - %(message)s",
        )
        logging.info("Custom Python Library Initialized")

    def get_current_timestamp(self, format="%Y-%m-%d %H:%M:%S"):
        """
        Returns the current timestamp in the specified format.

        :param format: Date format string (default: "%Y-%m-%d %H:%M:%S")
        :return: Current timestamp as a string
        """
        timestamp = datetime.now().strftime(format)
        logging.info(f"Generated timestamp: {timestamp}")
        return timestamp

    def convert_json_to_dict(self, json_string):
        """
        Converts a JSON string into a Python dictionary.

        :param json_string: JSON formatted string
        :return: Python dictionary or error message if invalid
        """
        try:
            data = json.loads(json_string)
            logging.info("Successfully converted JSON string to dictionary")
            return data
        except json.JSONDecodeError as e:
            logging.error(f"JSON decoding error: {str(e)}")
            return {"error": f"Invalid JSON format: {str(e)}"}

    def make_get_request(self, url, headers=None):
        """
        Makes a GET request to the specified URL and returns the response JSON.

        :param url: API endpoint URL
        :param headers: Optional headers as a dictionary
        :return: JSON response or error message
        """
        try:
            response = requests.get(url, headers=headers)
            response.raise_for_status()
            logging.info(f"GET request successful: {url}")
            return response.json()
        except requests.exceptions.RequestException as e:
            logging.error(f"GET request failed: {str(e)}")
            return {"error": str(e)}

    def make_post_request(self, url, data, headers=None):
        """
        Makes a POST request with JSON data and returns the response JSON.

        :param url: API endpoint URL
        :param data: Dictionary containing JSON payload
        :param headers: Optional headers as a dictionary
        :return: JSON response or error message
        """
        try:
            response = requests.post(url, json=data, headers=headers)
            response.raise_for_status()
            logging.info(f"POST request successful: {url}")
            return response.json()
        except requests.exceptions.RequestException as e:
            logging.error(f"POST request failed: {str(e)}")
            return {"error": str(e)}

    def write_to_file(self, file_path, content):
        """
        Writes content to a file.

        :param file_path: Path of the file to write to
        :param content: Content to write (string format)
        :return: Success or failure message
        """
        try:
            with open(file_path, "w", encoding="utf-8") as file:
                file.write(content)
            logging.info(f"Successfully wrote to file: {file_path}")
            return {"status": "success", "message": f"Data written to {file_path}"}
        except Exception as e:
            logging.error(f"Failed to write to file {file_path}: {str(e)}")
            return {"error": str(e)}

    def read_from_file(self, file_path):
        """
        Reads content from a file.

        :param file_path: Path of the file to read
        :return: File content as string or error message
        """
        if not os.path.exists(file_path):
            logging.error(f"File not found: {file_path}")
            return {"error": "File not found"}

        try:
            with open(file_path, "r", encoding="utf-8") as file:
                content = file.read()
            logging.info(f"Successfully read from file: {file_path}")
            return {"status": "success", "content": content}
        except Exception as e:
            logging.error(f"Failed to read file {file_path}: {str(e)}")
            return {"error": str(e)}

    def check_if_file_exists(self, file_path):
        """
        Checks if a file exists.

        :param file_path: Path of the file to check
        :return: True if file exists, False otherwise
        """
        exists = os.path.exists(file_path)
        logging.info(f"File exists check for {file_path}: {exists}")
        return exists

# Required for Robot Framework to recognize this as a library
if __name__ == "__main__":
    lib = CustomPythonLib()
    print(lib.get_current_timestamp())  # Example function call
