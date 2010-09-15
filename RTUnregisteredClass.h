
#import <Foundation/Foundation.h>


@class RTIvar;
@class RTMethod;

@interface RTUnregisteredClass : NSObject
{
    Class _class;
}

+ (id)unregisteredClassWithClass: (Class)c;

- (id)initWithClass: (Class)c;

- (void)addIvar: (RTIvar *)ivar;
- (void)addMethod: (RTMethod *)method;

- (Class)registerClass;

@end
