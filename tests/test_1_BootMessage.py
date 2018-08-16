import os
import pexpect
import unittest


class Test_1_BootMessage(unittest.TestCase):

    def test_get_boot_message(self):
        image = os.path.join(os.path.abspath(os.path.dirname(os.path.dirname(__file__))), "kernel.img")
        qemu = pexpect.spawn(
            "qemu-system-arm -m 128 -no-reboot -M raspi2 -serial stdio -kernel {image}".format(image=image)
        )
        qemu.expect("Booting ParvOS", timeout=20)
