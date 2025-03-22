import logging
import random
import string
import pyautogui

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
        return username

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

utilities = UtilityFunctions()
utilities.zoom_in()
utilities.zoom_out()
utilities.generate_random_email()
utilities.generate_random_username()
utilities.generate_secure_password()