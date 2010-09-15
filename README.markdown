MAObjCRuntime
-------------

MAObjCRuntime is an ObjC wrapper around the Objective-C runtime APIs. If that's confusing, it provides a nice object-oriented interface around (some of) the C functions in /usr/include/objc.

Quick Start
-----------

The action begins in MARTNSObject.h. Various methods are added to NSObject to allow querying and manipulation. Most of these are class methods, because they operate on classes. There are a couple of instance methods as well. All of these methods start with "rt_" to avoid name conflicts. The RTMethod and RTIvar classes are used to represent a single method and a single instance variable, respectively. Their use should be fairly obvious.

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

You can add new methods using +rt_addMethod:. You can modify the implementation of an existing method using the -setImplementation: method on RTMethod. Example:

    // swizzle out -[NSObject description] (don't do this)
    static NSString *NewDescription(id self, SEL _cmd)
    {
        return @"HELLO WORLD!";
    }
    
    Method *description = [NSObject rt_methodForSelector: @selector(description)];
    [description setImplementation: (IMP)NewDescription];

You can create new classes using +rt_createSubclassNamed: or +rt_createUnregisteredSubclassNamed:. Note that if you want to add instance variables to a class then you have to use the Unregistered version, and add them before registering the class.

Objects
-------

Two instance methods are provided as well. -rt_class exists because Apple likes to fiddle with the return value of -class, and -rt_class always gives you the right value. -rt_setClass: does pretty much what it says: sets the class of the object. It won't reallocate the object or anything, so the new class had better have a memory layout that's compatible with the old one, or else hilarity will ensue.
