import time
import unittest

from start_os import start_os


class Test_2_Interrupts(unittest.TestCase):

    def test_interrupt_prints_ping_every_second_or_so(self):
        qemu = start_os()
        qemu.expect_exact("Initializing interrupts... ", timeout=5)

        qemu.expect_exact("interrupt!", timeout=5)
        first_interrupt_time = time.time()

        qemu.expect_exect("interrupt!", timeout=5)
        second_interrupt_time = time.time()

        time_between = second_interrupt_time - first_interrupt_time
        self.assertTrue(
            0.9 < time_between < 1.1,
            "Not roughly one second between first and second interrupt (was %s)".format(time_between)
        )
