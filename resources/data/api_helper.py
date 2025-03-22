import os
import requests
from configparser import ConfigParser

import urllib3
urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)     #Disable insecure request warnings (optional, for HTTPS with self-signed certificates)


class ApiHelper:
    """A helper class for handing API configurations and executing HTTP operations."""

    def __init__(self):
        """
        Initialize the class attributes for handling configuration and response data.
        """
        self.base_url = None
        self.login_url = None
        self.mongo_uri = None
        self.database_name = None
        self.collection_name = None
        self.username = None
        self.password = None
        self.rest_api_endpoints = {}
        self.environment = None

        # Endpoints
        self.login_endpoint = None

    def read_config_file(self):
        """
        Reads and initializes the application configuration from 'config.ini' in the same directory as this script.
        """
        try:
            # Define the config file path
            config_path = os.path.join(os.path.dirname(os.path.realpath(__file__)),'config.ini')
            if not os.path.exists(config_path):
                raise FileNotFoundError(f"Configuration file not found at {config_path}")

            config = ConfigParser()
            config.read(config_path)

            # Set API-related configurations
            self.base_url = config.get('rest_api', 'base_url', fallback=None)
            self.environment = config.get('environment', 'type', fallback=None)
            self.login_url = config.get('users', 'login_url', fallback=None)

            # Set database Configurations
            self.mongo_uri = config.get('database', 'mongo_uri', fallback=None)
            self.database_name = config.get('database', 'name', fallback=None)
            self.collection_name = config.get('database', 'collection', fallback=None)

            # Set user Credentials
            self.username = config.get('users', 'username', fallback=None)
            self.password = config.get('users', 'password', fallback=None)

            print("Configuration file read and loaded successfully.")

        except Exception as e:
            print(f"Error reading configuration file: {str(e)}")
            raise

    def read_endpoints(self):
        """
        Reads API endpoint configurations from 'config_end_url.ini'.
        """
        try:
            # Define the config file path
            config_path = os.path.join(os.path.dirname(os.path.realpath(__file__)),'config_end_url.ini')
            if not os.path.exists(config_path):
                raise FileNotFoundError(f"Endpoints configuration file not found at {config_path}")

            config = ConfigParser()
            config.read(config_path)

            # Set endpoint configuration
            self.rest_api_endpoints = {section.lower(): dict(config.items(section)) for section in config.sections()}

            # Set specific endpoints as attributes
            self.login_endpoint = self.rest_api_endpoints.get('postapi_end_url', {}).get('login', None)

            print("API endpoints read and loaded successfully.")

        except Exception as e:
            print(f"Error reading API endpoints: {str(e)}")
            raise

    def post(self, endpoint_key, username, password):
        """
        Executes an HTTP POST request to a target endpoint using provided authentication credentials.

        :param endpoint_key: Endpoint key in 'postapi_end_url' section.
        :param username: Optionally override default username.
        :param password: Optionally override default password.
        :return: Response object on success or None on failure.
        """
        try:
            # Find the endpoint in the configuration and Get endpoint URL
            endpoint = self.rest_api_endpoints.get('postapi_end_url', {}).get(endpoint_key.lower(), None)
            if not endpoint:
                raise ValueError(f"Endpoint key '{endpoint_key}' not found under 'postapi_end_url' section in the configuration Endpoints URL file.")

            # Create full URL
            url = f"{self.base_url.rstrip('/')}/{endpoint.lstrip('/')}"
            print(f"POST request URL: {url}")

            # Payload for the POST request
            payload = {
                'user_name': username or self.username,
                'password': password or self.password
            }

            # Execute the POST request
            response = requests.post(url, data=payload, verify=False)
            response.raise_for_status()     # Raise HTTP errors if they occur
            print(f"Response: {response.status_code}, {response.text}")
            return response

        except Exception as e:
            print(f"Error executing POST request: {str(e)}")
            return None

    def get(self, endpoint_key):
        """
        Execute an HTTP GET request to the specified endpoint.

        :param endpoint_key: Endpoint key in 'getapi_end_url' section.
        :return: Response object on success or None on failure.
        """
        try:
            # Find the endpoint in the configuration and Get endpoint URL
            # endpoint = self.rest_api_endpoints['getapi_end_url'].get(endpoint_key, None)
            endpoint = self.rest_api_endpoints.get('getapi_end_url', {}).get(endpoint_key.lower(), None)
            if not endpoint:
                raise ValueError(f"Endpoint key '{endpoint_key}' not found in getapi_end_url configuration.")

            # Create full URL
            # url = os.path.join(self.base_url, endpoint)
            url = f"{self.base_url.rstrip('/')}/{endpoint.lstrip('/')}"
            print(f"GET request URL: {url}")

            # Execute the GEt request
            headers = {"Content-Type": "application/json"}  # Adjust headers as needed
            response = requests.get(url, headers=headers, verify=False)
            response.raise_for_status()     # Raise HTTP errors if they occur
            print(f"Response: {response.status_code}, {response.text}")
            return response

        except Exception as e:
            print(f"Error executing GET request: {str(e)}")
            return None

    def login_api(self):
        """
        Logs in a user and retrieves an access token.

        :return: Tuple (status_code, token) on successful, or None on failure.
        """
        try:
            print(f"Login Request -> URL: {self.login_endpoint}, Username: {self.username}, Password: {self.password}")

            # Execute the POST request using the credentials
            response = self.post('login', username=self.username, password=self.password)

            # Check if the response is valid (not None)
            if response is None:
                print("No valid response received from the API.")
                return None

            # Validate the HTTP process valid response and status code
            if response.status_code == 200:
                try:
                    # Extract token from the response JSON
                    data = response.json()
                    token = data.get('token')
                    print(f"Access Token: {token}")
                    return response.status_code, token
                except ValueError:
                    print("Error parsing JSON response.")
                    return response.status_code, None

            # Handle unsuccessful status codes
            print(f"Login failed. Status code: {response.status_code}, Response: {response.text}")
            return response.status_code, None

        except Exception as e:
            # Print exception details for debugging
            print(f"An error occurred during login: {str(e)}")
            return None

API_Helper = ApiHelper()
API_Helper.read_config_file()
API_Helper.read_endpoints()
API_Helper.login_api()