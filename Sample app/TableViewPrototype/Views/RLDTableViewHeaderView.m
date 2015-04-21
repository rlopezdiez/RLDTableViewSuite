#import "RLDTableViewHeaderView.h"
#import "RLDTableViewHeaderViewModel.h"
#import "RLDTableViewHeaderViewEventHandler.h"

@interface RLDTableViewHeaderView ()

@property (nonatomic, strong) IBOutlet UILabel *textLabel;

@property (nonatomic, strong) RLDTableViewHeaderViewEventHandler *eventHandler;

@end

@implementation RLDTableViewHeaderView

@synthesize textLabel;

- (void)setModel:(RLDTableViewHeaderViewModel *)model {
    _model = model;
    
    textLabel.text = model.title;
}

@end
