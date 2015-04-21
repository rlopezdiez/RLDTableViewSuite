#import <UIKit/UIKit.h>
#import "RLDHandledViewProtocol.h"

@class RLDTableViewHeaderViewModel;

@interface RLDTableViewHeaderView : UITableViewHeaderFooterView<RLDHandledViewProtocol>

@property (nonatomic, strong) RLDTableViewHeaderViewModel *model;

@end