# conftest.py
import pytest
import inspect
from py.xml import html


def pytest_html_report_title(report):
    report.title = "DuT Report - sample"


def pytest_addoption(parser):
    parser.addoption("--make_file", action="store")
    parser.addoption("--work_dir", action="store")
    parser.addoption("--key_list", action="store")


@pytest.mark.optionalhook
def pytest_html_results_table_header(cells):
    cells.insert(1, html.th('Stage'))
