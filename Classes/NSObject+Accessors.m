#import "NSObject+Accessors.h"

#import "RLDTableViewModelProtocol.h"

#pragma mark - NSObject categories implementation

@implementation NSObject (RLDArbitraryAccessor)

+ (id)performSelector:(SEL)selector withTarget:(NSObject *(^)())targetBlock {
    NSParameterAssert(targetBlock);

    NSObject *target = targetBlock();
    if (![target respondsToSelector:selector]) return nil;

    return [target valueForSelector:selector];
}

- (id)valueForSelector:(SEL)selector {
    if (![self respondsToSelector:selector]) return nil;

    NSMethodSignature *methodSignature = [self methodSignatureForSelector:selector];
    
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
    invocation.target = self;
    invocation.selector = selector;
    [invocation invoke];
    
    NSUInteger methodReturnLength = [methodSignature methodReturnLength];
    if (methodReturnLength == 0) return nil;

    const char *methodReturnType = [methodSignature methodReturnType];
    if (strcmp(methodReturnType, @encode(id)) == 0) {
        __unsafe_unretained id returnValue = nil;
        [invocation getReturnValue:&returnValue];
        return returnValue;
    } else {
        void *returnBuffer = malloc(methodReturnLength);
        [invocation getReturnValue:returnBuffer];
        NSValue *returnValue = [NSValue valueWithBytes:returnBuffer objCType:methodReturnType];
        free(returnBuffer);
        return returnValue;
    }
}

@end

@implementation NSObject (RLDTableViewModelAccessors)

- (id<RLDTableViewCellModel>)tableViewModel:(id<RLDTableViewModel>)tableViewModel cellModelAtIndexPath:(NSIndexPath *)indexPath {
    id<RLDTableViewSectionModel> sectionModel = [self tableViewModel:tableViewModel sectionModelAtIndex:indexPath.section];
    return [sectionModel.cellModels objectOrNilAtIndex:indexPath.row];
}

- (id<RLDTableViewSectionModel>)tableViewModel:(id<RLDTableViewModel>)tableViewModel sectionModelAtIndex:(NSInteger)index {
    return [tableViewModel.sectionModels objectOrNilAtIndex:index];
}

- (id<RLDTableViewSectionAccessoryViewModel>)tableViewModel:(id<RLDTableViewModel>)tableViewModel headerModelForSection:(NSInteger)section {
    return [self tableViewModel:tableViewModel sectionModelAtIndex:section valueForSelector:@selector(header)];
}

- (id<RLDTableViewSectionAccessoryViewModel>)tableViewModel:(id<RLDTableViewModel>)tableViewModel footerModelForSection:(NSInteger)section {
    return [self tableViewModel:tableViewModel sectionModelAtIndex:section valueForSelector:@selector(footer)];
}

- (id)tableViewModel:(NSObject<RLDTableViewModel> *)tableViewModel valueForSelector:(SEL)selector {
    return [tableViewModel valueForSelector:selector];
}

- (id)tableViewModel:(id<RLDTableViewModel>)tableViewModel cellModelAtIndexPath:(NSIndexPath *)indexPath valueForSelector:(SEL)selector {
    id cellModel = [self tableViewModel:tableViewModel cellModelAtIndexPath:indexPath];
    return [cellModel valueForSelector:selector];
}

- (id)tableViewModel:(id<RLDTableViewModel>)tableViewModel headerModelForSection:(NSInteger)section valueForSelector:(SEL)selector {
    id header = [self tableViewModel:tableViewModel headerModelForSection:section];
    return [header valueForSelector:selector];
}

- (id)tableViewModel:(id<RLDTableViewModel>)tableViewModel footerModelForSection:(NSInteger)section valueForSelector:(SEL)selector {
    id footer = [self tableViewModel:tableViewModel footerModelForSection:section];
    return [footer valueForSelector:selector];
}

- (id)tableViewModel:(id<RLDTableViewModel>)tableViewModel sectionModelAtIndex:(NSInteger)index valueForSelector:(SEL)selector {
    id sectionModel = [self tableViewModel:tableViewModel sectionModelAtIndex:index];
    return [sectionModel valueForSelector:selector];
}

@end

#pragma mark - NSArray category implementation

@implementation NSArray (RLDSafeAccessor)

- (id)objectOrNilAtIndex:(NSUInteger)index {
    return ([self count] > index ? self[index] : nil);
}

@end