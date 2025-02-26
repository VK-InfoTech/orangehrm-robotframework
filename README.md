# OrangeHRM Robot Framework Automation

This repository is an automated testing framework using **Robot Framework** for web UI and API testing. It ensures modular, reusable, and scalable test automation practices to maintain software quality.

---

## 🚀 Features

- Automated testing for OrangeHRM.
- Supports both Web UI (Selenium) and API testing.
- Modular, keyword-driven implementation.
- Supports data-driven testing.
- Easily integrates with CI/CD pipelines.

---

## 📋 Requirements

Make sure you have the following installed:

- **Python 3.11 or above**  
  [Download Python here](https://www.python.org/downloads/)
- **Robot Framework**   
  Install via pip: `pip install robotframework`
- **Selenium Library** for browser testing: `pip install robotframework-seleniumlibrary`
- **Requests Library** for API testing: `pip install robotframework-requests`
- **Browser Drivers**:
  - [ChromeDriver](https://googlechromelabs.github.io/chrome-for-testing/)
  - [MS EdgeDriver](https://developer.microsoft.com/en-us/microsoft-edge/tools/webdriver/)

For a complete list of dependencies, refer to `requirements.txt`.

---

## 🔧 Setup

Follow these steps to set up the framework:

1. Clone the repository:
   ```bash
   git clone https://github.com/<your-repository>
   cd OrangeHRM_Robotframework
   ```

2. Create a virtual environment (recommended):
   ```bash
   python -m venv .venv
   source .venv/bin/activate    # For Linux/macOS
   .venv\Scripts\activate       # For Windows
   ```

3. Install project dependencies:
   ```bash
   pip install -r requirements.txt
   ```

4. Verify installation:
   ```bash
   robot --version
   ```

---

## 🏃 Running Tests

You can execute the tests using the following commands:

- **Run All Tests**:
  ```bash
  robot --outputdir results tests/
  ```

- **Run a Specific Test Suite**:
  ```bash
  robot --outputdir results tests/smoke_suite.robot
  ```

- **Run a Specific Test Case**:
  ```bash
  robot --outputdir results tests/test_case.robot
  ```

- **Run Tests with Tags**:
  ```bash
  robot --outputdir results -i Smoke tests/
  ```

- **Run in Headless Mode** (for CI/CD pipelines):
  ```bash
  robot --variable HEADLESS:True tests/
  ```

---

## 📊 Test Reports & Logs

Once the tests are executed, detailed reports and logs are generated in the `results/` folder:

- **log.html** → Detailed execution logs.
- **report.html** → Summary of the test execution.
- **output.xml** → Machine-readable execution results.

To open a report:
```bash
open results/report.html    # On macOS/Linux
start results/report.html   # On Windows
```

---

## 🔄 CI/CD Integration

### GitHub Actions

The project supports **GitHub Actions** for automated test execution. The pipeline configuration can be found in `.github/workflows/robot_tests.yaml`.

### Jenkins

For Jenkins integration, run Robot Framework tests using:
```bash
robot --outputdir results tests/
```

### Docker (Optional)

To run the tests using Docker, use:
```bash
docker run -v $(pwd):/tests robotframework/robot tests/
```

---

## 🛠 Technologies Used

- **Robot Framework** - Test automation framework.
- **SeleniumLibrary** - For browser automation.
- **RequestsLibrary** - For API interactions.
- **JSONLibrary** - For JSON parsing.
- **DataDriver** - Data-driven testing support.

---

## 🎯 Test Automation Best Practices

- Follow the **Page Object Model (POM)** for web tests.
- Reuse keywords by organizing them into modular files under `resources/keywords/`.
- Maintain centralized test data in `resources/variables/`.
- Store locators separately in `resources/locators/`.
- Use tagging ([Tags] Smoke, Regression) to execute specific tests.
- Run parallel tests wherever possible.
- Integrate tests into CI/CD pipelines for quicker feedback.

---

## 📬 Contact

For questions, suggestions, or contributions, feel free to reach out:

- **Email**: [vimalkumarm523@gmail.com](mailto:vimalkumarm523@gmail.com)
- **GitHub**: [VK-InfoTech](https://github.com/orgs/VK-InfoTech/)

---

## 🔐 License

This project is licensed under the [MIT License](LICENSE).

---

Happy Testing! 🚀
