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
        return self.config['ENVIRONMENT']['environment']

    def application(self):
        """ Get the application value from the config.ini file """
        return self.config['APPLICATION']['Application']

    def browser(self):
        """ Get the browser value from the config.ini file """
        return self.config['BROWSER']['Browser']

    def base_url(self):
        """ Get the base_url value from the config.ini file """
        return self.config['RESTAPI']['base_url']

    def sign_in_url(self):
        """ Get the sign_in_url value from the config.ini file """
        return self.config['USERS']['sign_in_url']

    def login_url(self):
        """ Get the login_url value from the config.ini file """
        return self.config['USERS']['login_url']

    def user_name(self):
        """ Get the user_name value from the config.ini file """
        return self.config['USERS']['user_name']

    def password(self):
        """ Get the password value from the config.ini file """
        return self.config['USERS']['password']

ObjConfigReader = ConfigReader()