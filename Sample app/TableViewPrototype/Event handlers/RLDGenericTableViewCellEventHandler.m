#import "RLDGenericTableViewCellEventHandler.h"

#import "RLDGenericTableViewCell.h"
#import "RLDGenericTableViewCellModel.h"

#import "RLDWebViewController.h"

#import "RLDTableViewEventHandlerProvider.h"

@interface RLDGenericTableViewCellEventHandler ()

@property (nonatomic, strong) RLDGenericTableViewCell *view;
@property (nonatomic, strong) RLDGenericTableViewCellModel *viewModel;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation RLDGenericTableViewCellEventHandler

#pragma mark - Event handler registering

+ (void)load {
    [RLDTableViewEventHandlerProvider registerEventHandlerClass:self];
}

#pragma mark - Suitability checking

+ (BOOL)canHandleTableView:(UITableView *)tableView viewModel:(id<RLDTableViewReusableViewModel>)viewModel view:(UIView *)view {
    return ([viewModel  isKindOfClass:[RLDGenericTableViewCellModel class]]
            && tableView
            && [view isKindOfClass:[RLDGenericTableViewCell class]]);
}

#pragma mark - Cell customization

- (void)willDisplayView {
    self.view.model = self.viewModel;
}

#pragma mark - View highlighting

- (BOOL)shouldHighlightView {
    return YES;
}

- (void)didHighlightView {
    self.view.viewToHighlight.backgroundColor = [UIColor colorWithRed:.8 green:.92 blue:1. alpha:1.];
    self.view.alpha = 0.75;
}

- (void)didUnhighlightView {
    self.view.viewToHighlight.backgroundColor = [UIColor whiteColor];
    self.view.alpha = 1.;
}

#pragma mark - Cell interactions

- (void)didSelectView {
    [self openURL:self.viewModel.imageURL title:self.viewModel.title];
}

- (void)didTapCategoryButton {
    [self openURL:self.viewModel.categoryURL title:self.viewModel.category];
}

- (void)openURL:(NSString *)url title:(NSString *)title {
    /*
     This way of navigating to another view controller is good enough for a sample app,
     but in a real life situation you should consider moving navigation code elsewhere.
     You can use flow controllers, routers or some kind of view model propagation.
     You might want to use my navigation library, which is a good complement to this one:
     https://github.com/rlopezdiez/RLDNavigation
     */
    UINavigationController *navigationController = [self navigationController];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    RLDWebViewController *detailViewController = [storyboard instantiateViewControllerWithIdentifier:@"RLDWebViewController"];
    detailViewController.title = title;
    detailViewController.url = url;
    [navigationController pushViewController:detailViewController animated:YES];
}

- (UINavigationController *)navigationController {
    for (UIView *nextView = [self.view superview]; nextView != nil; nextView = nextView.superview) {
        UIResponder *nextResponder = [nextView nextResponder];
        if ([nextResponder isKindOfClass:[UINavigationController class]]) {
            return (UINavigationController *)nextResponder;
        }
    }
    return nil;
}

@end