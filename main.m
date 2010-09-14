// gcc -framework Foundation main.m MARTNSObject.m

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

int main(int argc, char **argv)
{
    @try
    {
        WithPool(^{
            TEST(TestSubclasses);
            
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
