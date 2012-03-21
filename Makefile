CC = gcc
CFLAGS = -I
SRC = main.c hello.c
OBJ = main.o hello.o
OPT = -o
EXEC = hello


${EXEC}: ${OBJ} 
	${CC} ${OPT} ${EXEC} ${OBJ}  

main.o: main.c hello.h
	${CC} -c main.c hello.h

hello.o: hello.c hello.h
	${CC} -c hello.c hello.h

clean: 
	rm -f *.o hello

