# import os
# import logging
# from configparser import ConfigParser
# from typing import Optional
#
#
# class ConfigManager:
#     """Handles reading configuration settings from a config.ini file."""
#
#     def __init__(self, config_path: Optional[str] = None):
#         self.env = None
#         self.application = None
#         self.db_name = None
#         self.db_host = None
#         self.db_port = None
#         self.db_password = None
#         self.db_username = None
#
#         base_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
#         default_path = os.path.join(base_dir, "resources", "data", "config.ini")
#         self.config_path = config_path or default_path
#
#         logging.info(f"Looking for config.ini at {self.config_path}")
#
#         if not os.path.isfile(self.config_path):
#             logging.error(f"Configuration file '{self.config_path}' not found!")
#             raise FileNotFoundError(
#                 f"Configuration file '{self.config_path}' not found! Please ensure the file exists at the expected path."
#             )
#
#         self.config = ConfigParser()
#         # self.config.read(self.config_path)
#         self._load_config()
#
#     def _load_config(self) -> None:
#         """Loads configuration settings from the config.ini file."""
#         try:
#             self.config.read(self.config_path)
#
#             self.db_username = self.config.get("database", "mysql_user", fallback=None)
#             self.db_password = self.config.get("database", "mysql_password", fallback=None)
#             self.db_host = self.config.get("database", "sql_host", fallback=None)
#             self.db_port = self.config.get("database", "mysql_port", fallback=None)
#             self.db_name = self.config.get("database", "name", fallback=None)
#             self.env = self.config.get("environment", "type", fallback=None)
#             self.application_name = self.config.get("application", "name", fallback=None)
#
#             if None in [self.db_username, self.db_password, self.db_host, self.db_port, self.db_name, self.env, self.application_name]:
#                 missing_keys = [key for key, value in{
#                     "db_username": self.db_username,
#                     "db_password": self.db_password,
#                     "db_host": self.db_host,
#                     "db_port": self.db_port,
#                     "db_name": self.db_name,
#                     "env": self.env,
#                     "application": self.application_name
#                 }.items() if value is None]
#                 logging.error(f"Missing required configuration keys: {', '.join(missing_keys)}")
#                 raise ValueError(f"Missing required configuration keys: {', '.join(missing_keys)}")
#
#             logging.info("Configuration file read and loaded successfully!")
#
#         except KeyError as e:
#             logging.error(f"Missing configuration key: {e}")
#             raise ValueError(f"Missing configuration key: {e}")
#
#
# if __name__ == "__main__":
#     # ConfigManager initialization will automatically load the config
#     try:
#         config_manager = ConfigManager()
#     except Exception as e:
#         logging.error(f"Failed to initialize ConfigManager: {e}")

import os
import logging
from configparser import ConfigParser


class ConfigManager:
    """
    Handles reading configuration settings from a config.ini file.
    """

    def __init__(self, config_path: str = None):
        self.env = None
        self.application_name = None
        self.db_name = None
        self.db_host = None
        self.db_port = None
        self.db_password = None
        self.db_username = None

        base_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
        default_path = os.path.join(base_dir, "resources", "data", "config.ini")
        self.config_path = config_path or default_path

        logging.info(f"Looking for config.ini at {self.config_path}")

        if not os.path.isfile(self.config_path):
            raise FileNotFoundError(
                f"Configuration file '{self.config_path}' not found! Please ensure the file exists at the expected path."
            )

        self.config = ConfigParser()
        self.config.read(self.config_path)
        self._load_config()

    def _load_config(self) -> None:
        """
        Loads configuration settings from the config.ini file.
        """
        try:
            self.db_username = self.config.get("database", "mysql_user", fallback=None)
            self.db_password = self.config.get("database", "mysql_password", fallback=None)
            self.db_host = self.config.get("database", "sql_host", fallback=None)
            self.db_port = self.config.get("database", "mysql_port", fallback=None)
            self.db_name = self.config.get("database", "mysql_database_name", fallback=None)
            self.env = self.configqait.get("environment", "type", fallback=None)
            self.application_name = self.config.get("application", "name", fallback=None)

            logging.info("Configuration file read and loaded successfully!")
        except KeyError as error:
            logging.error(f"Missing configuration key: {error}")
            raise ValueError(f"Missing configuration key: {error}") from error

    def get_database_config(self):
        """Returns database configuration as a dictionary."""
        return {
            "host": self.db_host,
            "user": self.db_username,
            "password": self.db_password,
            "database": self.db_name,
            "port": self.db_port,
        }


if __name__ == "__main__":
    try:
        config_manager = ConfigManager()
        logging.info("ConfigManager initialized successfully.")
    except Exception as e:
        logging.error(f"Error initializing ConfigManager: {e}")
