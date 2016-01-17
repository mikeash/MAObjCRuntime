all:  all

.PHONY: all  all

all: build/all
build/all: build/.objs/all/src/main.o
	@echo linking.release all
	@xmake l $(VERBOSE) verbose "xcrun%20-sdk%20macosx%20clang++%20-o%20build/all%20*.o%20-Wl,-S%20-arch%20x86_64%20-mmacosx-version-min%3d10.9%20-stdlib%3dlibc++%20-lz%20-isysroot%20/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.11.sdk%20-L/usr/lib%20-L/usr/local/lib"
	@xmake l mkdir build
	@xcrun -sdk macosx clang++ -o build/all build/.objs/all/src/main.o -Wl,-S -arch x86_64 -mmacosx-version-min=10.9 -stdlib=libc++ -lz -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.11.sdk -L/usr/lib -L/usr/local/lib > build/.build.log 2>&1

build/.objs/all/src/main.o: src/main.c
	@echo ccache compiling.release src/main.c
	@xmake l $(VERBOSE) verbose "ccache%20xcrun%20-sdk%20macosx%20clang%20-c%20-fvisibility%3dhidden%20-O3%20-arch%20x86_64%20-fpascal-strings%20-fmessage-length%3d0%20-isysroot%20/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.11.sdk%20-I/usr/include%20-I/usr/local/include%20-Qunused-arguments%20-o%20build/.objs/all/src/main.o%20src/main.c%20>%20build/.build.log%202>&1"
	@xmake l mkdir build/.objs/all/src
	@ccache xcrun -sdk macosx clang -c -fvisibility=hidden -O3 -arch x86_64 -fpascal-strings -fmessage-length=0 -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.11.sdk -I/usr/include -I/usr/local/include -Qunused-arguments -o build/.objs/all/src/main.o src/main.c > build/.build.log 2>&1

