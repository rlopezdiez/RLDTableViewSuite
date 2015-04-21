#import "RLDTableViewModelProtocol.h"
#import "RLDTableViewEventHandlerProtocol.h"

#pragma mark - RLDTestTableViewCell interface

@interface RLDTestTableViewCell : UITableViewCell

@end

#pragma mark - RLDTestCellModel interface

@interface RLDTestCellModel : NSObject<RLDTableViewCellModel>

@property (nonatomic, weak) id<RLDTableViewSectionModel> sectionModel;

@property (nonatomic, assign, getter=isEditable) BOOL editable;
@property (nonatomic, assign, getter=isMovable) BOOL movable;

@end

#pragma mark - RLDSecondTestCellModel interface

@interface RLDSecondTestCellModel : RLDTestCellModel

@end

#pragma mark - RLDTestEventHandler interface

typedef BOOL(^canHandleBlockType)(id<NSObject> model, UITableView *tableView, UIView *view);

@interface RLDTestEventHandler : NSObject<RLDTableViewCellEventHandler>

+ (void)setCanHandle:(canHandleBlockType)canHandleBlock;
+ (void)reset;

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) id<NSObject> viewModel;
@property (nonatomic, weak) UIView *view;
@property (nonatomic, strong) NSArray *editActions;

- (NSInvocation *)invocationForPerformedSelector:(SEL)selector;

@end

#pragma mark - RLDSecondTestEventHandler interface

@interface RLDSecondTestEventHandler : RLDTestEventHandler

@end

#pragma mark - RLDTestEventHandlerProvider interface

@interface RLDTestEventHandlerProvider : NSObject<RLDTableViewEventHandlerProvider>

@property (nonatomic, weak) id<RLDTableViewGenericEventHandler> eventHandlerToProvide;

@end

#pragma mark - RLDTestAccessoryView interface

@interface RLDTestAccessoryView : UITableViewHeaderFooterView

@end