MAObjCRuntime
-------------

MAObjCRuntime is an ObjC wrapper around the Objective-C runtime APIs. If that's confusing, it provides a nice object-oriented interface around (some of) the C functions in /usr/include/objc.

MAObjCRuntime is released under a BSD license. For the official license, see the LICENSE file.

Quick Start
-----------

The action begins in `MARTNSObject.h`. Various methods are added to `NSObject` to allow querying and manipulation. Most of these are class methods, because they operate on classes. There are a couple of instance methods as well. All of these methods start with `rt_` to avoid name conflicts. The `RTMethod` and `RTIvar` classes are used to represent a single method and a single instance variable, respectively. Their use should be fairly obvious.

Querying
--------

You can query any class's methods, instance variables, or other attributes using the methods provided. For example:

    // get all subclasses of a class
    NSArray *subclasses = [MyClass rt_subclasses];
    
    // check out the methods on NSString
    NSArray *methods = [NSString rt_methods];
    for(RTMethod *method in methods)
        NSLog(@"%@", method);
    
    // does it have any ivars?
    NSLog(@"%@", [NSString rt_ivars]);
    
    // how big is a constant string instance?
    NSLog(@"%ld", (long)[[@"foo" rt_class] rt_instanceSize]);

Modifying
---------

You can add new methods using `+rt_addMethod:`. You can modify the implementation of an existing method using the `-setImplementation:` method on `RTMethod`. Example:

    // swizzle out -[NSObject description] (don't do this)
    static NSString *NewDescription(id self, SEL _cmd)
    {
        return @"HELLO WORLD!";
    }
    
    Method *description = [NSObject rt_methodForSelector: @selector(description)];
    [description setImplementation: (IMP)NewDescription];

You can create new classes using `+rt_createSubclassNamed:` or `+rt_createUnregisteredSubclassNamed:`. Note that if you want to add instance variables to a class then you have to use the Unregistered version, and add them before registering the class.

Objects
-------

Two instance methods are provided as well. `-rt_class` exists because Apple likes to fiddle with the return value of `-class`, and `-rt_class` always gives you the right value. `-rt_setClass:` does pretty much what it says: sets the class of the object. It won't reallocate the object or anything, so the new class had better have a memory layout that's compatible with the old one, or else hilarity will ensue.

Sending Messages
----------------

After getting a list of methods from a class, it's common to want to actually use those on instances of the class. `RTMethod` provides an easy method for doing this, as well as several convenience wrappers around it.

The basic method for sending messages is `-[RTMethod returnValue:sendToTarget:]`. You use it like this:

    RTMethod *method = ...;
    SomeType ret;
    [method returnValue: &ret sendToTarget: obj, RTARG(@"hello"), RTARG(42), RTARG(xyz)];

It may seem odd to have the return value at the beginning of the argument list, but this comes closest to the order of the normal `ret = [obj method]` syntax.

All arguments must be wrapped in the `RTARG` macro. This macro takes care of packaging up each argument so that it can survive passage through the variable argument list and also includes some extra metadata about the argument types so that the code can do some basic sanity checking. No automatic type conversions are performed. If you pass a `double` to a method that expects an `int`, this method will `abort`. That checking is only based on size, however, so if you pass a `float` where an `int` is expected, you'll just get a bad value.

Note that while it's not 100% guaranteed, this code does a generally good job of detecting if you forgot to use the `RTARG` macro and warning you loudly and calling `abort` instead of simply crashing in a mysterious manner. Also note that there is no sanity checking on the return value, so it's your responsibility to ensure that you use the right type and have enough space to hold it.

For methods which return an object, the `-[RTMethod sendToTarget:]` method is provided which directly returns `id` instead of making you use return-by-reference. This simplifies the calling of such methods:

    RTMethod *method = ...;
    id ret = [method sendToTarget: obj, RTARG(@"hello"), RTARG(42), RTARG(xyz)];

There is also an `NSObject` category which provides methods that allows you to switch the order around to be more natural. For example:

    RTMethod *method = ...;
    id ret = [obj rt_sendMethod: method, RTARG(@"hello"), RTARG(42), RTARG(xyz)];

And the same idea for `rt_returnValue:sendMethod:`.

Finally, there are a pair of convenience methods that take a selector, and combine the method lookup with the actual message sending:

    id ret = [obj rt_sendSelector: @selector(...), RTARG(@"hello"), RTARG(42), RTARG(xyz)];
    SomeType ret2;
    [obj rt_returnValue: &ret2 sendSelector: @selector(...), RTARG(12345)];
