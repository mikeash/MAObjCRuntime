
#import "MARTNSObject.h"

#import <objc/runtime.h>

#import "RTIvar.h"
#import "RTMethod.h"
#import "RTUnregisteredClass.h"


@implementation NSObject (MARuntime)

+ (NSArray *)rt_subclasses
{
    Class *buffer = NULL;
    
    int count, size;
    do
    {
        count = objc_getClassList(NULL, 0);
        buffer = realloc(buffer, count * sizeof(*buffer));
        size = objc_getClassList(buffer, count);
    } while(size != count);
    
    NSMutableArray *array = [NSMutableArray array];
    for(int i = 0; i < count; i++)
    {
        Class candidate = buffer[i];
        Class superclass = candidate;
        while(superclass)
        {
            if(superclass == self)
            {
                [array addObject: candidate];
                break;
            }
            superclass = class_getSuperclass(superclass);
        }
    }
    free(buffer);
    return array;
}

+ (RTUnregisteredClass *)rt_createUnregisteredSubclassNamed: (NSString *)name
{
    Class c = objc_allocateClassPair(self, [name UTF8String], 0);
    return [RTUnregisteredClass unregisteredClassWithClass: c];
}

+ (Class)rt_createSubclassNamed: (NSString *)name
{
    return [[self rt_createUnregisteredSubclassNamed: name] registerClass];
}

+ (void)rt_destroyClass
{
    objc_disposeClassPair(self);
}

+ (BOOL)rt_isMetaClass
{
    return class_isMetaClass(self);
}

#ifdef __clang__
#pragma clang diagnostic push
#endif
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
+ (Class)rt_setSuperclass: (Class)newSuperclass
{
    class_setSuperclass(self, newSuperclass);
}
#ifdef __clang__
#pragma clang diagnostic pop
#endif

+ (size_t)rt_instanceSize
{
    return class_getInstanceSize(self);
}

+ (NSArray *)rt_methods
{
    unsigned int count;
    Method *methods = class_copyMethodList(self, &count);
    
    NSMutableArray *array = [NSMutableArray array];
    for(unsigned i = 0; i < count; i++)
        [array addObject: [RTMethod methodWithObjCMethod: methods[i]]];
    
    return array;
}

+ (RTMethod *)rt_methodForSelector: (SEL)sel
{
    Method m = class_getInstanceMethod(self, sel);
    if(!m) return nil;
    
    return [RTMethod methodWithObjCMethod: m];
}

+ (void)rt_addMethod: (RTMethod *)method
{
    class_addMethod(self, [method selector], [method implementation], [[method signature] UTF8String]);
}

+ (NSArray *)rt_ivars
{
    unsigned int count;
    Ivar *list = class_copyIvarList(self, &count);
    
    NSMutableArray *array = [NSMutableArray array];
    for(unsigned i = 0; i < count; i++)
        [array addObject: [RTIvar ivarWithObjCIvar: list[i]]];
    
    return array;
}

+ (RTIvar *)rt_ivarForName: (NSString *)name
{
    Ivar ivar = class_getInstanceVariable(self, [name UTF8String]);
    if(!ivar) return nil;
    return [RTIvar ivarWithObjCIvar: ivar];
}

- (Class)rt_class
{
    return object_getClass(self);
}

- (Class)rt_setClass: (Class)newClass
{
    object_setClass(self, newClass);
}

@end

