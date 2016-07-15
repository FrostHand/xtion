#ifneq ($(KERNELRELEASE),)

obj-m := xtion.o
xtion-y := xtion-core.o xtion-control.o xtion-endpoint.o xtion-color.o xtion-depth.o

avx2_supported := $(call as-instr,vpgatherdd %ymm0$(comma)(%eax$(comma)%ymm1\
				$(comma)4)$(comma)%ymm2,yes,no)

ifeq ($(avx2_supported),yes)
xtion-y += xtion-depth-accel.o
endif

#else
#KDIR ?= /lib/modules/`uname -r`/build
KDIR ?= $(KERNEL_SRC)
SRC := $(shell pwd)

#default: modules
#modules:
#	$(MAKE) -C $(KDIR) M=$(SRC)

all: 
	$(MAKE) -C $(KERNEL_SRC) M=$(SRC) modules
#install: modules_install

modules_install:
	make -C $(KDIR) M=$(SRC) modules_install

clean:
	make -C $(KDIR) M=$(SRC) clean

test:
	gcc $(CFLAGS) xtion-math-emu-tests.c -o xtion-math-emu-tests
	@./xtion-math-emu-tests

#endif

