all:  console

.PHONY: all  console

console: build/console
build/console:
	@echo linking.release console
	@xmake l $(VERBOSE) verbose "xcrun%20-sdk%20macosx%20clang++%20-o%20build/console%20*.o%20-Wl,-S%20-arch%20x86_64%20-mmacosx-version-min%3d10.9%20-stdlib%3dlibc++%20-lz%20-isysroot%20/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.11.sdk%20-L/usr/lib%20-L/usr/local/lib"
	@xmake l mkdir build
	@xcrun -sdk macosx clang++ -o build/console  -Wl,-S -arch x86_64 -mmacosx-version-min=10.9 -stdlib=libc++ -lz -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.11.sdk -L/usr/lib -L/usr/local/lib > build/.build.log 2>&1

