all: tests

tests:
	gcc -framework Foundation --std=c99 main.m MARuntime.m MARTNSObject.m RTProtocol.m RTMethod.m RTIvar.m RTProperty.m RTUnregisteredClass.m

clean:
	rm -f a.out
