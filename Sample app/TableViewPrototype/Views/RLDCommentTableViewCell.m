#import "RLDCommentTableViewCell.h"
#import "RLDCommentTableViewCellModel.h"
#import "RLDGenericTableViewCellEventHandler.h"

@interface RLDCommentTableViewCell ()

@property (nonatomic, strong) IBOutlet UITextView *comment;

@property (nonatomic, strong) RLDCommentTableViewCellModel *model;
@property (nonatomic, strong) RLDGenericTableViewCellEventHandler *eventHandler;

@end

@implementation RLDCommentTableViewCell

@dynamic model;

- (void)setModel:(RLDCommentTableViewCellModel *)model {
    [super setModel:model];
    
    self.comment.text = model.comment;
}

@end