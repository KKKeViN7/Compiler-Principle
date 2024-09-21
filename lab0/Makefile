.PHONY: pre, lexer, ast-gcc, ast-llvm, cfg, ir-gcc, ir-llvm, asm, obj, exe, antiobj, antiexe, arm, test-arm, dot, test1, test2, test3
pre:
	gcc main.c -E -o main.i

lexer:
	clang -E -Xclang -dump-tokens main.c

ast-gcc:
	gcc -fdump-tree-original-raw main.c

ast-llvm:
	clang -E -Xclang -ast-dump main.c

cfg:
	gcc -O0 -fdump-tree-all-graph main.c

dot:
	dot main.c.012t.cfg.dot -Tpng > dot.png

ir-gcc:
	gcc -O0 -fdump-rtl-all-graph main.c

ir-llvm:
	clang -S -emit-llvm main.c

test1:
	clang test.ll -o test
	./test

asm:
	gcc -O0 -o main.S -S -masm=att main.i

arm:
	arm-linux-gnueabihf-gcc main.c -S -o main_arm.S 
	arm-linux-gnueabihf-gcc main_arm.S -o main_arm -static

test2:
	arm-linux-gnueabihf-gcc fac.S -o fac.out
	qemu-arm -L /usr/arm-linux-gnueabihf ./fac.out
	
test3:
	arm-linux-gnueabihf-gcc fib.S -o fib.out
	qemu-arm -L /usr/arm-linux-gnueabihf ./fib.out

obj:
	gcc -O0 -c -o main.o main.S

antiobj:
	objdump -d main.o > main-anti-obj.S
	nm main.o > main-nm-obj.txt

exe:
	gcc -O0 -o main main.o
	
antiexe:
	objdump -d main > main-anti-exe.S
	nm main > main-nm-exe.txt

test-arm:
	arm-linux-gnueabihf-gcc main_arm.S -o main_arm.out
	qemu-arm -L /usr/arm-linux-gnueabihf ./main_arm.out

clean:
	rm -rf *.c.*

clean-all:
	rm -rf *.c.* *.o *.S *.dot *.out *.txt *.ll *.i main