import os
import yaml
import logging


def parse_yaml(file_path):
    """
    Parses a YAML file and returns its contents as a Python object (e.g., dictionary).
    This function attempts to open and parse a YAML file located at the given file path.
    If the file cannot be found or if any errors occur during parsing, an error message
    is logged, and `None` is returned.

    Parameters:
    file_path : str
        Path to the YAML file to be read and parsed.

    Returns:
    dict or other
        A dictionary or another Python object corresponding to the data structure
        in the provided YAML file, or `None` if an error occurs.

    Raises:
    FileNotFoundError
        If the specified file does not exist.
    yaml.YAMLError
        If there is an error while parsing the YAML file.
    """
    try:
        # Log the current working directory for debugging purposes.
        logging.debug(f"Current working directory (cwd): {os.getcwd()}")

        # Open and load the YAML file safely.
        with open(file_path, "r", encoding="utf-8") as yaml_file:
            yaml_parsed = yaml.safe_load(yaml_file)

        # Log successful parsing and return the YAML data.
        logging.info(f"YAML file '{file_path}' parsed successfully.")
        return yaml_parsed

    except FileNotFoundError:
        logging.error(f"YAML file '{file_path}' not found.")
        return None  # Return None to indicate an error

    except yaml.YAMLError as e:
        logging.error(f"Error parsing YAML file '{file_path}': {e}")
        return None  # Return None to indicate an error

if __name__ == "__main__":
    logging.basicConfig(level=logging.INFO)  # Configure logging
    file_path = "config.yaml"  # Example YAML file path
    parsed_data = parse_yaml(file_path)

    if parsed_data is not None:
        print("Parsed YAML Data:", parsed_data)
    else:
        print("Failed to parse the YAML file.")
