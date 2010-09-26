
#import <Foundation/Foundation.h>
#import <objc/runtime.h>


@interface MARuntime : NSObject
{
}

+ (NSArray *)classes;
+ (NSArray *)rootClasses;
+ (Class)classNamed: (NSString *)name;

@end
