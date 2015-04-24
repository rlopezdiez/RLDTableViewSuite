#import "RLDTableViewDataSource.h"

#import "RLDTableViewModelProtocol.h"
#import "NSObject+Accessors.h"

@implementation RLDTableViewDataSource

#pragma mark - Cell generation

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id<RLDTableViewCellModel> cellModel = [self tableViewModel:self.tableViewModel cellModelAtIndexPath:indexPath];
    return [tableView dequeueReusableCellWithIdentifier:cellModel.reuseIdentifier forIndexPath:indexPath];
}

#pragma mark - Sections

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.tableViewModel.sectionModels count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)index {
    id<RLDTableViewSectionModel> sectionModel = [self tableViewModel:self.tableViewModel sectionModelAtIndex:index];
    return [sectionModel.cellModels count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)index {
    NSString *title = [self tableViewModel:self.tableViewModel headerModelForSection:index valueForSelector:@selector(title)];
    return title;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)index {
    NSString *title = [self tableViewModel:self.tableViewModel footerModelForSection:index valueForSelector:@selector(title)];
    return title;
}

#pragma mark - Sections index titles

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    NSArray *sectionIndexTitles = [self tableViewModel:self.tableViewModel valueForSelector:@selector(sectionIndexTitles)];
    return  sectionIndexTitles;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    __block NSInteger sectionIndex = 0;
    
    [self enumerateSectionsHavingIndexTitlesWithBlock:^(id<RLDTableViewSectionModel> sectionModel, NSUInteger index, BOOL *shouldStop) {
        if ([sectionModel.indexTitle isEqualToString:title]) {
            sectionIndex = index;
            *shouldStop = YES;
        }
    }];
    
    return sectionIndex;
}

- (void)enumerateSectionsHavingIndexTitlesWithBlock:(void(^)(id<RLDTableViewSectionModel> sectionModel, NSUInteger index, BOOL *shouldStop))block {
    [self.tableViewModel.sectionModels enumerateObjectsUsingBlock:^(id<RLDTableViewSectionModel> sectionModel, NSUInteger idx, BOOL *stop) {
        if ([sectionModel respondsToSelector:@selector(indexTitle)]) {
            block(sectionModel, idx, stop);
        }
    }];
}

#pragma mark - Data source edition

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL isEditable;
    [[self tableViewModel:self.tableViewModel cellModelAtIndexPath:indexPath valueForSelector:@selector(isEditable)] getValue:&isEditable];
    return isEditable;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL isMovable;
    [[self tableViewModel:self.tableViewModel cellModelAtIndexPath:indexPath valueForSelector:@selector(isMovable)] getValue:&isMovable];
    return isMovable;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (editingStyle) {
        case UITableViewCellEditingStyleInsert:
            [self tableView:tableView commitInsertionForRowAtIndexPath:indexPath];
            break;
            
        case UITableViewCellEditingStyleDelete:
            [self tableView:tableView commitDeletionForRowAtIndexPath:indexPath];
            break;
            
        case UITableViewCellEditingStyleNone:
            return;
    }
}

- (void)tableView:(UITableView *)tableView commitInsertionForRowAtIndexPath:(NSIndexPath *)indexPath {
    id<RLDTableViewSectionModel> sectionModel = [self tableViewModel:self.tableViewModel sectionModelAtIndex:indexPath.section];
    if (![sectionModel respondsToSelector:@selector(defaultCellModelClassForInsertions)]) return;

    id<RLDTableViewCellModel> cellModel = [[sectionModel defaultCellModelClassForInsertions] new];
    if (!cellModel) return;
    
    [sectionModel insertCellModel:cellModel atIndex:indexPath.row];
    [tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)tableView:(UITableView *)tableView commitDeletionForRowAtIndexPath:(NSIndexPath *)indexPath {
    id<RLDTableViewSectionModel> sectionModel = [self tableViewModel:self.tableViewModel sectionModelAtIndex:indexPath.section];
    id<RLDTableViewCellModel> cellModel = [sectionModel.cellModels objectOrNilAtIndex:indexPath.row];
    if (!cellModel) return;
    
    [sectionModel removeCellModel:cellModel];
    
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    id<RLDTableViewSectionModel> sourceSectionModel = [self tableViewModel:self.tableViewModel sectionModelAtIndex:sourceIndexPath.section];
    id<RLDTableViewSectionModel> destinationSectionModel = [self tableViewModel:self.tableViewModel sectionModelAtIndex:destinationIndexPath.section];
    id<RLDTableViewCellModel> cellModel = [sourceSectionModel.cellModels objectOrNilAtIndex:sourceIndexPath.row];
    if (!sourceSectionModel || !destinationSectionModel || !cellModel) return;
    
    [sourceSectionModel removeCellModel:cellModel];
    [destinationSectionModel insertCellModel:cellModel atIndex:destinationIndexPath.row];
}

@end