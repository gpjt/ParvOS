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
        "qemu-system-arm -M raspi2 -m 128 -serial mon:stdio -nographic -kernel {image}".format(image=image)
    )
