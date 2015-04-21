#import <UIKit/UIKit.h>
#import "RLDHandledViewProtocol.h"

@class RLDGenericTableViewCellModel;

@interface RLDGenericTableViewCell : UITableViewCell<RLDHandledViewProtocol>

@property (nonatomic, strong) RLDGenericTableViewCellModel *model;
@property (nonatomic, strong) IBOutlet UIView *viewToHighlight;

@end
