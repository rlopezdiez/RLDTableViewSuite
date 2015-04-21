#import "RLDTableViewModel.h"

#pragma mark - RLDTableViewReusableViewModel implementation

@interface RLDTableViewReusableViewModel ()

@property (nonatomic, weak) id<RLDTableViewSectionModel> sectionModel;

@end

@implementation RLDTableViewReusableViewModel

- (NSString *)reuseIdentifier {
    if (!_reuseIdentifier) {
        _reuseIdentifier = NSStringFromClass([self class]);
    }
    return _reuseIdentifier;
}

@end

#pragma mark - RLDTableViewCellModel interface

@implementation RLDTableViewCellModel

@end

#pragma mark - RLDTableViewSectionAccessoryViewModel implementation

@implementation RLDTableViewSectionAccessoryViewModel

@end

#pragma mark - RLDTableViewSectionModel implementation

@interface RLDTableViewSectionModel()

@property (nonatomic, weak) id<RLDTableViewModel> tableModel;
@property (nonatomic, copy) NSMutableArray *cellModels;

@end

@implementation RLDTableViewSectionModel

- (NSMutableArray *)cellModels {
    if (!_cellModels) {
        _cellModels = [NSMutableArray array];
    }
    return _cellModels;
}

- (void)addCellModel:(id<RLDTableViewCellModel>)cellModel {
    [cellModel setSectionModel:self];
    [self.cellModels addObject:cellModel];
}

- (void)insertCellModel:(id<RLDTableViewCellModel>)cellModel atIndex:(NSUInteger)index {
    [cellModel setSectionModel:self];
    [self.cellModels insertObject:cellModel atIndex:index];
}

- (void)removeCellModel:(id<RLDTableViewCellModel>)cellModel {
    [cellModel setSectionModel:nil];
    [self.cellModels removeObject:cellModel];
}

- (void)setHeader:(id<RLDTableViewSectionAccessoryViewModel>)header {
    [header setSectionModel:self];
    _header = header;
}

-(void)setFooter:(id<RLDTableViewSectionAccessoryViewModel>)footer {
    [footer setSectionModel:self];
    _footer = footer;
}

@end

#pragma mark - RLDTableViewModel implementation

@interface RLDTableViewModel ()

@property (nonatomic, copy) NSMutableArray *sectionModels;

@end

@implementation RLDTableViewModel

- (NSMutableArray *)sectionModels {
    if (!_sectionModels) {
        _sectionModels = [NSMutableArray array];
    }
    return _sectionModels;
}

- (id<RLDTableViewSectionModel>)lastSectionModel {
    return [self.sectionModels lastObject];
}

- (void)addCellModel:(id<RLDTableViewCellModel>)cellModel {
    if (![self lastSectionModel]) [self addNewSectionModel];
    
    [self addCellModel:cellModel toSectionModel:[self lastSectionModel]];
}

- (void)addCellModel:(id<RLDTableViewCellModel>)cellModel toSectionModel:(id<RLDTableViewSectionModel>)sectionModel {
    if (sectionModel && ![self.sectionModels containsObject:sectionModel]) [self addSectionModel:sectionModel];
    
    [sectionModel addCellModel:cellModel];
}

- (id<RLDTableViewSectionModel>)addNewSectionModel {
    RLDTableViewSectionModel *newSectionModel = [RLDTableViewSectionModel new];
    [self addSectionModel:newSectionModel];
    return newSectionModel;
}

- (void)addSectionModel:(id<RLDTableViewSectionModel>)sectionModel {
    [sectionModel setTableModel:self];
    [self.sectionModels addObject:sectionModel];
}

- (NSArray *)sectionIndexTitles {
    if (!_sectionIndexTitles) {
        NSMutableArray *sectionIndexTitles = [NSMutableArray arrayWithCapacity:[self.sectionModels count]];
        
        for (id<RLDTableViewSectionModel>sectionModel in self.sectionModels) {
            if ([sectionModel respondsToSelector:@selector(indexTitle)]) {
                if ([sectionModel indexTitle]) [sectionIndexTitles addObject:[sectionModel indexTitle]];
            }
        }
        
        _sectionIndexTitles = [sectionIndexTitles copy];
    }
    return _sectionIndexTitles;
}

@end