#import "Test_iOS.h"
#include "main.m"

@implementation Test_iOS

- (void)testAll
{
    BOOL failed = main(0, nil);
    STAssertFalse(failed, @"Tests failed!");
}

@end
