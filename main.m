// gcc -framework Foundation --std=c99 main.m MARTNSObject.m RTProtocol.m RTMethod.m RTIvar.m RTProperty.m RTUnregisteredClass.m

#import "MARTNSObject.h"
#import "RTProtocol.h"
#import "RTIvar.h"
#import "RTProperty.h"
#import "RTMethod.h"
#import "RTUnregisteredClass.h"


static void WithPool(void (^block)(void))
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    block();
    [pool release];
}

static int gFailureCount;

void Test(void (*func)(void), const char *name)
{
    WithPool(^{
        int failureCount = gFailureCount;
        NSLog(@"Testing %s", name);
        func();
        NSLog(@"%s: %s", name, failureCount == gFailureCount ? "SUCCESS" : "FAILED");
    });
}

#define TEST(func) Test(func, #func)

#define TEST_ASSERT(cond, ...) do { \
    if(!(cond)) { \
        gFailureCount++; \
        NSString *message = [NSString stringWithFormat: @"" __VA_ARGS__]; \
        NSLog(@"%s:%d: assertion failed: %s %@", __func__, __LINE__, #cond, message); \
    } \
} while(0)

static void TestSubclasses(void)
{
    NSArray *subs = [NSObject rt_subclasses];
    TEST_ASSERT([subs containsObject: [NSString class]]);
    TEST_ASSERT([subs containsObject: [NSArray class]]);
    TEST_ASSERT([subs containsObject: [NSSet class]]);
    TEST_ASSERT([subs containsObject: [NSObject class]]);
    
    subs = [NSString rt_subclasses];
    TEST_ASSERT([subs containsObject: [NSString class]]);
    TEST_ASSERT(![subs containsObject: [NSObject class]]);
}

static void TestCreateClass(void)
{
    Class subclass = [NSObject rt_createSubclassNamed: @"MATestSubclass"];
    
    TEST_ASSERT(subclass);
    TEST_ASSERT(NSClassFromString(@"MATestSubclass"));
    
    [subclass rt_destroyClass];
}

static void TestMetaclass(void)
{
    Class meta = [NSObject rt_class];
    TEST_ASSERT([meta rt_isMetaClass]);
    TEST_ASSERT(![NSObject rt_isMetaClass]);
}

static void TestSetSuperclass(void)
{
    Class subclass = [NSObject rt_createSubclassNamed: @"MATestSubclass"];
    
    TEST_ASSERT(![subclass isSubclassOfClass: [NSString class]]);
    [subclass rt_setSuperclass: [NSString class]];
    TEST_ASSERT([subclass isSubclassOfClass: [NSString class]]);
    
    [subclass rt_destroyClass];
}

static void TestInstanceSize(void)
{
    TEST_ASSERT([NSObject rt_instanceSize] == sizeof(void *));
}

static void TestSetClass(void)
{
    id obj = [[NSObject alloc] init];
    TEST_ASSERT(![obj isKindOfClass: [NSString class]]);
    [obj rt_setClass: [NSString class]];
    TEST_ASSERT([obj isKindOfClass: [NSString class]]);
    [obj rt_setClass: [NSObject class]];
    TEST_ASSERT(![obj isKindOfClass: [NSString class]]);
    [obj release];
}

static void TestMethodList(void)
{
    NSArray *methods = [NSObject rt_methods];
    
    SEL sel = @selector(description);
    NSUInteger index = [methods indexOfObjectPassingTest: ^BOOL (id obj, NSUInteger idx, BOOL *stop) {
        return [obj selector] == sel;
    }];
    TEST_ASSERT(index < [methods count]);
    
    RTMethod *method = [methods objectAtIndex: index];
    TEST_ASSERT([method implementation] == [NSObject instanceMethodForSelector: sel]);
    TEST_ASSERT([[NSMethodSignature signatureWithObjCTypes: [[method signature] UTF8String]] isEqual: [NSObject instanceMethodSignatureForSelector: sel]]);
}

static void TestMethodFetching(void)
{
    SEL sel = @selector(description);
    RTMethod *method = [NSObject rt_methodForSelector: sel];
    TEST_ASSERT([method implementation] == [NSObject instanceMethodForSelector: sel]);
    TEST_ASSERT([[NSMethodSignature signatureWithObjCTypes: [[method signature] UTF8String]] isEqual: [NSObject instanceMethodSignatureForSelector: sel]]);
}

static bool gAddMethodFlag;

@interface NSObject (AddMethodDecl)

- (void)rt_addMethodTester;

@end

static void AddMethodTester(id self, SEL _cmd)
{
    gAddMethodFlag = YES;
}

static void TestAddMethod(void)
{
    gAddMethodFlag = NO;
    
    id obj = [[NSObject alloc] init];
    [NSObject rt_addMethod: [RTMethod methodWithSelector: @selector(rt_addMethodTester) implementation: (IMP)AddMethodTester signature: @"v@:"]];
    [obj rt_addMethodTester];
    TEST_ASSERT(gAddMethodFlag);
    [obj release];
}

static void TestSetMethod(void)
{
    gAddMethodFlag = NO;
    
    id obj = [[NSObject alloc] init];
    RTMethod *method = [NSObject rt_methodForSelector: @selector(finalize)];
    IMP oldImp = [method implementation];
    [method setImplementation: (IMP)AddMethodTester];
    [obj finalize];
    TEST_ASSERT(gAddMethodFlag);
    [method setImplementation: oldImp];
    [obj release];
}

@protocol SampleProtocol <NSObject>
+ (void)requiredClassMethod;
- (void)requiredInstanceMethod;
@optional
+ (void)optionalClassMethod;
- (void)optionalInstanceMethod;
@end
@interface SampleClass : NSObject <SampleProtocol>
{
    id someIvar;
}
@property (assign, getter=customGetter) id someProperty;
@end
@implementation SampleClass
@synthesize someProperty=someIvar;
+ (void)requiredClassMethod
{
    return;
}
- (void)requiredInstanceMethod
{
    return;
}
@end

static void TestProtocolQuery(void)
{
    NSArray *protocols = [SampleClass rt_protocols];
    TEST_ASSERT([[protocols valueForKey: @"name"] containsObject: @"SampleProtocol"]);
    
    Protocol *protocol = [RTProtocol protocolWithObjCProtocol: NSProtocolFromString(@"SampleProtocol")];
    TEST_ASSERT([[protocol incorporatedProtocols] containsObject: [RTProtocol protocolWithObjCProtocol: NSProtocolFromString(@"NSObject")]]);
    TEST_ASSERT([[[protocol methodsRequired: YES instance: YES] valueForKey: @"selectorName"] containsObject: @"requiredInstanceMethod"]);
    TEST_ASSERT([[[protocol methodsRequired: YES instance: NO] valueForKey: @"selectorName"] containsObject: @"requiredClassMethod"]);
    TEST_ASSERT([[[protocol methodsRequired: NO instance: YES] valueForKey: @"selectorName"] containsObject: @"optionalInstanceMethod"]);
    TEST_ASSERT([[[protocol methodsRequired: NO instance: NO] valueForKey: @"selectorName"] containsObject: @"optionalClassMethod"]);
}

static void TestIvarQuery(void)
{
    NSArray *ivars = [SampleClass rt_ivars];
    TEST_ASSERT([[ivars valueForKey: @"name"] containsObject: @"someIvar"]);
    
    RTIvar *ivar = [SampleClass rt_ivarForName: @"someIvar"];
    TEST_ASSERT([[ivar name] isEqual: @"someIvar"]);
    TEST_ASSERT([[ivar typeEncoding] isEqual: [NSString stringWithUTF8String: @encode(id)]]);
    TEST_ASSERT([ivar offset] == sizeof(id));
}

static void TestPropertyQuery(void)
{
    NSArray *properties = [SampleClass rt_properties];
    TEST_ASSERT([[properties valueForKey: @"name"] containsObject: @"someProperty"]);
    
    RTProperty *property = [SampleClass rt_propertyForName: @"someProperty"];
    TEST_ASSERT([[property name] isEqual: @"someProperty"]);
    TEST_ASSERT([property customGetter] == @selector(customGetter));
    TEST_ASSERT([[property typeEncoding] isEqual: [NSString stringWithUTF8String: @encode(id)]]);
    TEST_ASSERT([[property ivarName] isEqual: @"someIvar"]);
}

#if __MAC_OS_X_VERSION_MIN_REQUIRED >= 1070
static void TestAddProperty(void)
{
    RTUnregisteredClass *unreg = [NSObject rt_createUnregisteredSubclassNamed: @"TestAddPropertyClass"];
    RTIvar *ivar = [RTIvar ivarWithName: @"assignedIvar" encode: @encode(id)];
    [unreg addIvar:ivar];
    Class c = [unreg registerClass];
    
    RTProperty *assignedObjectProp = [RTProperty propertyWithName:@"assignedObjectProp"
                                                       attributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                   [ivar typeEncoding], RTPropertyTypeEncodingAttribute,
                                                                   [ivar name], RTPropertyBackingIVarNameAttribute,
                                                                   nil]];
    [c rt_addProperty:assignedObjectProp];
    
    {{
        NSArray *properties = [c rt_properties];
        TEST_ASSERT([[properties valueForKey: @"name"] containsObject: @"assignedObjectProp"]);
        
        RTProperty *property = [c rt_propertyForName: @"assignedObjectProp"];
        TEST_ASSERT([[property name] isEqual: @"assignedObjectProp"]);
        TEST_ASSERT([[property typeEncoding] isEqual: [NSString stringWithUTF8String: @encode(id)]]);
        TEST_ASSERT([[property ivarName] isEqual: @"assignedIvar"]);
        TEST_ASSERT([property setterSemantics] == RTPropertySetterSemanticsAssign);
    }}
}
#endif

static void TestIvarAdd(void)
{
    RTUnregisteredClass *unreg = [NSObject rt_createUnregisteredSubclassNamed: @"IvarAddTester"];
    
    [unreg addIvar: [RTIvar ivarWithName: @"testVar" encode: @encode(void *)]];
    Class c = [unreg registerClass];
    
    TEST_ASSERT([[c rt_ivars] count] == 1);
    TEST_ASSERT([c rt_instanceSize] == 2 * sizeof(void *));
    TEST_ASSERT([[c rt_ivarForName: @"testVar"] offset] == sizeof(void *));
    
    [c rt_destroyClass];
}

static void TestEquality(void)
{
    NSMutableSet *set = [NSMutableSet set];
    [set addObject: [NSObject rt_methodForSelector: @selector(description)]];
    TEST_ASSERT([set count] == 1);
    [set addObject: [NSObject rt_ivarForName: @"isa"]];
    TEST_ASSERT([set count] == 2);
    [set addObject: [NSObject rt_methodForSelector: @selector(description)]];
    TEST_ASSERT([set count] == 2);
    [set addObject: [NSObject rt_ivarForName: @"isa"]];
    TEST_ASSERT([set count] == 2);
}

static void TestMessageSending(void)
{
    id obj1 = [[[NSObject rt_class] rt_methodForSelector: @selector(alloc)] sendToTarget: [NSObject class]];
    id obj2;
    [[[NSObject rt_class] rt_methodForSelector: @selector(alloc)] returnValue: &obj2 sendToTarget: [NSObject class]];
    
    TEST_ASSERT(obj1);
    TEST_ASSERT(obj2);
    
    BOOL equal;
    [[NSObject rt_methodForSelector: @selector(isEqual:)] returnValue: &equal sendToTarget: obj1, RTARG(obj1)];
    TEST_ASSERT(equal);
    [[NSObject rt_methodForSelector: @selector(isEqual:)] returnValue: &equal sendToTarget: obj1, RTARG(obj2)];
    TEST_ASSERT(!equal);
    
    [obj1 release];
    [obj2 release];
}

static void TestMessageSendingNSObjectCategory(void)
{
    id obj1 = [NSObject rt_sendMethod: [[NSObject rt_class] rt_methodForSelector: @selector(alloc)]];
    id obj2;
    [NSObject rt_returnValue: &obj2 sendMethod: [[NSObject rt_class] rt_methodForSelector: @selector(alloc)]];
    
    TEST_ASSERT(obj1);
    TEST_ASSERT(obj2);
    
    BOOL equal;
    [obj1 rt_returnValue: &equal sendMethod: [NSObject rt_methodForSelector: @selector(isEqual:)], RTARG(obj1)];
    TEST_ASSERT(equal);
    [obj1 rt_returnValue: &equal sendMethod: [NSObject rt_methodForSelector: @selector(isEqual:)], RTARG(obj2)];
    TEST_ASSERT(!equal);
    
    [obj1 release];
    [obj2 release];
    
    obj1 = [NSObject rt_sendSelector: @selector(alloc)];
    [NSObject rt_returnValue: &obj2 sendSelector: @selector(alloc)];
    
    TEST_ASSERT(obj1);
    TEST_ASSERT(obj2);
    
    [obj1 rt_returnValue: &equal sendSelector: @selector(isEqual:), RTARG(obj1)];
    TEST_ASSERT(equal);
    [obj1 rt_returnValue: &equal sendSelector: @selector(isEqual:), RTARG(obj2)];
    TEST_ASSERT(!equal);
    
    [obj1 release];
    [obj2 release];
}

int main(int argc, char **argv)
{
    @try
    {
        WithPool(^{
            TEST(TestSubclasses);
            TEST(TestCreateClass);
            TEST(TestMetaclass);
            TEST(TestSetSuperclass);
            TEST(TestInstanceSize);
            TEST(TestSetClass);
            TEST(TestMethodList);
            TEST(TestAddMethod);
            TEST(TestMethodFetching);
            TEST(TestSetMethod);
            TEST(TestProtocolQuery);
            TEST(TestIvarQuery);
            TEST(TestPropertyQuery);
#if __MAC_OS_X_VERSION_MIN_REQUIRED >= 1070
            TEST(TestAddProperty);
#endif
            TEST(TestIvarAdd);
            TEST(TestEquality);
            TEST(TestMessageSending);
            TEST(TestMessageSendingNSObjectCategory);
            
            NSString *message;
            if(gFailureCount)
                message = [NSString stringWithFormat: @"FAILED: %d total assertion failure%s", gFailureCount, gFailureCount > 1 ? "s" : ""];
            else
                message = @"SUCCESS";
            NSLog(@"Tests complete: %@", message);
        });
    }
    @catch(id exception)
    {
        NSLog(@"FAILED: exception: %@", exception);
    }
}
