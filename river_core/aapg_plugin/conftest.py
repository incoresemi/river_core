# conftest.py



def pytest_addoption(parser):
    parser.addoption(
        "--configlist",
        action="store"
    )
