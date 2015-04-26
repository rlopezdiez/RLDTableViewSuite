#import "RLDTableViewModelProtocol.h"

#pragma mark - RLDTableViewGenericEventHandler protocol

@protocol RLDTableViewGenericEventHandler <NSObject>

// Suitability checking
+ (BOOL)canHandleTableView:(UITableView *)tableView viewModel:(id<RLDTableViewReusableViewModel>)viewModel view:(UIView *)view;

// Collaborators
- (void)setTableView:(UITableView *)tableView;
- (void)setViewModel:(id<RLDTableViewReusableViewModel>)viewModel;
- (void)setView:(UIView *)view;

@optional

// Display customization
- (void)willReuseView;
- (void)willDisplayView;
- (void)didEndDisplayingView;

@end

#pragma mark - RLDTableViewCellEventHandler protocol

@protocol RLDTableViewCellEventHandler <RLDTableViewGenericEventHandler>

@optional

// Accessories (disclosures)
- (void)accessoryButtonTapped;

// Selection
- (BOOL)shouldHighlightView;
- (void)didHighlightView;
- (void)didUnhighlightView;
- (void)willSelectView;
- (void)willDeselectView;
- (void)didSelectView;
- (void)didDeselectView;

// Editing
- (void)willBeginEditing;
- (void)didEndEditing;
- (NSArray *)editActions;

// Copy and Paste
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender;
- (void)performAction:(SEL)action withSender:(id)sender;

@end

#pragma mark - RLDTableViewSectionAccessoryViewEventHandler protocol

@protocol RLDTableViewSectionAccessoryViewEventHandler <RLDTableViewGenericEventHandler>

@end

#pragma mark - RLDTableViewEventHandlerProvider protocol

@protocol RLDTableViewEventHandlerProvider <NSObject>

- (id<RLDTableViewGenericEventHandler>)eventHandlerWithTableView:(UITableView *)tableView viewModel:(id<RLDTableViewReusableViewModel>)viewModel view:(UIView *)view;

@end