#import <Foundation/Foundation.h>

@protocol RLDTableViewModel;

@interface RLDTableViewModelProvider : NSObject

@property (nonatomic, strong, readonly) id<RLDTableViewModel> tableViewModel;

@property (nonatomic, copy, readonly) NSDictionary *headerFooterReuseIdentifiersToNibNames;

@end