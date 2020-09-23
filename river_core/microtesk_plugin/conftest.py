# conftest.py



def pytest_addoption(parser):
    parser.addoption(
        "--configlist",
        action="store"
    )

    parser.addoption(
        "--seed",
        action="store"
    )

    parser.addoption(
        "--count",
        action="store"
    )
