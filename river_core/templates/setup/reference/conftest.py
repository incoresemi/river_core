# conftest.py
import pytest
from py.xml import html


def pytest_html_report_title(report):
    report.title = "Reference Report - sample"


def pytest_addoption(parser):
    parser.addoption("--make_file", action="store")
    parser.addoption("--work_dir", action="store")
    parser.addoption("--key_list", action="store")
