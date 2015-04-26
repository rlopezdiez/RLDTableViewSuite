#import "RLDTableViewEventHandlerProtocol.h"

@interface RLDTableViewEventHandlerProvider : NSObject<RLDTableViewEventHandlerProvider>

+ (void)registerEventHandlerClass:(Class)eventHandlerClass;
+ (NSArray *)availableEventHandlerClasses;

@end