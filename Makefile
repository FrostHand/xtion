
ifneq ($(KERNELRELEASE),)

obj-m := xtion.o
xtion-y := xtion-core.o xtion-control.o xtion-endpoint.o xtion-color.o xtion-depth.o

avx2_supported := $(call as-instr,vpgatherdd %ymm0$(comma)(%eax$(comma)%ymm1\
				$(comma)4)$(comma)%ymm2,yes,no)

ifeq ($(avx2_supported),yes)
xtion-y += xtion-depth-accel.o
endif

else

KDIR ?= /lib/modules/`uname -r`/build

all:
	$(MAKE) -C $(KDIR) M=$$PWD

default:
	$(MAKE) -C $(KDIR) M=$$PWD

endif

