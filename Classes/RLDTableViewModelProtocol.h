#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#pragma mark - RLDTableViewSectionAccessoryViewModel protocol

@protocol RLDTableViewSectionModel;

@protocol RLDTableViewReusableViewModel <NSObject>

// Reuse identifier
- (NSString *)reuseIdentifier;

// Parent linking
- (void)setSectionModel:(id<RLDTableViewSectionModel>)sectionModel;

@optional

// Variable height support
- (CGFloat)height;
- (CGFloat)estimatedHeight;

@end

#pragma mark - RLDTableViewCellModel protocol

@protocol RLDTableViewCellModel <RLDTableViewReusableViewModel>

@optional

// Indentation
- (NSInteger)indentationLevel;

// Editing
- (BOOL)isEditable;
- (BOOL)isMovable;
- (BOOL)shouldIndentWhileEditing;
- (UITableViewCellEditingStyle)editingStyle;
- (NSString *)titleForDeleteConfirmationButton;

// Copy and Paste
- (BOOL)shouldShowMenu;

@end

#pragma mark - RLDTableViewSectionAccessoryViewModel protocol

@protocol RLDTableViewSectionAccessoryViewModel <RLDTableViewReusableViewModel>

@optional

// Title
- (NSString *)title;

@end

#pragma mark - RLDTableViewSectionModel protocol

@protocol RLDTableViewModel;

@protocol RLDTableViewSectionModel <NSObject>

// Parent linking
- (void)setTableModel:(id<RLDTableViewModel>)tableModel;

// Adding and listing cell models
- (void)addCellModel:(id<RLDTableViewCellModel>)cellModel;
- (NSArray *)cellModels;

@optional

// Insertions and deletions
- (Class)defaultCellModelClassForInsertions;
- (void)insertCellModel:(id<RLDTableViewCellModel>)cellModel atIndex:(NSUInteger)index;
- (void)removeCellModel:(id<RLDTableViewCellModel>)cellModel;

// Index title
- (NSString *)indexTitle;

// Section header and footer
- (id<RLDTableViewSectionAccessoryViewModel>)header;
- (id<RLDTableViewSectionAccessoryViewModel>)footer;

@end

#pragma mark - RLDTableViewModel protocol

@protocol RLDTableViewModel <NSObject>

// Listing section models
- (NSArray *)sectionModels;

@optional

// Listing section index titles
- (NSArray *)sectionIndexTitles;

@end