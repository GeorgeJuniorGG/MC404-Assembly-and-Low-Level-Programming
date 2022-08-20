CC=clang
LD=ld.lld
CFLAGS=-g -O0 --target=riscv32 -march=rv32gc -mabi=ilp32 -mno-relax
LDFLAGS=-g
TARGET=t2-parte1.x

SRCS_S=$(wildcard *.s)
OBJS_S=$(SRCS_S:.s=.o)
SRCS_C=$(wildcard *.c)
OBJS_C=$(SRCS_C:.c=.o)

all: clean compile

.s.o:
	$(CC) -c $(CFLAGS) $< -o $@

.c.o:
	$(CC) -c $(CFLAGS) $< -o $@

compile: $(OBJS_S) $(OBJS_C)
	$(LD) $(LDFLAGS) $^ -o $(TARGET)

clean:
	@rm -rf *.o *.x
