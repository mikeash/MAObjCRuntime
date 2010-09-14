
#import <Foundation/Foundation.h>
#import <objc/runtime.h>


@interface RTMethod : NSObject
{
}

+ (id)methodWithObjCMethod: (Method)method;

- (id)initWithObjCMethod: (Method)method;

- (SEL)selector;
- (IMP)implementation;
- (NSMethodSignature *)signature;

@end
