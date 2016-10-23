# DJGPP Docker image

[OpenSUSE](https://www.opensuse.org/) 42.1 +
[DJGPP](http://www.delorie.com/djgpp/) v2.05  +
[GCC](https://gcc.gnu.org/) 6.1.0

`docker pull anibali/djgpp`

* Cross-compile DOS applications written in C
* Includes DJGPP's libc implementation

## Usage

### Compiling an application with libc

`hello.c`

```c
#include <stdio.h>

int main() {
  printf("Hello world, with libc!\n");
}
```

Compile and link

```bash
docker run --rm -it --volume=$PWD:/workspace djgpp \
  gcc -o hello.exe hello.c
```

Run (requires dosemu)

```bash
curl -OJ http://www.delorie.com/pub/djgpp/current/v2misc/csdpmi7b.zip
unzip -p csdpmi7b.zip bin/CWSDPMI.EXE > CWSDPMI.EXE
dosemu -dumb hello.exe
```

### Compiling a bare application

This is based on the excellent blog post
"[How to build DOS COM files with GCC](http://nullprogram.com/blog/2014/12/09/)".

`hello.c`

```c
asm (".code16gcc\n"
     "call  _dosmain\n"
     "mov   $0x4C,%ah\n"
     "int   $0x21\n");

static void print(char *string) {
  asm volatile ("mov   $0x09, %%ah\n"
                "int   $0x21\n"
                : /* no output */
                : "d"(string)
                : "ah");
}

int dosmain(void) {
  print("Hello world!\n$");
  return 0;
}
```

`com.ld`

```ld
OUTPUT_FORMAT(binary)
SECTIONS
{
  . = 0x0100;
  .text :
  {
    *(.text);
  }
  .data :
  {
    *(.data);
    *(.bss);
    *(.rodata);
  }
  _heap = ALIGN(4);
}
```

Compile

```bash
docker run --rm -it --volume=$PWD:/workspace djgpp \
  gcc -c -std=gnu99 -Os -nostdlib -m32 -march=i386 -ffreestanding hello.c
```

Link

```bash
docker run --rm -it --volume=$PWD:/workspace djgpp \
  ld -o hello.com --nmagic --script=com.ld hello.o
```

Run (requires dosemu)

```bash
dosemu -dumb hello.com
```

## Credit

* [DJGPP port of gcc-6.1.0](https://virtuallyfun.superglobalmegacorp.com/2016/05/05/announce-djgpp-port-of-gcc-6-1-0/)
* [How to build DOS COM files with GCC](http://nullprogram.com/blog/2014/12/09/)
