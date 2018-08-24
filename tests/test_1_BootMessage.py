import unittest

from start_os import start_os


class Test_1_BootMessage(unittest.TestCase):

    def test_get_boot_message(self):
        qemu = start_os()
        qemu.expect_exact("Booting ParvOS", timeout=5)
