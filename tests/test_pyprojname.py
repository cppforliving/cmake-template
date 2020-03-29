"""Example projname python bindings tests."""
import pyprojname


def test_pyprojname_run_with_empty_argument_list():
    """Test if projname run with empty arguments list will succeed."""
    assert pyprojname.run([]) == 0


def test_pyprojname_run_with_one_argument():
    """Test if projname run with filename as argument will succeed."""
    assert pyprojname.run([__file__]) == 0
