#import <UIKit/UIKit.h>

@protocol RLDTableViewModel, RLDTableViewEventHandlerProvider;

@interface RLDTableViewDelegate : NSObject<UITableViewDelegate>

@property (nonatomic, strong) id<RLDTableViewModel> tableViewModel;
@property (nonatomic, strong) id<RLDTableViewEventHandlerProvider> eventHandlerProvider;

@end