// gcc -framework Foundation --std=c99 main.m MARTNSObject.m RTMethod.m

#import "MARTNSObject.h"
#import "RTMethod.h"


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
    [obj release];
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
