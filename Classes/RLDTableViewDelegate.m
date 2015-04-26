#import "RLDTableViewDelegate.h"

#import "RLDTableViewModelProtocol.h"
#import "RLDTableViewEventHandlerProtocol.h"
#import "RLDHandledViewProtocol.h"
#import "NSObject+Accessors.h"

@implementation RLDTableViewDelegate

#pragma mark - Display customization

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [NSObject performSelector:@selector(willDisplayView) withTarget:^NSObject *{
        id<RLDTableViewCellEventHandler>eventHandler = [self cellEventHandlerWithIndexPath:indexPath tableView:tableView cell:cell];
        [self linkEventHandler:eventHandler withView:cell];
        return eventHandler;
    }];
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    [NSObject performSelector:@selector(willDisplayView) withTarget:^NSObject *{
        id<RLDTableViewSectionAccessoryViewEventHandler> eventHandler = [self headerEventHandlerWithSection:section tableView:tableView view:view];
        [self linkEventHandler:eventHandler withView:view];
        return eventHandler;
    }];
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    [NSObject performSelector:@selector(willDisplayView) withTarget:^NSObject *{
        id<RLDTableViewSectionAccessoryViewEventHandler> eventHandler = [self footerEventHandlerWithSection:section tableView:tableView view:view];
        [self linkEventHandler:eventHandler withView:view];
        return eventHandler;
    }];
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath {
    [self performSelector:@selector(didEndDisplayingView) withCellEventHandlerWithIndexPath:indexPath tableView:tableView cell:cell];
}

- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section {
    [NSObject performSelector:@selector(didEndDisplayingView) withTarget:^NSObject *{
        return [self headerEventHandlerWithSection:section tableView:tableView view:view];
    }];
}

- (void)tableView:(UITableView *)tableView didEndDisplayingFooterView:(UIView *)view forSection:(NSInteger)section {
    [NSObject performSelector:@selector(didEndDisplayingView) withTarget:^NSObject *{
        return [self footerEventHandlerWithSection:section tableView:tableView view:view];
    }];
}

#pragma mark - Variable height support

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height;
    [[self tableViewModel:self.tableViewModel cellModelAtIndexPath:indexPath valueForSelector:@selector(height)] getValue:&height];
    if (height < 1) height = UITableViewAutomaticDimension;
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat height;
    [[self tableViewModel:self.tableViewModel headerModelForSection:section valueForSelector:@selector(height)] getValue:&height];
    if (height < 1) height = UITableViewAutomaticDimension;
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    CGFloat height;
    [[self tableViewModel:self.tableViewModel footerModelForSection:section valueForSelector:@selector(height)] getValue:&height];
    if (height < 1) height = UITableViewAutomaticDimension;
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat estimatedHeight;
    [[self tableViewModel:self.tableViewModel cellModelAtIndexPath:indexPath valueForSelector:@selector(estimatedHeight)] getValue:&estimatedHeight];
    if (estimatedHeight < 1) estimatedHeight = UITableViewAutomaticDimension;
    return estimatedHeight;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section {
    CGFloat estimatedHeight;
    [[self tableViewModel:self.tableViewModel headerModelForSection:section valueForSelector:@selector(estimatedHeight)] getValue:&estimatedHeight];
    if (estimatedHeight < 1) estimatedHeight = UITableViewAutomaticDimension;
    return estimatedHeight;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section {
    CGFloat estimatedHeight;
    [[self tableViewModel:self.tableViewModel footerModelForSection:section valueForSelector:@selector(estimatedHeight)] getValue:&estimatedHeight];
    if (estimatedHeight < 1) estimatedHeight = UITableViewAutomaticDimension;
    return estimatedHeight;
}

#pragma mark - Section header and footer

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *reuseIdentifier = [self tableViewModel:self.tableViewModel headerModelForSection:section valueForSelector:@selector(reuseIdentifier)];
    
    return (reuseIdentifier != nil
            ? [tableView dequeueReusableHeaderFooterViewWithIdentifier:reuseIdentifier]
            : nil);
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    NSString *reuseIdentifier = [self tableViewModel:self.tableViewModel footerModelForSection:section valueForSelector:@selector(reuseIdentifier)];
    
    return (reuseIdentifier
            ? [tableView dequeueReusableHeaderFooterViewWithIdentifier:reuseIdentifier]
            : nil);
}

#pragma mark - Accessories (disclosures)

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    [self performSelector:@selector(accessoryButtonTapped) withCellEventHandlerWithIndexPath:indexPath tableView:tableView];
}

#pragma mark - Selection

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    NSObject<RLDTableViewCellEventHandler> *eventHandler = [self cellEventHandlerWithIndexPath:indexPath tableView:tableView];
    return ([eventHandler respondsToSelector:@selector(shouldHighlightView)]
            ? [eventHandler shouldHighlightView]
            : NO);
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSelector:@selector(didHighlightView) withCellEventHandlerWithIndexPath:indexPath tableView:tableView];
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSelector:@selector(didUnhighlightView) withCellEventHandlerWithIndexPath:indexPath tableView:tableView];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSelector:@selector(willSelectView) withCellEventHandlerWithIndexPath:indexPath tableView:tableView];
    return indexPath;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSelector:@selector(willDeselectView) withCellEventHandlerWithIndexPath:indexPath tableView:tableView];
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSelector:@selector(didSelectView) withCellEventHandlerWithIndexPath:indexPath tableView:tableView];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSelector:@selector(didDeselectView) withCellEventHandlerWithIndexPath:indexPath tableView:tableView];
}

#pragma mark - Editing

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCellEditingStyle editingStyle;
    
    [[self tableViewModel:self.tableViewModel cellModelAtIndexPath:indexPath valueForSelector:@selector(editingStyle)] getValue:&editingStyle];
    
    return editingStyle;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self tableViewModel:self.tableViewModel cellModelAtIndexPath:indexPath valueForSelector:@selector(titleForDeleteConfirmationButton)];
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self performSelector:@selector(editActions) withCellEventHandlerWithIndexPath:indexPath tableView:tableView];
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL shouldIndentWhileEditing;
    
    [[self tableViewModel:self.tableViewModel cellModelAtIndexPath:indexPath valueForSelector:@selector(shouldIndentWhileEditing)] getValue:&shouldIndentWhileEditing];
    
    return shouldIndentWhileEditing;
}

- (void)tableView:(UITableView*)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSelector:@selector(willBeginEditing) withCellEventHandlerWithIndexPath:indexPath tableView:tableView];
}

- (void)tableView:(UITableView*)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSelector:@selector(didEndEditing) withCellEventHandlerWithIndexPath:indexPath tableView:tableView];
}

#pragma mark - Moving and reordering

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
    return proposedDestinationIndexPath;
}

#pragma mark - Indentation

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger indentationLevel;
    [[self tableViewModel:self.tableViewModel cellModelAtIndexPath:indexPath valueForSelector:@selector(indentationLevel)] getValue:&indentationLevel];
    return indentationLevel;
}

#pragma mark - Copy and Paste

- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL shouldShowMenu;
    [[self tableViewModel:self.tableViewModel cellModelAtIndexPath:indexPath valueForSelector:@selector(shouldShowMenu)] getValue:&shouldShowMenu];
    return shouldShowMenu;
}

- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    NSObject<RLDTableViewCellEventHandler> *eventHandler = [self cellEventHandlerWithIndexPath:indexPath tableView:tableView];
    return ([eventHandler respondsToSelector:@selector(canPerformAction:withSender:)]
            ? [eventHandler canPerformAction:action withSender:sender]
            : NO);
}

- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    NSObject<RLDTableViewCellEventHandler> *eventHandler = [self cellEventHandlerWithIndexPath:indexPath tableView:tableView];
    if ([eventHandler respondsToSelector:@selector(performAction:withSender:)]) {
        [eventHandler performAction:action withSender:sender];
    }
}

#pragma mark - Event handler generation

- (id<RLDTableViewCellEventHandler>)cellEventHandlerWithIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    return [self cellEventHandlerWithIndexPath:indexPath tableView:tableView cell:cell];
}

- (id<RLDTableViewCellEventHandler>)cellEventHandlerWithIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView cell:(UITableViewCell *)cell {
    id<RLDTableViewCellModel> model = [self tableViewModel:self.tableViewModel cellModelAtIndexPath:indexPath];
    id<RLDTableViewCellEventHandler> eventHandler =  (id<RLDTableViewCellEventHandler>)[self eventHandlerWithTableView:tableView viewModel:model view:cell];
    return eventHandler;
}

- (id<RLDTableViewSectionAccessoryViewEventHandler>)headerEventHandlerWithSection:(NSInteger)section tableView:(UITableView *)tableView view:(UIView *)view {
    id<RLDTableViewSectionAccessoryViewModel> model = [self tableViewModel:self.tableViewModel headerModelForSection:section];
    id<RLDTableViewSectionAccessoryViewEventHandler> eventHandler =  (id<RLDTableViewSectionAccessoryViewEventHandler>)[self eventHandlerWithTableView:tableView viewModel:model view:view];
    return eventHandler;
}

- (id<RLDTableViewSectionAccessoryViewEventHandler>)footerEventHandlerWithSection:(NSInteger)section tableView:(UITableView *)tableView view:(UIView *)view {
    id<RLDTableViewSectionAccessoryViewModel> model = [self tableViewModel:self.tableViewModel footerModelForSection:section];
    id<RLDTableViewSectionAccessoryViewEventHandler> eventHandler =  (id<RLDTableViewSectionAccessoryViewEventHandler>)[self eventHandlerWithTableView:tableView viewModel:model view:view];
    return eventHandler;
}

- (id<RLDTableViewGenericEventHandler>)eventHandlerWithTableView:(UITableView *)tableView viewModel:(id<RLDTableViewReusableViewModel>)viewModel view:(UIView *)view {
    id<RLDTableViewGenericEventHandler> eventHandler = ([self reusableEventHandlerWithTableView:tableView viewModel:viewModel view:view]
                                                        ?: [self.eventHandlerProvider eventHandlerWithTableView:tableView viewModel:viewModel view:view]);
    
    [eventHandler setViewModel:viewModel];
    [eventHandler setTableView:tableView];
    [eventHandler setView:view];

    return eventHandler;
}

- (id<RLDTableViewGenericEventHandler>)reusableEventHandlerWithTableView:(UITableView *)tableView viewModel:(id<RLDTableViewReusableViewModel>)viewModel view:(UIView *)view {
    if (![view respondsToSelector:@selector(eventHandler)]) return nil;
    
    id<RLDTableViewGenericEventHandler> eventHandler = [(id<RLDHandledViewProtocol>)view eventHandler];
    
    if (![[eventHandler class] canHandleTableView:tableView viewModel:viewModel view:view]) return nil;
    
    return eventHandler;
}

#pragma mark - Selector performing

- (id)performSelector:(SEL)selector withCellEventHandlerWithIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView {
    return [NSObject performSelector:selector withTarget:^NSObject *{
        return [self cellEventHandlerWithIndexPath:indexPath tableView:tableView];
    }];
}

- (id)performSelector:(SEL)selector withCellEventHandlerWithIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView cell:(UITableViewCell *)cell  {
    return [NSObject performSelector:selector withTarget:^NSObject *{
        return [self cellEventHandlerWithIndexPath:indexPath tableView:tableView cell:cell];
    }];
}

- (void)linkEventHandler:(id<RLDTableViewGenericEventHandler>)eventHandler withView:(UIView *)view {
    if ([view conformsToProtocol:@protocol(RLDHandledViewProtocol)]) {
        [(id<RLDHandledViewProtocol>)view setEventHandler:eventHandler];
    }
}

@end