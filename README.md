# OrangeHRM_Robotframework
🚀 Robot Framework Test Automation

📌 Overview

This project is an automated test suite using Robot Framework for Web UI and API testing. It provides a modular, reusable, and scalable test automation framework to ensure software quality.

📂 Project Structure

RobotFrameworkProject/
│── tests/                # Test cases (organized into smoke, regression, etc.)
│   ├── smoke_tests/      # Smoke test cases
│   ├── regression_tests/ # Regression test cases
│── resources/            # Reusable components (keywords, locators, variables)
│   ├── keywords/         # Custom keywords
│   ├── locators/         # UI locators and API endpoints
│   ├── variables/        # Environment variables and test data
│── logs/                 # Execution logs and screenshots
│── results/              # Reports (log.html, report.html)
│── test_suites/          # Test suite files
│── libs/                 # Custom Python libraries (if needed)
│── .gitignore            # Excludes unnecessary files from Git
│── README.md             # Project documentation
│── requirements.txt      # Python dependencies
│── robot_tests.yaml      # CI/CD configuration (GitHub Actions)
│── pyproject.toml        # Python dependency management (Poetry)

🔧 Installation & Setup

📌 1. Prerequisites

Python 3.x (https://www.python.org/downloads/)

Robot Framework (https://robotframework.org/)

WebDrivers for browser automation

Chrome Driver: Download

Edge Driver: Download

IDE (Recommended: PyCharm, VS Code)

📌 2. Installation Steps

Clone the repository:

git clone https://github.com/your-repo-name.git
cd your-repo-name

Create and activate a virtual environment (optional but recommended):

python -m venv .venv
source .venv/bin/activate  # macOS/Linux
.venv\Scripts\activate     # Windows

Install dependencies:

pip install -r requirements.txt

Verify the installation:

robot --version

🏃 Running Tests

📌 Run All Tests

robot --outputdir results tests/

📌 Run Specific Test Suite

robot --outputdir results test_suites/smoke_suite.robot

📌 Run Specific Test Case

robot --outputdir results tests/smoke_tests/TC_001_Login.robot

📌 Run Tests with Tags

robot --outputdir results -i Smoke tests/

📌 Run Tests in Headless Mode (For CI/CD)

robot --variable HEADLESS:True tests/

📊 Test Reports & Logs

After execution, reports are generated in the results/ folder:

log.html → Detailed execution logs

report.html → Summary of test execution

output.xml → Machine-readable execution report

To open reports:

open results/report.html

🔄 CI/CD Integration (GitHub Actions)

This project supports GitHub Actions for automated test execution on every code push.

📌 Running Tests in CI/CD

GitHub Actions: Configured via robot_tests.yaml

Jenkins: Execute tests with:

robot -d results tests/

Docker (If applicable):

docker run -v $(pwd):/tests robotframework/robot tests/

🛠 Technologies & Libraries Used

✔ Robot Framework - Test automation framework✔ SeleniumLibrary - UI testing✔ RequestsLibrary - API testing✔ JSONLibrary - JSON parsing✔ DataDriver - Data-driven testing✔ LoggingLibrary - Custom logging✔ Poetry - Python dependency management

🎯 Best Practices

✅ Use Page Object Model (POM) for UI tests✅ Modular keywords (resources/keywords/) for reusability✅ Organize locators separately (resources/locators/)✅ Keep test data external (resources/variables/)✅ Use tags ([Tags] Smoke, Regression) for filtering✅ Run tests in parallel for efficiency✅ Integrate with CI/CD for continuous testing

📬 Contact

For any questions or contributions, feel free to reach out:
✉ Email: vimalkumarm523@gmail.com🌐 GitHub: VK-InfoTech

This README.md provides comprehensive documentation for your Robot Framework project, making it easy to set up, execute, and maintain tests. 🚀 Let me know if you need modifications! 🔥

