import os
import pytest


@pytest.fixture
def os_environment_setup():
    os.environ["account_num"] = "042442756249"
    os.environ["region"] = "us-west-1"
