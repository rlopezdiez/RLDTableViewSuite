#import "RLDTableViewEventHandlerProtocol.h"

@interface RLDTableViewEventHandlerProvider : NSObject<RLDTableViewEventHandlerProvider>

+ (void)registerEventHandlerClass:(Class)eventHandlerClass;
+ (NSSet *)availableEventHandlerClasses;

@end