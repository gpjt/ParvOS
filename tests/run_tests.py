#!/usr/bin/env python
"""Run the ParvOS tests

Usage:
   run_tests.py <architecture>

"""

from docopt import docopt
import unittest

import start_os


def main(architecture):
    start_os.init(architecture)
    suite = unittest.defaultTestLoader.discover(".")
    unittest.TextTestRunner().run(suite)


if __name__ == "__main__":
    arguments = docopt(__doc__)
    architecture = arguments["<architecture>"]
    main(architecture)
