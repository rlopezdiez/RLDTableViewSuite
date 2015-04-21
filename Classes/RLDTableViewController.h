#import <UIKit/UIKit.h>

@protocol RLDTableViewModel, RLDTableViewEventHandlerProvider;

@interface RLDTableViewController : UIViewController

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) id<RLDTableViewModel> tableViewModel;

@property (nonatomic, strong) IBOutlet UIRefreshControl *refreshControl;

@property (nonatomic, assign) BOOL clearsSelectionOnViewWillAppear;

- (instancetype)initWithStyle:(UITableViewStyle)style;

@end