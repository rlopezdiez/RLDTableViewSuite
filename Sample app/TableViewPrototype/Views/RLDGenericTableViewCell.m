#import "RLDGenericTableViewCell.h"
#import "RLDGenericTableViewCellModel.h"
#import "RLDGenericTableViewCellEventHandler.h"

@interface RLDGenericTableViewCell ()

@property (nonatomic, strong) IBOutlet UILabel *title;
@property (nonatomic, strong) IBOutlet UILabel *date;
@property (nonatomic, strong) IBOutlet UIButton *category;
@property (nonatomic, strong) IBOutlet UIImageView *image;

@property (nonatomic, strong) RLDGenericTableViewCellEventHandler *eventHandler;

@end

@implementation RLDGenericTableViewCell

- (void)setModel:(RLDGenericTableViewCellModel *)model {
    _model = model;
    
    self.title.text = model.title;
    self.date.text = model.date;
    [self.category setTitle:model.category forState:UIControlStateNormal];
    
    self.image.image = [UIImage imageNamed:model.imageName];
}

- (IBAction)categoryButtonTapped {
    [self.eventHandler didTapCategoryButton];
}

@end
