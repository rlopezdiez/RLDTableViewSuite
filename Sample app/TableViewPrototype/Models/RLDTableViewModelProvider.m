#import "RLDTableViewModelProvider.h"

#import "RLDTableViewModel.h"
#import "RLDTableViewHeaderViewModel.h"

static NSString *const RLDTableViewModelProviderDataPlistFileName = @"viewModelData";

static NSString *const RLDTableViewModelProviderDictionaryTitleKey = @"title";
static NSString *const RLDTableViewModelProviderDictionaryCellsKey = @"cells";
static NSString *const RLDTableViewModelProviderDictionaryClassKey = @"class";

static NSString *const RLDTableViewModelProviderTableViewCellTitleForDeleteConfirmationButton = @"Delete";

static NSString *const RLDTableViewModelProviderTableViewHeaderViewReuseIdentifier = @"RLDTableViewHeaderView";

@implementation RLDTableViewModelProvider

@synthesize tableViewModel = _tableViewModel;

- (id<RLDTableViewModel>)tableViewModel {
    if (!_tableViewModel) {
        _tableViewModel = [self tableViewModelWithModelArray:[self modelArray]];
    }
    
    return _tableViewModel;
}

- (NSDictionary *)headerFooterReuseIdentifiersToNibNames {
    return @{RLDTableViewModelProviderTableViewHeaderViewReuseIdentifier : RLDTableViewModelProviderTableViewHeaderViewReuseIdentifier};
}

- (NSArray *)modelArray {
    return [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:RLDTableViewModelProviderDataPlistFileName ofType:@"plist"]];
}

- (RLDTableViewModel *)tableViewModelWithModelArray:(NSArray *)modelArray {
    RLDTableViewModel *tableViewModel = [RLDTableViewModel new];
    for (NSDictionary *sectionDictionary in modelArray) {
        [self tableViewModel:tableViewModel addSectionWithSectionDictionary:sectionDictionary];
    }
    return tableViewModel;
}

- (void)tableViewModel:(RLDTableViewModel *)tableViewModel addSectionWithSectionDictionary:(NSDictionary *)sectionDictionary {
    RLDTableViewSectionModel *sectionModel = [tableViewModel addNewSectionModel];
    
    NSString *headerTitle = sectionDictionary [RLDTableViewModelProviderDictionaryTitleKey];
    if (headerTitle) {
        RLDTableViewHeaderViewModel *headerModel = [RLDTableViewHeaderViewModel new];
        headerModel.title = headerTitle;
        sectionModel.header = headerModel;
    }
    
    for (NSDictionary *cellDictionary in sectionDictionary[RLDTableViewModelProviderDictionaryCellsKey]) {
        [self tableViewModel:tableViewModel addCellWithCellDictionary:cellDictionary];
    }
}

- (void)tableViewModel:(RLDTableViewModel *)tableViewModel addCellWithCellDictionary:(NSDictionary *)cellDictionary {
    Class cellModelClass = NSClassFromString(cellDictionary[RLDTableViewModelProviderDictionaryClassKey]);
    
    NSMutableDictionary *properties = [cellDictionary mutableCopy];
    [properties setValue:nil forKey:RLDTableViewModelProviderDictionaryClassKey];
    
    id cellModel = [cellModelClass new];
    [properties enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [cellModel setValue:obj forKey:key];
    }];
    
    [cellModel setTitleForDeleteConfirmationButton:RLDTableViewModelProviderTableViewCellTitleForDeleteConfirmationButton];
    
    [tableViewModel addCellModel:cellModel];
}

@end