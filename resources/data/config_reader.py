import os
from configparser import ConfigParser

class ConfigReader:
    def __init__(self):
        """ Initialize the ConfigReader class and read the configuration file (config.ini) """
        dir_path = os.path.dirname(os.path.realpath(__file__))  # Get the current directory path
        config_file = os.path.join(dir_path, 'config.ini')  # Path to the config.ini file
        self.config = ConfigParser()    # Create ConfigParser instance
        self.config.read(config_file)   # Load the config.ini file

    def environment(self):
        """ Get the environment value from the config.ini file """
        return self.config['environment']['type']

    def application(self):
        """ Get the application value from the config.ini file """
        return self.config['application']['name']

    def get_browser(self):
        """ Get the browser value from the config.ini file """
        return self.config['environment']['browser']

    def get_browser_mode(self):
        """ Get the browser_mode value from the config.ini file """
        return self.config['environment']['mode']

    def get_start_url(self):
        """ Get the start_url value from the config.ini file """
        return self.config['environment']['start_url']

    def base_url(self):
        """ Get the base_url value from the config.ini file """
        return self.config['rest_api']['base_url']

    def sign_in_url(self):
        """ Get the sign_in_url value from the config.ini file """
        return self.config['users']['sign_in_url']

    def login_url(self):
        """ Get the login_url value from the config.ini file """
        return self.config['users']['login_url']

    def user_name(self):
        """ Get the user_name value from the config.ini file """
        return self.config['users']['username']

    def password(self):
        """ Get the password value from the config.ini file """
        return self.config['users']['password']

ObjConfigReader = ConfigReader()