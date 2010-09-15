
#import <Foundation/Foundation.h>
#import <objc/runtime.h>


@interface RTMethod : NSObject
{
}

+ (id)methodWithObjCMethod: (Method)method;
+ (id)methodWithSelector: (SEL)sel implementation: (IMP)imp signature: (NSString *)signature;

- (id)initWithObjCMethod: (Method)method;
- (id)initWithSelector: (SEL)sel implementation: (IMP)imp signature: (NSString *)signature;

- (SEL)selector;
- (IMP)implementation;
- (NSString *)signature;

// for ObjC method instances, sets the underlying implementation
// for selector/implementation/signature instances, just changes the pointer
- (void)setImplementation: (IMP)newImp;

@end
