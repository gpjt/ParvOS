import io
import os
import subprocess
import time
import unittest


def wait_for(function, timeout_seconds):
    start = time.time()
    wait_time = min(timeout_seconds / 10.0, 5)
    tries = 0
    while True:
        tries += 1
        try:
            function()
            return
        except AssertionError:
            if tries > 2 and time.time() > start + timeout_seconds:
                raise
            else:
                time.sleep(wait_time)



class Test_1_BootMessage(unittest.TestCase):

    def test_get_boot_message(self):
        process_output_stream = io.BytesIO()
        image = os.path.join(os.path.abspath(os.path.dirname(os.path.dirname(__file__))), "kernel.img")
        process = subprocess.Popen(
            "qemu-system-arm -m 128 -no-reboot -M raspi2 -serial stdio -kernel {image}".format(image=image),
            shell=True,
            stdout=subprocess.PIPE
        )
        try:
            def boot_message_to_appear():
                process_output = process_output_stream.getvalue()
                assert b"Booting ParvOS" in process_output, "Can't find boot message in {}".format(process_output)
            wait_for(boot_message_to_appear, timeout_seconds=20)
        finally:
            process.kill()
            subprocess.check_call("stty sane", shell=True)
