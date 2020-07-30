# conftest.py



def pytest_addoption(parser):
    parser.addoption(
        "--regresslist",
        action="store"
    )
