
#import <Foundation/Foundation.h>
#import <objc/runtime.h>


@class RTClass;
@class RTProtocol;

@interface MARuntime : NSObject
{
}

+ (NSArray *)classes;
+ (NSArray *)rootClasses;
+ (RTClass *)classNamed: (NSString *)name;
- (NSArray *)protocols;
+ (RTProtocol *)protocolNamed: (NSString *)name;


@end
