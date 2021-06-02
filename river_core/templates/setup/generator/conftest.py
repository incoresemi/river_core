# conftest.py


def pytest_html_report_title(report):
    report.title = "Generation Report - Sample"


def pytest_addoption(parser):
    # TODO: Edit as required, assuming some sample values that should be passed to the pytest as a options
    # Should be added here
    parser.addoption("--seed", action="store")
