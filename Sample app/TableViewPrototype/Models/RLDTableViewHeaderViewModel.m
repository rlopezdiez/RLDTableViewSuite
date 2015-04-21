#import "RLDTableViewHeaderViewModel.h"

@implementation RLDTableViewHeaderViewModel

- (NSString *)reuseIdentifier {
    return @"RLDTableViewHeaderView";
}

-(CGFloat)height {
    return 60.;
}

- (CGFloat)estimatedHeight {
    return [self height];
}

@end