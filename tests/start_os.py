import os
import pexpect


def start_os():
    image = os.path.join(
        os.path.abspath(os.path.dirname(os.path.dirname(__file__))),
        "build",
        "rpi",
        "kernel.img"
    )
    return pexpect.spawn(
        "qemu-system-arm -m 128 -no-reboot -M raspi2 -serial stdio -kernel {image}".format(image=image)
    )
