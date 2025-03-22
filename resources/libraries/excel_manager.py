import os
import logging
import pandas as pd

class ExcelManager:
    """Handles Excel file operations."""

    def __init__(self, file_path: str = "user_data.xlsx"):
        self.file_path = file_path

    def save_user_data(self, username: str = "tester", password: str = "&lackMan123!", business_name: str = "Demo") -> str:
        """Appends user data to an Excel file."""
        new_entry = {"Business Name": business_name, "Username": username, "Password": password}

        try:
            if os.path.exists(self.file_path):
                df = pd.read_excel(self.file_path, engine="openpyxl")
            else:
                df = pd.DataFrame(columns=["Business Name", "Username", "Password"])
            df = pd.concat([df, pd.DataFrame([new_entry])], ignore_index=True)
            df.to_excel(self.file_path, index=False, engine="openpyxl")
            logging.info("Excel updated successfully.")
            return "Excel updated successfully."
        except Exception as e:
            logging.error(f"Failed to update Excel: {e}")
            return f"Failed to update Excel: {e}"


excel_manager = ExcelManager()
excel_manager.save_user_data()