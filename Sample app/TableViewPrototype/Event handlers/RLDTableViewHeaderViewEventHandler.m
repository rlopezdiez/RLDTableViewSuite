#import "RLDTableViewHeaderViewEventHandler.h"

#import "RLDTableViewHeaderView.h"
#import "RLDTableViewHeaderViewModel.h"

#import "RLDTableViewEventHandlerProvider.h"

@interface RLDTableViewHeaderViewEventHandler ()

@property (nonatomic, strong) RLDTableViewHeaderView *view;
@property (nonatomic, strong) RLDTableViewHeaderViewModel *viewModel;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation RLDTableViewHeaderViewEventHandler

#pragma mark - Event handler registering

+ (void)load {
    [RLDTableViewEventHandlerProvider registerEventHandlerClass:self];
}

#pragma mark - Suitability checking

+ (BOOL)canHandleTableView:(UITableView *)tableView viewModel:(id<RLDTableViewReusableViewModel>)viewModel view:(UIView *)view {
    return ([viewModel isKindOfClass:[RLDTableViewHeaderViewModel class]]
            && tableView
            && [view isKindOfClass:[RLDTableViewHeaderView class]]);
}

#pragma mark - Header customization

- (void)willDisplayView {
    self.view.model = self.viewModel;
}

@end