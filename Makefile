MDIR = drivers/video
TARGET = xtion.ko

CURRENT = $(shell uname -r)
KDIR = /lib/modules/$(CURRENT)/build
PWD = $(shell pwd)
DEST = /lib/modules/$(CURRENT)/kernel/$(MDIR)

ifneq ($(KERNELRELEASE),)

#include Kbuild

obj-m := xtion.o
xtion-y := xtion-core.o xtion-control.o xtion-endpoint.o xtion-color.o xtion-depth.o

avx2_supported := $(call as-instr,vpgatherdd %ymm0$(comma)(%eax$(comma)%ymm1\
				$(comma)4)$(comma)%ymm2,yes,no)
ifeq ($(avx2_supported),yes)
xtion-y += xtion-depth-accel.o
endif

else

KDIR ?= /lib/modules/`uname -r`/build

default:
	$(MAKE) -C $(KDIR) M=$$PWD
clean:
	rm -f *.o aprofile.ko .*.cmd .*.flags *.mod.c
install:
	su -c "cp $(TARGET) $(DEST) && /sbin/depmod -a"

endif

