#import <Foundation/Foundation.h>

#pragma mark - NSObject categories

@protocol RLDTableViewCellModel, RLDTableViewModel, RLDTableViewSectionModel, RLDTableViewSectionAccessoryViewModel;

@interface NSObject (RLDArbitraryAccessor)

// Gets a target from targetBlock and calls valueForSelector on it using the provided selector
+ (id)performSelector:(SEL)selector withTarget:(NSObject *(^)())targetBlock;

// The object returned by the selector, a NSValue object containing the return value if it is not an object or nil if the target doesn't respond to the selector
- (id)valueForSelector:(SEL)selector;

@end

@interface NSObject (RLDTableViewModelAccessors)

// These methods return the nil if the queried object doesn't exist
- (id<RLDTableViewCellModel>)tableViewModel:(id<RLDTableViewModel>)tableViewModel cellModelAtIndexPath:(NSIndexPath *)indexPath;
- (id<RLDTableViewSectionModel>)tableViewModel:(id<RLDTableViewModel>)tableViewModel sectionModelAtIndex:(NSInteger)index;
- (id<RLDTableViewSectionAccessoryViewModel>)tableViewModel:(id<RLDTableViewModel>)tableViewModel headerModelForSection:(NSInteger)section;
- (id<RLDTableViewSectionAccessoryViewModel>)tableViewModel:(id<RLDTableViewModel>)tableViewModel footerModelForSection:(NSInteger)section;

// These methods return the result of performing the selector, wrapped in an NSValue if it's not an object
- (id)tableViewModel:(id<RLDTableViewModel>)tableViewModel valueForSelector:(SEL)selector;
- (id)tableViewModel:(id<RLDTableViewModel>)tableViewModel cellModelAtIndexPath:(NSIndexPath *)indexPath valueForSelector:(SEL)selector;
- (id)tableViewModel:(id<RLDTableViewModel>)tableViewModel headerModelForSection:(NSInteger)section valueForSelector:(SEL)selector;
- (id)tableViewModel:(id<RLDTableViewModel>)tableViewModel footerModelForSection:(NSInteger)section valueForSelector:(SEL)selector;
- (id)tableViewModel:(id<RLDTableViewModel>)tableViewModel sectionModelAtIndex:(NSInteger)index valueForSelector:(SEL)selector;

@end

#pragma mark - NSArray category interface

@interface NSArray (RLDSafeAccessor)

// This method return the nil if the queried object doesn't exist
- (id)objectOrNilAtIndex:(NSUInteger)index;

@end