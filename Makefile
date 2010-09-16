all: tests

tests:
	gcc -framework Foundation --std=c99 main.m MARTNSObject.m RTMethod.m RTIvar.m RTUnregisteredClass.m

clean:
	rm -f a.out
