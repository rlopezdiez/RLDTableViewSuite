#import <UIKit/UIKit.h>

@protocol RLDTableViewModel;

@class RLDTableViewDataSource;

@interface RLDTableViewDataSource : NSObject<UITableViewDataSource>

@property (nonatomic, strong) id<RLDTableViewModel> tableViewModel;

@end