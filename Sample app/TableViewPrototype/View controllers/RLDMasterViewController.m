#import "RLDMasterViewController.h"

#import "RLDTableViewModelProvider.h"

@interface RLDMasterViewController ()

@property (nonatomic, strong) RLDTableViewModelProvider *modelProvider;

@end

@implementation RLDMasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerNibs];
    [self setTableViewModel];
    [self attachEditButton];
}

- (void)registerNibs {
    [self.modelProvider.headerFooterReuseIdentifiersToNibNames enumerateKeysAndObjectsUsingBlock:^(NSString *reuseIdentifier, NSString *nibName, BOOL *stop) {
        UINib *nib = [UINib nibWithNibName:reuseIdentifier bundle:nil];
        [self.tableView registerNib:nib forHeaderFooterViewReuseIdentifier:nibName];
    }];
}

- (void)setTableViewModel {
    self.tableViewModel = self.modelProvider.tableViewModel;
}

- (RLDTableViewModelProvider *)modelProvider {
    if (!_modelProvider) {
        _modelProvider = [RLDTableViewModelProvider new];
    }
    return _modelProvider;
}

- (void)attachEditButton {
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    
    self.navigationController.hidesBarsOnSwipe = !editing;
    self.navigationController.hidesBarsWhenVerticallyCompact = !editing;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end