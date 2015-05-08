#import "RLDTableViewController.h"

#import "RLDTableViewEventHandlerProvider.h"
#import "RLDTableViewDataSource.h"
#import "RLDTableViewDelegate.h"

#pragma mark - RLDFirstResponder category on UIView

__weak static UIView *_firstResponder;

@interface UIView (RLDFirstResponder)

+ (UIView *)rld_firstResponder;

@end

@implementation UIView (RLDFirstResponder)

+ (UIView *)rld_firstResponder {
    [[UIApplication sharedApplication] sendAction:@selector(setFirstResponder) to:nil from:nil forEvent:nil];
    return _firstResponder;
}

- (void)setFirstResponder {
    _firstResponder = self;
}

@end

#pragma mark - RLDFirstResponder category on UITableView

@interface UITableView (RLDScrollToFirstResponder)

- (void)scrollToFirstResponderRectAnimated:(BOOL)animated;

@end

@implementation UITableView (RLDScrollToFirstResponder)

- (void)scrollToFirstResponderRectAnimated:(BOOL)animated {
    UIView *firstResponder = [UIView rld_firstResponder];
    if (!firstResponder) return;
    
    CGRect firstResponderFrame = [firstResponder convertRect:firstResponder.bounds toView:self];
    
    [self scrollRectToVisible:firstResponderFrame animated:animated];
}

@end

#pragma mark - RLDMultipleSelectionDetection category on UITableView

@interface UITableView (RLDMultipleSelectionDetection)

- (BOOL)isMultipleSelectionModeEnabled;

@end

@implementation UITableView (RLDMultipleSelectionDetection)

- (BOOL)isMultipleSelectionModeEnabled {
    return (self.editing
            ? self.allowsMultipleSelectionDuringEditing
            : self.allowsMultipleSelection);
}

@end

#pragma mark - RLDTableViewController implementation

@interface RLDTableViewController ()

@property (nonatomic, strong) RLDTableViewDataSource *tableViewDataSource;
@property (nonatomic, strong) RLDTableViewDelegate *tableViewDelegate;

@end

@implementation RLDTableViewController

@synthesize tableView = _tableView;

#pragma mark - Initialization

- (instancetype)initWithStyle:(UITableViewStyle)style {
    if (self = [super init]) {
        [self commonInit];
        [self hookTableView:[[UITableView alloc] initWithFrame:CGRectZero style:style]];
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    _clearsSelectionOnViewWillAppear = YES;
    
    _tableViewDataSource = [RLDTableViewDataSource new];
    _tableViewDelegate = [RLDTableViewDelegate new];
    _tableViewDelegate.eventHandlerProvider = [RLDTableViewEventHandlerProvider new];
}

#pragma mark - Data source and delegate configuration

- (void)setTableViewModel:(id<RLDTableViewModel>)tableViewModel {
    _tableViewModel = tableViewModel;
    
    self.tableViewDelegate.tableViewModel = tableViewModel;
    self.tableViewDataSource.tableViewModel = tableViewModel;
    
    [self.tableView reloadData];
}

#pragma mark - View management

- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *newTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [self hookTableView:newTableView];
    }
    return _tableView;
}

- (void)setView:(UITableView *)view {
    NSAssert([view isKindOfClass:[UITableView class]], @"The view must be an UITableView");
    self.tableView = view;
    [super setView:view];
}

- (void)setTableView:(UITableView *)tableView {
    [self hookTableView:tableView];
    [self.tableView reloadData];
}

- (void)hookTableView:(UITableView *)tableView {
    tableView.delegate = self.tableViewDelegate;
    tableView.dataSource = self.tableViewDataSource;
    _tableView = tableView;
}

- (void)viewWillAppear:(BOOL)animated {
    [self startObservingKeyboardNotifications];
    
    if (self.clearsSelectionOnViewWillAppear) [self clearTableViewSelection:animated];
    
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.tableView flashScrollIndicators];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self stopObservingKeyboardNotifications];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];
}

- (void)setRefreshControl:(UIRefreshControl *)refreshControl {
    _refreshControl = refreshControl;
    [self.tableView insertSubview:refreshControl atIndex:0];
}

#pragma mark - Keyboard notifications handling

- (void)startObservingKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowWithKeyboardChangeNotification:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHideWithKeyboardChangeNotification:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)stopObservingKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardWillShowWithKeyboardChangeNotification:(NSNotification *)notification {
    [self synchronizeAnimationWithKeyboardChangeNotification:notification
                                              animations:^{
                                                  self.tableView.frame = CGRectMake(self.tableView.frame.origin.x,
                                                                                    self.tableView.frame.origin.y,
                                                                                    self.tableView.frame.size.width,
                                                                                    self.tableView.superview.bounds.size.height - [self keyboardHeightWithKeyboardNotification:notification]);
                                                  
                                                  [self.tableView scrollToFirstResponderRectAnimated:NO];
                                              }];
}

- (void)keyboardWillHideWithKeyboardChangeNotification:(NSNotification *)notification {
   [self synchronizeAnimationWithKeyboardChangeNotification:notification
                                              animations:^{
                                                  self.tableView.frame = self.tableView.superview.bounds;
                                              }];
}

- (void)synchronizeAnimationWithKeyboardChangeNotification:(NSNotification *)notification animations:(void(^)(void))animations {
    if (!animations) return;
    
    NSTimeInterval animationDuration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve animationCurve = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    if (animationDuration == 0) {
        animations();
    } else {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:animationDuration];
        [UIView setAnimationCurve:animationCurve];
        [UIView setAnimationBeginsFromCurrentState:YES];
        animations();
        
        [UIView commitAnimations];
    }
    
}

- (CGFloat)keyboardHeightWithKeyboardNotification:(NSNotification *)notification {
    CGRect keyboardBounds = [self keyboardBoundsWithKeyboardNotification:notification];
    return keyboardBounds.size.height;
}

- (CGRect)keyboardBoundsWithKeyboardNotification:(NSNotification *)notification {
    CGRect keyboardBounds;
    [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardBounds];
    return keyboardBounds;
}

#pragma mark - Selection clearing

- (void)clearTableViewSelection:(BOOL)animated {
    if ([self.tableView isMultipleSelectionModeEnabled]) return;
    
    NSIndexPath *indexPathForSelectedRow = [self.tableView indexPathForSelectedRow];
    if (!indexPathForSelectedRow) return;
    
    [self synchronizeDeselectionAnimationOfRowAtIndexPath:indexPathForSelectedRow animated:animated];
}

- (void)synchronizeDeselectionAnimationOfRowAtIndexPath:(NSIndexPath *)indexPathForSelectedRow animated:(BOOL)animated {
    [self.transitionCoordinator animateAlongsideTransitionInView:self.tableView animation:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        [self.tableView deselectRowAtIndexPath:indexPathForSelectedRow animated:animated];
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        if (![context isCancelled]) return;
        
        [self.tableView selectRowAtIndexPath:indexPathForSelectedRow animated:NO scrollPosition:UITableViewScrollPositionNone];
    }];
}

@end