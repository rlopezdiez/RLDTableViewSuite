#import "RLDTableViewModel.h"

@interface RLDGenericTableViewCellModel : RLDTableViewCellModel

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *category;
@property (nonatomic, copy) NSString *categoryURL;
@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, copy) NSString *imageURL;

@end