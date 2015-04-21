#import "RLDTableViewModelProtocol.h"

#pragma mark - RLDTableViewReusableViewModel interface

@interface RLDTableViewReusableViewModel : NSObject<RLDTableViewReusableViewModel>

// Reuse identifier
@property (nonatomic, copy) NSString *reuseIdentifier;

// Variable height support
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat estimatedHeight;

@end

#pragma mark - RLDTableViewCellModel interface

@interface RLDTableViewCellModel : RLDTableViewReusableViewModel<RLDTableViewCellModel>

// Indentation
@property (nonatomic, assign) NSInteger indentationLevel;

// Editing
@property (nonatomic, assign, getter=isEditable) BOOL editable;
@property (nonatomic, assign, getter=isMovable) BOOL movable;
@property (nonatomic, assign) BOOL shouldIndentWhileEditing;
@property (nonatomic, assign) UITableViewCellEditingStyle editingStyle;
@property (nonatomic, copy) NSString *titleForDeleteConfirmationButton;

// Copy and Paste
@property (nonatomic, assign) BOOL shouldShowMenu;

@end

#pragma mark - RLDTableViewSectionAccessoryViewModel interface

@interface RLDTableViewSectionAccessoryViewModel: RLDTableViewReusableViewModel<RLDTableViewSectionAccessoryViewModel>

// Title
@property (nonatomic, copy) NSString *title;

@end

#pragma mark - RLDTableViewSectionModel interface

@interface RLDTableViewSectionModel : NSObject<RLDTableViewSectionModel>

// Index title
@property (nonatomic, copy) NSString *indexTitle;

// Section header and footer
@property (nonatomic, strong) id<RLDTableViewSectionAccessoryViewModel> header;
@property (nonatomic, strong) id<RLDTableViewSectionAccessoryViewModel> footer;

// Insertions
@property (nonatomic, weak) Class defaultCellModelClassForInsertions;

@end

#pragma mark - RLDTableViewModel interface

@interface RLDTableViewModel : NSObject<RLDTableViewModel>

@property (nonatomic, copy) NSArray *sectionIndexTitles;

// Listing section models
- (id<RLDTableViewSectionModel>)lastSectionModel;

// Adding section models
- (id<RLDTableViewSectionModel>)addNewSectionModel;

// Adding cell models
- (void)addCellModel:(id<RLDTableViewCellModel>)cellModel;
- (void)addCellModel:(id<RLDTableViewCellModel>)cellModel toSectionModel:(id<RLDTableViewSectionModel>)sectionModel;

@end