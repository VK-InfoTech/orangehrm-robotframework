import logging
import mysql.connector
from datetime import datetime
from typing import Optional

from config_manager import ConfigManager


class DatabaseManager:
    """
    Handles database operations, including ensuring the database and table exist,
    inserting test run records, and updating them.
    """

    def __init__(self, config: ConfigManager):
        """
        Initializes the DatabaseManager with a ConfigManager values.
        """
        self.config = config
        self.connection: Optional[mysql.connector.connection.MySQLConnection] = None
        self.cursor: Optional[mysql.connector.cursor.MySQLCursor] = None

    def connect(self) -> None:
        """
        Connects to the MySQL database and ensures the database and table exist.
        """
        try:
            if self.connection and self.connection.is_connected():
                logging.info("Reusing existing database connection.")
                return

            self.connection = mysql.connector.connect(
                host=self.config.db_host,
                user=self.config.db_username,
                password=self.config.db_password,
                database=self.config.db_name,
                port=self.config.db_port,
                auth_plugin='mysql_native_password',
                use_pure=True,  # Force using the MySQL Connector/Python pure Python implementation
            )
            self.cursor = self.connection.cursor()

            # Ensure the database exists
            self.cursor.execute(f"SHOW DATABASES LIKE '{self.config.db_name}';")
            result = self.cursor.fetchone()
            if not result:
                logging.warning(f"Database '{self.config.db_name}' does not exist. Creating it.")
                self.cursor.execute(f"CREATE DATABASE {self.config.db_name};")
                logging.info(f"Database '{self.config.db_name}' created successfully.")

            # Reconnect using the created database
            self.connection.database = self.config.db_name
            logging.info(f"Connected to database '{self.config.db_name}' successfully.")

            # Ensure the table exists
            self.ensure_table_exists()

        except mysql.connector.Error as err:
            logging.error(f"Failed to connect to the database: {err}")
            raise
        except Exception as e:
            logging.error(f"An unexpected error occurred during database connection: {e}")
            raise

    def ensure_table_exists(self):
        """
        Ensures the `test_reports` table exists, creates it if not found.
        """
        try:
            self.cursor.execute("SHOW TABLES LIKE 'test_reports';")
            if not self.cursor.fetchone():
                logging.warning("Table 'test_reports' does not exist. Creating it...")
                create_table_query = """
                CREATE TABLE test_reports (
                    id INT AUTO_INCREMENT PRIMARY KEY,
                    name VARCHAR(255) NOT NULL,
                    start_time DATETIME NOT NULL,
                    end_date DATETIME DEFAULT NULL,
                    run_status VARCHAR(50) NOT NULL
                );
                """
                self.cursor.execute(create_table_query)
                logging.info("Table 'test_reports' created successfully.")
            else:
                logging.info("Table 'test_reports' already exists.")
        except mysql.connector.Error as err:
            logging.error(f"Error ensuring table 'test_reports' exists: {err}")
            raise

    def close_connection(self) -> None:
        """
        Closes the database connection and cursor if they exist.
        """
        if self.cursor:
            self.cursor.close()
            logging.info("Database cursor closed.")
        if self.connection:
            self.connection.close()
            logging.info("Database connection closed.")

    def insert_start_time(self) -> None:
        """
        Inserts a record into the 'test_reports' table to indicate the start of a test run.
        """
        try:
            if not self.connection or not self.connection.is_connected():
                self.connect()  # Ensure the connection is established
            current_time = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
            insert_query = "INSERT INTO test_reports (name, start_time, run_status) VALUES (%s, %s, %s)"
            values = ("Test Run Start", current_time, "Running")
            self.cursor.execute(insert_query, values)
            self.connection.commit()
            logging.info("Test run start record inserted successfully.")
        except mysql.connector.Error as err:
            logging.error(f"Error inserting test run start record: {err}")
            raise

    def update_end_time(self) -> None:
        """
        Updates the most recent 'test_reports' test run record in the database table with the end time.
        """
        try:
            if not self.connection or not self.connection.is_connected():
                self.connect()  # Ensure the connection is established
            current_time = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

            # Fetch the most recent test run record
            self.cursor.execute("SELECT id FROM test_reports ORDER BY id DESC LIMIT 1")
            last_record = self.cursor.fetchone()

            if last_record:
                last_test_run_id = last_record[0]
                update_query = "UPDATE test_reports SET end_date = %s, run_status = %s WHERE id = %s"
                values = (current_time, "Completed", last_test_run_id)
                self.cursor.execute(update_query, values)
                self.connection.commit()
                logging.info("Test run end record updated successfully.")
            else:
                logging.warning("No test run records found to update.")
        except mysql.connector.Error as err:
            logging.error(f"Error updating test run end time record: {err}")
            raise

# # **Instantiate ConfigManager First**
if __name__ == "__main__":
    logging.basicConfig(level=logging.INFO)

    try:
        # Initialize ConfigManager
        config_manager = ConfigManager()

        # Pass ConfigManager to DatabaseManager
        db_manager = DatabaseManager(config_manager)

        # Insert a test run start record
        db_manager.insert_start_time()

        # Simulate some operations, then update the end time
        db_manager.update_end_time()
    except Exception as e:
        logging.error(f"Error in database operations: {e}")
    finally:
        # Ensure the connection is closed after all operations
        db_manager.close_connection()
