#import <XCTest/XCTest.h>

// SUT
#import "RLDTableViewModel.h"

@interface RLDTableViewModelTests : XCTestCase
@end

@implementation RLDTableViewModelTests

#pragma mark - Section index titles test cases

- (void)testSectionIndexTitlesAreTakenFromSectionsWhenNotSet {
    // GIVEN:
    //   A table view data model
    //     with a section with a certain index title
    NSString *const indexTitle = @"~";
    RLDTableViewModel *tableViewModel = [self tableViewModelWithSectionWithIndexTitle:indexTitle];
    
    // WHEN:
    //   The data model is asked for its section index titles
    NSArray *sectionIndexTitles = tableViewModel.sectionIndexTitles;
    
    // THEN:
    //   The section index title of its section is returned
    XCTAssertEqual([sectionIndexTitles count], 1);
    XCTAssert([sectionIndexTitles containsObject:indexTitle]);
}

- (void)testSectionIndexTitlesReturnedWhenSet {
    // GIVEN:
    //   A table view data model
    //     with a section with a certain index title
    NSString *const indexTitle = @"~";
    RLDTableViewModel *tableViewModel = [self tableViewModelWithSectionWithIndexTitle:indexTitle];
    
    // WHEN:
    //   The sectionIndexTitles property of the data model is set
    NSArray *sectionIndexTitles = @[@"A"];
    tableViewModel.sectionIndexTitles = sectionIndexTitles;
    
    // THEN:
    //   The data model return the set object for its sectionIndexTitles property
    XCTAssertEqual(tableViewModel.sectionIndexTitles, sectionIndexTitles);
}

#pragma mark - Helper methods

- (RLDTableViewModel *)tableViewModelWithSectionWithIndexTitle:(NSString *)indexTitle {
    RLDTableViewCellModel *cellModel = [RLDTableViewCellModel new];
    RLDTableViewSectionModel *sectionModel = [RLDTableViewSectionModel new];
    RLDTableViewModel *tableViewModel = [RLDTableViewModel new];
    
    sectionModel.indexTitle = indexTitle;
    [tableViewModel addCellModel:cellModel toSectionModel:sectionModel];
    
    return tableViewModel;
}

@end