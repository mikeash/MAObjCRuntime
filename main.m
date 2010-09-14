// gcc -framework Foundation --std=c99 main.m MARTNSObject.m

#import "MARTNSObject.h"

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

int main(int argc, char **argv)
{
    @try
    {
        WithPool(^{
            TEST(TestSubclasses);
            TEST(TestCreateClass);
            TEST(TestMetaclass);
            TEST(TestSetSuperclass);
            
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
