#import "TestHelpers.h"

#pragma mark - RLDTestTableViewCell implementation

@implementation RLDTestTableViewCell

@end

#pragma mark - RLDTestCellModel implementation

@implementation RLDTestCellModel

- (NSString *)reuseIdentifier {
    return NSStringFromClass([self class]);
}

@end

#pragma mark - RLDSecondTestCellModel implementation

@implementation RLDSecondTestCellModel

@end

#pragma mark - RLDTestEventHandler implementation

static NSMutableDictionary *_canHandleDictionary;

@interface RLDTestEventHandler ()

@property (nonatomic, copy) NSMutableSet *forwardedInvocations;

@end

@implementation RLDTestEventHandler

+ (BOOL)canHandleTableView:(UITableView *)tableView viewModel:(id<NSObject>)viewModel view:(UIView *)view {
    canHandleBlockType canHandleBlock = _canHandleDictionary[NSStringFromClass(self)];
    return canHandleBlock(viewModel, tableView, view);
}

+ (void)load {
    if (!_canHandleDictionary) _canHandleDictionary = [NSMutableDictionary dictionary];
    
    [self setCanHandle:^BOOL(id<NSObject> model, UITableView *tableView, UIView *view) {
        return YES;
    }];
}

+ (void)setCanHandle:(canHandleBlockType)canHandleBlock {
    _canHandleDictionary[NSStringFromClass(self)] = [canHandleBlock copy];
}

+ (void)reset {
    [_canHandleDictionary removeAllObjects];
}

#pragma mark - Selector checking

- (NSInvocation *)invocationForPerformedSelector:(SEL)selector {
    NSSet *invocations = [self.forwardedInvocations objectsPassingTest:^BOOL(NSInvocation *invocation, BOOL *stop) {
        BOOL found = [NSStringFromSelector(invocation.selector) isEqualToString:NSStringFromSelector(selector)];
        stop = &found;
        return found;
    }];
    return [invocations anyObject];
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    return YES;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    [self.forwardedInvocations addObject:anInvocation];
}

- (NSMutableSet *)forwardedInvocations {
    if (!_forwardedInvocations) {
        _forwardedInvocations = [NSMutableSet set];
    }
    return _forwardedInvocations;
}

@end

#pragma mark - RLDSecondTestEventHandler implementation

@implementation RLDSecondTestEventHandler

@end

#pragma mark - RLDTestEventHandlerProvider implementation

@implementation RLDTestEventHandlerProvider

- (id<RLDTableViewGenericEventHandler>)eventHandlerWithTableView:(UITableView *)tableView viewModel:(id<NSObject>)viewModel view:(UIView *)view {
    return self.eventHandlerToProvide;
}

@end

#pragma mark - RLDTestAccessoryView implementation

@implementation RLDTestAccessoryView

@end