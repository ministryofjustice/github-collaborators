import unittest
from unittest.mock import MagicMock, patch

from scripts.check_fork_status import PullRequestForked


@patch("github.Github.__new__", new=MagicMock)
class TestPullRequestForked(unittest.TestCase):

    def test_process_pull_request_no_input(self):

        pr_processor = PullRequestForked(None, None)

        with self.assertRaises(SystemExit) as cm:
            pr_processor.process_pull_request()
            self.assertEqual(cm.exception, "Error")

    def test_process_pull_request_correct_input_forked(self):

        pr_json_data = {
            "head": {"repo": {"fork": True, "name": "test-repo"}},
            "number": 123,
        }

        oauth_token = "dummy_token"

        pr_processor = PullRequestForked(oauth_token, pr_json_data)
        self.assertEqual(pr_processor.process_pull_request(), True)

    def test_process_pull_request_correct_input_not_forked(self):

        pr_json_data = {
            "head": {"repo": {"fork": False, "name": "test-repo"}},
            "number": 123,
        }

        oauth_token = "dummy_token"

        pr_processor = PullRequestForked(oauth_token, pr_json_data)
        self.assertEqual(pr_processor.process_pull_request(), False)


if __name__ == "__main__":
    unittest.main()
