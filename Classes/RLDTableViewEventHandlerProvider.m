#import "RLDTableViewEventHandlerProvider.h"
#import <objc/runtime.h>

static NSMutableArray *_availableEventHandlerClasses;

#pragma mark - RLDTableViewEventHandlerProvider implementation

@implementation RLDTableViewEventHandlerProvider

#pragma mark - Factory method

+ (id<RLDTableViewGenericEventHandler>)eventHandlerWithTableView:(UITableView *)tableView viewModel:(id<RLDTableViewReusableViewModel>)viewModel view:(UIView *)view {
    id<RLDTableViewGenericEventHandler> eventHandler;
    for (Class eventHandlerClass in [self availableEventHandlerClasses]) {
        if ([eventHandlerClass canHandleTableView:tableView viewModel:viewModel view:view]) {
            eventHandler = [eventHandlerClass new];
            break;
        }
    }
    
    return eventHandler;
}

- (id<RLDTableViewGenericEventHandler>)eventHandlerWithTableView:(UITableView *)tableView viewModel:(id<RLDTableViewReusableViewModel>)viewModel view:(UIView *)view {
    return [[self class] eventHandlerWithTableView:tableView viewModel:viewModel view:view];
}

#pragma mark - Event handler registration

+ (NSArray *)availableEventHandlerClasses {
    if ([_availableEventHandlerClasses count] == 0) [self automaticallyRegisterEventHandlerClasses];
    
    return _availableEventHandlerClasses;
}

+ (void)registerEventHandlerClass:(Class)eventHandlerClass {
    [self addClassToListOfAvailableEventHandlerClasses:eventHandlerClass];
}

+ (void)automaticallyRegisterEventHandlerClasses {
    int classesCount = objc_getClassList(NULL, 0);
    Class *classes = (Class *)malloc(sizeof(Class) *classesCount);
    classesCount = objc_getClassList(classes, classesCount);
    
    for (NSUInteger index = 0; index < classesCount; index++) {
        [self addClassToListOfAvailableEventHandlerClasses:classes[index]];
    }
    free(classes);
}

+ (void)addClassToListOfAvailableEventHandlerClasses:(Class)class {
    if ([self classConformsToEventHandlerProtocol:class]) {
        _availableEventHandlerClasses = _availableEventHandlerClasses ?: [NSMutableArray array];
        
        [_availableEventHandlerClasses addObject:class];
    }
}

+ (BOOL)classConformsToEventHandlerProtocol:(Class)class {
    // class_conformsToProtocol is not recursive!
    BOOL classIsEventHandler = class_conformsToProtocol(class, @protocol(RLDTableViewGenericEventHandler));
    if (classIsEventHandler) return YES;
    
    Class superclass = class_getSuperclass(class);
    return (superclass
            ? [self classConformsToEventHandlerProtocol:superclass]
            : NO);
}

@end