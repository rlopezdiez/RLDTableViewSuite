#import <XCTest/XCTest.h>

// SUT
#import "RLDTableViewDelegate.h"

// Collaborators
#import "RLDTableViewDataSource.h"
#import "RLDTableViewModel.h"
#import "RLDTableViewEventHandlerProvider.h"
#import "TestHelpers.h"

#define AssertEventHandlerSelectorCalled(selector) \
XCTAssertNotNil([eventHandler invocationForPerformedSelector:selector]);

@interface RLDTableViewDelegateTests : XCTestCase {
    // SUT
    RLDTableViewDelegate *tableViewDelegate;
    
    // Collaborators
    RLDTestEventHandler *eventHandler;
    RLDTestEventHandlerProvider *eventHandlerProvider;
    
    UITableView *tableView;
    UITableViewCell *cell;
    RLDTestAccessoryView *view;
    NSIndexPath *indexPath;
}

@end

@implementation RLDTableViewDelegateTests

- (void)setUp {
    [super setUp];
    
    // GIVEN:
    //   A table view delegate
    //   An event handler
    //     capable to handle any model, table view and view
    //   An event handler provider
    //     which will return the event handler for every configuration
    //     set as the event handler provider of the table view delegate
    //   A table view, a header/footer view, a cell and an index path
    tableViewDelegate = [RLDTableViewDelegate new];

    eventHandler = [RLDTestEventHandler new];
    
    eventHandlerProvider = [RLDTestEventHandlerProvider new];
    eventHandlerProvider.eventHandlerToProvide = eventHandler;
    tableViewDelegate.eventHandlerProvider = eventHandlerProvider;
    
    tableView = [UITableView new];
    view = [RLDTestAccessoryView new];
    cell = [UITableViewCell new];
    indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
}

#pragma mark - Display customization test cases

- (void)testWillDisplayCell {
    // WHEN:
    //   We inform the delegate that the table view will display the cell for a row at the index path
    [tableViewDelegate tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    
    // THEN:
    //   The willDisplayView method of the event handler will be called
    AssertEventHandlerSelectorCalled(@selector(willDisplayView));
}

- (void)testWillDisplayHeaderView {
    // WHEN:
    //   We inform the delegate that the table view will display the header view of a section
    [tableViewDelegate tableView:tableView willDisplayHeaderView:view forSection:indexPath.section];
    
    // THEN:
    //   The willDisplayView method of the event handler will be called
    AssertEventHandlerSelectorCalled(@selector(willDisplayView));
}

- (void)testWillDisplayFooterView {
    // WHEN:
    //   We inform the delegate that the table view will display the footer view of a section
    [tableViewDelegate tableView:tableView willDisplayFooterView:view forSection:indexPath.section];
    
    // THEN:
    //   The willDisplayView method of the event handler will be called
    AssertEventHandlerSelectorCalled(@selector(willDisplayView));
}

- (void)testDidEndDisplayingCell {
    // WHEN:
    //   We inform the delegate that the table view did end displaying the cell for a row at the index path
    [tableViewDelegate tableView:tableView didEndDisplayingCell:cell forRowAtIndexPath:indexPath];
    
    // THEN:
    //   The didEndDisplayingView method of the event handler will be called
    AssertEventHandlerSelectorCalled(@selector(didEndDisplayingView));
}

- (void)testDidEndDisplayingHeaderView {
    // WHEN:
    //   We inform the delegate that the table view did end displaying the header view of a section
    [tableViewDelegate tableView:tableView didEndDisplayingHeaderView:view forSection:indexPath.section];
    
    // THEN:
    //   The didEndDisplayingView method of the event handler will be called
    AssertEventHandlerSelectorCalled(@selector(didEndDisplayingView));
}

- (void)testDidEndDisplayingFooterView {
    // WHEN:
    //   We inform the delegate that the table view did end displaying the footer view of a section
    [tableViewDelegate tableView:tableView didEndDisplayingFooterView:view forSection:indexPath.section];
    
    // THEN:
    //   The didEndDisplayingView method of the event handler will be called
    AssertEventHandlerSelectorCalled(@selector(didEndDisplayingView));
}

#pragma mark - Section header and footer reusing test cases

- (void)testHeaderReusing {
    // GIVEN:
    //   A table view data model
    //     with an automatically created section model
    //       with a cell model assigned to it
    //     set as the model of the table view delegate
    //   A header data model
    //     with a certain reuse identifier
    //       registered with the table view with a certain view class
    //     assigned as the header of the section model
    RLDTableViewModel *dataModel = [RLDTableViewModel new];
    [dataModel addCellModel:[RLDTableViewCellModel new]];
    tableViewDelegate.tableViewModel = dataModel;
    
    RLDTableViewSectionAccessoryViewModel *headerModel = [RLDTableViewSectionAccessoryViewModel new];
    headerModel.reuseIdentifier = @"HeaderReuseIdentifier";
    [tableView registerClass:[RLDTestAccessoryView class] forHeaderFooterViewReuseIdentifier:headerModel.reuseIdentifier];
    [(RLDTableViewSectionModel *)[dataModel lastSectionModel] setHeader:headerModel];

    // WHEN:
    //   We ask the delegate for a view for the header of the section
    UITableViewHeaderFooterView *sectionHeader = (UITableViewHeaderFooterView *)[tableViewDelegate tableView:tableView viewForHeaderInSection:indexPath.section];
    
    // THEN:
    //   The returned view class must be the same as the registered class
    //   Its reuse identifier must match the one for the header model
    XCTAssertNotNil(sectionHeader);
    XCTAssertEqual([sectionHeader class], [RLDTestAccessoryView class]);
    XCTAssertEqual(sectionHeader.reuseIdentifier, headerModel.reuseIdentifier);
}

- (void)testFooterReusing {
    // GIVEN:
    //   A table view data model
    //     with an automatically created section model
    //       with a cell model assigned to it
    //     set as the model of the table view delegate
    //   A footer data model
    //     with a certain reuse identifier
    //       registered with the table view with a certain view class
    //     assigned as the footer of the section model
    RLDTableViewModel *dataModel = [RLDTableViewModel new];
    [dataModel addCellModel:[RLDTableViewCellModel new]];
    tableViewDelegate.tableViewModel = dataModel;
    
    RLDTableViewSectionAccessoryViewModel *footerModel = [RLDTableViewSectionAccessoryViewModel new];
    footerModel.reuseIdentifier = @"FooterReuseIdentifier";
    [tableView registerClass:[RLDTestAccessoryView class] forHeaderFooterViewReuseIdentifier:footerModel.reuseIdentifier];
    [(RLDTableViewSectionModel *)[dataModel lastSectionModel] setFooter:footerModel];
    
    // WHEN:
    //   We ask the delegate for a view for the footer of the section
    UITableViewHeaderFooterView *sectionFooter = (UITableViewHeaderFooterView *)[tableViewDelegate tableView:tableView viewForFooterInSection:indexPath.section];
    
    // THEN:
    //   The returned view class must be the same as the registered class
    //   Its reuse identifier must match the one for the footer model
    XCTAssertNotNil(sectionFooter);
    XCTAssertEqual([sectionFooter class], [RLDTestAccessoryView class]);
    XCTAssertEqual(sectionFooter.reuseIdentifier, footerModel.reuseIdentifier);
}

#pragma mark - Variable height support test cases

- (void)testVariableHeightForRow {
    // GIVEN:
    //   A table view data model
    //     set as the model of the table view delegate
    //   A cell model
    //     with a certain estimated height
    //     with a certain height
    //     assigned to the table model
    RLDTableViewCellModel *cellModel = [self cellModelInTableViewDataModel];
    cellModel.estimatedHeight = 1;
    cellModel.height = 2;

    // WHEN:
    //   We ask the delegate for
    //     the estimated height of a given cell for a row at the index path
    //     the height of a given cell for a row at the index path
    CGFloat estimatedHeight = [tableViewDelegate tableView:tableView estimatedHeightForRowAtIndexPath:indexPath];
    CGFloat height = [tableViewDelegate tableView:tableView heightForRowAtIndexPath:indexPath];
    
    // THEN:
    //   The returned estimated height must be equal to the height of the cell model
    //   The returned height must be equal to the height of the cell model
    XCTAssertEqual(estimatedHeight, cellModel.estimatedHeight);
    XCTAssertEqual(height, cellModel.height);
}

- (void)testVariableHeightForHeader {
    // GIVEN:
    //   A table view data model
    //     with a cell model assigned to it
    //     set as the model of the table view delegate
    //   An automatically created section model
    //   A header data model
    //     with a certain estimated height
    //     with a certain height
    //     assigned to the section model
    RLDTableViewModel *dataModel = [RLDTableViewModel new];
    [dataModel addCellModel:[RLDTableViewCellModel new]];
    tableViewDelegate.tableViewModel = dataModel;

    RLDTableViewSectionModel *sectionModel = [dataModel lastSectionModel];

    RLDTableViewSectionAccessoryViewModel *headerModel = [RLDTableViewSectionAccessoryViewModel new];
    headerModel.estimatedHeight = 1;
    headerModel.height = 2;
    sectionModel.header = headerModel;
    
    // WHEN:
    //   We ask the delegate for
    //     the estimated height of a given cell for a row at the index path
    //     the height of a given cell for a row at the index path
    CGFloat estimatedHeight = [tableViewDelegate tableView:tableView estimatedHeightForHeaderInSection:indexPath.section];
    CGFloat height = [tableViewDelegate tableView:tableView heightForHeaderInSection:indexPath.section];
    
    // THEN:
    //   The returned estimated height must be equal to the height of the cell model
    //   The returned height must be equal to the height of the cell model
    XCTAssertEqual(estimatedHeight, headerModel.estimatedHeight);
    XCTAssertEqual(height, headerModel.height);
}

- (void)testVariableHeightForFooter {
    // GIVEN:
    //   A table view data model
    //     with a cell model assigned to it
    //     set as the model of the table view delegate
    //   An automatically created section model
    //   A footer data model
    //     with a certain estimated height
    //     with a certain height
    //     assigned to the section model
    RLDTableViewModel *dataModel = [RLDTableViewModel new];
    [dataModel addCellModel:[RLDTableViewCellModel new]];
    tableViewDelegate.tableViewModel = dataModel;
    
    RLDTableViewSectionModel *sectionModel = [dataModel lastSectionModel];
    
    RLDTableViewSectionAccessoryViewModel *footerModel = [RLDTableViewSectionAccessoryViewModel new];
    footerModel.estimatedHeight = 1;
    footerModel.height = 2;
    sectionModel.footer = footerModel;
    
    // WHEN:
    //   We ask the delegate for
    //     the estimated height of a given cell for a row at the index path
    //     the height of a given cell for a row at the index path
    CGFloat estimatedHeight = [tableViewDelegate tableView:tableView estimatedHeightForFooterInSection:indexPath.section];
    CGFloat height = [tableViewDelegate tableView:tableView heightForFooterInSection:indexPath.section];
    
    // THEN:
    //   The returned estimated height must be equal to the height of the cell model
    //   The returned height must be equal to the height of the cell model
    XCTAssertEqual(estimatedHeight, footerModel.estimatedHeight);
    XCTAssertEqual(height, footerModel.height);
}

#pragma mark - Accessories (disclosures)

- (void)testAccessoryButtonTapped {
    // WHEN:
    //   We inform the delegate that the accessory button for a row with a certain index path has been tapped
    [tableViewDelegate tableView:tableView accessoryButtonTappedForRowWithIndexPath:indexPath];
    
    // THEN:
    //   The accessoryButtonTapped method of the event handler will be called
    AssertEventHandlerSelectorCalled(@selector(accessoryButtonTapped));
}

#pragma mark - Selection

- (void)testShouldHighlightRow {
    // WHEN:
    //   We ask the delegate wether a row at a certain index path should be highlighted
    [tableViewDelegate tableView:tableView shouldHighlightRowAtIndexPath:indexPath];
    
    // THEN:
    //   The shouldHighlightView method of the event handler will be called
    AssertEventHandlerSelectorCalled(@selector(shouldHighlightView));
}

- (void)testDidHighlightRow {
    // WHEN:
    //   We inform the delegate that the table view did highlight a row at the index path
    [tableViewDelegate tableView:tableView didHighlightRowAtIndexPath:indexPath];
    
    // THEN:
    //   The didHighlightView method of the event handler will be called
    AssertEventHandlerSelectorCalled(@selector(didHighlightView));
}

- (void)testDidUnhighlightRow {
    // WHEN:
    //   We inform the delegate that the table view did unhighlight a row at the index path
    [tableViewDelegate tableView:tableView didUnhighlightRowAtIndexPath:indexPath];
    
    // THEN:
    //   The didUnhighlightView method of the event handler will be called
    AssertEventHandlerSelectorCalled(@selector(didUnhighlightView));
}

- (void)testWillSelectRowAtIndexPath {
    // WHEN:
    //   We inform the delegate that the table view will select a row at the index path
    [tableViewDelegate tableView:tableView willSelectRowAtIndexPath:indexPath];
    
    // THEN:
    //   The willSelectView method of the event handler will be called
    AssertEventHandlerSelectorCalled(@selector(willSelectView));
}

- (void)testWillDeselectRowAtIndexPath {
    // WHEN:
    //   We inform the delegate that the table view will deselect a row at the index path
    [tableViewDelegate tableView:tableView willDeselectRowAtIndexPath:indexPath];
    
    // THEN:
    //   The willDeselectView method of the event handler will be called
    AssertEventHandlerSelectorCalled(@selector(willDeselectView));
}

- (void)testDidSelectRowAtIndexPath {
    // WHEN:
    //   We inform the delegate that the table view selected a row at the index path
    [tableViewDelegate tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    // THEN:
    //   The didSelectView method of the event handler will be called
    AssertEventHandlerSelectorCalled(@selector(didSelectView));
}

- (void)testDidDeselectRowAtIndexPath {
    // WHEN:
    //   We inform the delegate that the table view deselected a row at the index path
    [tableViewDelegate tableView:tableView didDeselectRowAtIndexPath:indexPath];
    
    // THEN:
    //   The didDeselectView method of the event handler will be called
    AssertEventHandlerSelectorCalled(@selector(didDeselectView));
}

#pragma mark - Editing

- (void)testEditingStyleForRow {
    // GIVEN:
    //   A table view data model
    //     set as the model of the table view delegate
    //   A cell data model
    //     with a certain editing style
    //     added to the table model
    RLDTableViewCellModel *cellModel = [self cellModelInTableViewDataModel];
    cellModel.editingStyle = UITableViewCellEditingStyleDelete;

    // WHEN:
    //   We ask the delegate for the editing style of a row at a certain index path
    UITableViewCellEditingStyle editingStyle = [tableViewDelegate tableView:tableView editingStyleForRowAtIndexPath:indexPath];
    
    // THEN:
    //   The returned value must be equal to the editing style in the cell model
    XCTAssertEqual(editingStyle, cellModel.editingStyle);
}

- (void)testEditActions {
    // GIVEN:
    //   A event handler
    //     with a certain array of edit actions
    eventHandler.editActions = @[[UITableViewRowAction new]];
    
    // WHEN:
    //   We ask the delegate for the edit actions of a row at a certain index path
    NSArray *editActions = [tableViewDelegate tableView:tableView editActionsForRowAtIndexPath:indexPath];
    
    // THEN:
    //   The returned edit actions array must be equal to the one returned by the event handler
    XCTAssertEqual(editActions, eventHandler.editActions);
}

- (void)testTitleForDeleteConfirmationButton {
    // GIVEN:
    //   A table view data model
    //     set as the model of the table view delegate
    //   A cell data model
    //     with a certain editing style
    //     added to the table model
    RLDTableViewCellModel *cellModel = [self cellModelInTableViewDataModel];
    cellModel.titleForDeleteConfirmationButton = @"TestTitleForDeleteConfirmationButton ";
    
    // WHEN:
    //   We ask the delegate for the editing style of a row at a certain index path
    NSString *titleForDeleteConfirmationButton = [tableViewDelegate tableView:tableView titleForDeleteConfirmationButtonForRowAtIndexPath:indexPath];
    
    // THEN:
    //   The returned title must be equal to the one in the cell model
    XCTAssertEqual(titleForDeleteConfirmationButton, cellModel.titleForDeleteConfirmationButton);
}

- (void)testShouldIndentWhileEditing {
    // GIVEN:
    //   A table view data model
    //     set as the model of the table view delegate
    //   A cell data model
    //     that states that the cell should indent while editing
    //     added to the table model
    RLDTableViewCellModel *cellModel = [self cellModelInTableViewDataModel];
    cellModel.shouldIndentWhileEditing = YES;
    
    // WHEN:
    //   We ask the delegate wether a row at a certain index path should indent while editing
    BOOL shouldIndentWhileEditing = [tableViewDelegate tableView:tableView shouldIndentWhileEditingRowAtIndexPath:indexPath];
    
    // THEN:
    //   The returned value must be equal to the one set in the cell model
    XCTAssertEqual(shouldIndentWhileEditing, cellModel.shouldIndentWhileEditing);
}

- (void)testWillBeginEditing {
    // WHEN:
    //   We inform the delegate that the table view will beging editing a row at the index path
    [tableViewDelegate tableView:tableView willBeginEditingRowAtIndexPath:indexPath];
    
    // THEN:
    //   The willBeginEditing method of the event handler will be called
    AssertEventHandlerSelectorCalled(@selector(willBeginEditing));
}

- (void)testDidEndEditing {
    // WHEN:
    //   We inform the delegate that the table view ended editing a row at the index path
    [tableViewDelegate tableView:tableView didEndEditingRowAtIndexPath:indexPath];
    
    // THEN:
    //   The didEndEditing method of the event handler will be called
    AssertEventHandlerSelectorCalled(@selector(didEndEditing));
}

#pragma mark - Indentation

- (void)testIndentationLevel {
    // GIVEN:
    //   A table view data model
    //     set as the model of the table view delegate
    //   A cell data model
    //     with a certain indentation level
    //     added to the table model
    RLDTableViewModel *dataModel = [RLDTableViewModel new];
    tableViewDelegate.tableViewModel = dataModel;
    
    RLDTableViewCellModel *cellModel = [RLDTableViewCellModel new];
    cellModel.indentationLevel = 2;
    [dataModel addCellModel:cellModel];
    
    // WHEN:
    //   We ask the delegate for the indentation level of a row at a certain index path
    NSInteger indentationLevel = [tableViewDelegate tableView:tableView indentationLevelForRowAtIndexPath:indexPath];
    
    // THEN:
    //   The returned value must be equal to the one set in the cell model
    XCTAssertEqual(indentationLevel, cellModel.indentationLevel);
}

#pragma mark - Copy and Paste

- (void)testShouldShowMenu {
    // GIVEN:
    //   A table view data model
    //     set as the model of the table view delegate
    //   A cell data model
    //     that states that the cell should show the copy and paste menu
    //     added to the table model
    RLDTableViewCellModel *cellModel = [self cellModelInTableViewDataModel];
    cellModel.shouldShowMenu = YES;
    
    // WHEN:
    //   We ask the delegate wether a row at a certain index path should show the copy and paste menu
    BOOL shouldShowMenu = [tableViewDelegate tableView:tableView shouldShowMenuForRowAtIndexPath:indexPath];
    
    // THEN:
    //   The returned value must be equal to the one set in the cell model
    XCTAssertEqual(shouldShowMenu, cellModel.shouldShowMenu);
}

- (void)testCanPerformAction {
    // WHEN:
    //   We ask the delegate wether a row at a certain index path can perform an action
    [tableViewDelegate tableView:tableView canPerformAction:nil forRowAtIndexPath:indexPath withSender:nil];
    
    // THEN:
    //   The canPerformAction:withSender: method of the event handler will be called
    AssertEventHandlerSelectorCalled(@selector(canPerformAction:withSender:));
}

- (void)testPerformAction {
    // WHEN:
    //   We ask the delegate to perform an action for a row at a certain index path
    [tableViewDelegate tableView:tableView performAction:nil forRowAtIndexPath:indexPath withSender:nil];
    
    // THEN:
    //   The performAction:withSender: method of the event handler will be called
    AssertEventHandlerSelectorCalled(@selector(performAction:withSender:));
}

#pragma mark - Helper methods

- (RLDTableViewCellModel *)cellModelInTableViewDataModel {
    RLDTableViewModel *dataModel = [RLDTableViewModel new];
    tableViewDelegate.tableViewModel = dataModel;
    
    RLDTableViewCellModel *cellModel = [RLDTableViewCellModel new];
    [dataModel addCellModel:cellModel];
    return cellModel;
}

@end