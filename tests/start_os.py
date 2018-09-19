import os
import pexpect


architecture = None


def init(arch):
    global architecture
    architecture = arch


def start_os():
    if architecture == "i686":
        kernel = "kernel.elf"
        qemu = "qemu-system-i386"
        extra_qemu_flags = ""
    else:
        kernel = "kernel.img"
        qemu = "qemu-system-arm"
        extra_qemu_flags = "-M raspi2 -m 128 "

    image = os.path.join(
        os.path.abspath(os.path.dirname(os.path.dirname(__file__))),
        "build",
        architecture,
        kernel
    )
    return pexpect.spawn(
        "{qemu} {extra_qemu_flags} -serial mon:stdio -nographic -kernel {image}".format(
            qemu=qemu,
            extra_qemu_flags=extra_qemu_flags,
            image=image,
        )
    )
