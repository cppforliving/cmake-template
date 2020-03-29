"""Example projname_tool executable tests."""
import os


def test_projname_tool_with_empty_argument_list():
    """Test if projname_tool with empty arguments list will succeed."""
    assert (os.system("projname_tool") & 0xFF) == 0
