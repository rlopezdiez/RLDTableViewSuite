#import <XCTest/XCTest.h>

// SUT
#import "RLDTableViewDataSource.h"

// Collaborators
#import "TestHelpers.h"
#import "RLDTableViewModel.h"

#define RLDRepeat(expression, times) \
for (NSUInteger i = 0; i < times; i++) expression;

@interface RLDTableViewDataSourceTests : XCTestCase {
    // SUT
    RLDTableViewDataSource *dataSource;
    
    // Collaborators
    RLDTableViewModel *dataModel;
}

@end

@implementation RLDTableViewDataSourceTests

-(void)setUp {
    [super setUp];
    
    dataSource = [RLDTableViewDataSource new];
    dataModel = [RLDTableViewModel new];
    dataSource.tableViewModel = dataModel;
}

#pragma mark - Sections test cases

- (void)testAutomaticSectionCreation {
    // GIVEN:
    //   A cell model
    RLDTestCellModel *testCellModel = [RLDTestCellModel new];
    
    // WHEN:
    //   We add the cell model to the table view model
    //   We inject the data model to the data source
    [dataModel addCellModel:testCellModel];
    dataSource.tableViewModel = dataModel;
    
    // THEN:
    //   A section is automatically created in the data model
    //   The data source should return one section
    //   The data source should return one row for the first section
    XCTAssertNotNil([dataModel lastSectionModel]);
    XCTAssertEqual([dataSource numberOfSectionsInTableView:nil], 1);
    XCTAssertEqual([dataSource tableView:nil numberOfRowsInSection:0], 1);
}

- (void)testAutomaticSectionConfiguration {
    // GIVEN:
    //   A cell model
    RLDTestCellModel *testCellModel = [RLDTestCellModel new];
    
    // WHEN:
    //   We add the cell model to the table view model
    //   We inject the data model to the data source
    //   We set up the last section in the model
    //     setting up its index title
    //     setting up its header
    //     setting up its footer
    [dataModel addCellModel:testCellModel];
    dataSource.tableViewModel = dataModel;

    RLDTableViewSectionModel *sectionModel = [dataModel lastSectionModel];
    sectionModel.indexTitle = @"~";
    RLDTableViewSectionAccessoryViewModel *header = [RLDTableViewSectionAccessoryViewModel new];
    header.title = @"Header";
    sectionModel.header = header;
    RLDTableViewSectionAccessoryViewModel *footer = [RLDTableViewSectionAccessoryViewModel new];
    footer.title = @"Footer";
    sectionModel.footer = footer;
    
    // THEN:
    //   The data source should return one section
    //   The data source should return one row for the first section
    //   The first section header title must be equal to the title of the header
    //   The first section footer title must be equal to the title of the footer
    XCTAssertEqual([dataSource numberOfSectionsInTableView:nil], 1);
    XCTAssertEqual([dataSource tableView:nil numberOfRowsInSection:0], 1);
    XCTAssertEqual([dataSource tableView:nil titleForHeaderInSection:0], header.title);
    XCTAssertEqual([dataSource tableView:nil titleForFooterInSection:0], footer.title);
}

- (void)testManualSectionAdding {
    // GIVEN:
    //   A cell model
    //   A section created manually
    //     with its index title set up
    //     with its header set up
    //     with its footer set up
    RLDTestCellModel *testCellModel = [RLDTestCellModel new];
    
    RLDTableViewSectionModel *sectionModel = [RLDTableViewSectionModel new];
    sectionModel.indexTitle = @"~";
    RLDTableViewSectionAccessoryViewModel *header = [RLDTableViewSectionAccessoryViewModel new];
    header.title = @"Header";
    sectionModel.header = header;
    RLDTableViewSectionAccessoryViewModel *footer = [RLDTableViewSectionAccessoryViewModel new];
    footer.title = @"Footer";
    sectionModel.footer = footer;
  
    // WHEN:
    //   We add the cell model to the table view model
    //     specifying it should be added to the manually created section
    //   We inject the data model to the data source
    [dataModel addCellModel:testCellModel toSectionModel:sectionModel];
    dataSource.tableViewModel = dataModel;
    
    // THEN:
    //   The data source should return one section
    //   The data source should return one row for the first section
    //   The first section header title must be equal to the title of the header
    //   The first section footer title must be equal to the title of the footer
    //   The last section in the model must be equal to the manually created section
    //   The fist section in the model must be equal to the manually created section
    XCTAssertEqual([dataSource numberOfSectionsInTableView:nil], 1);
    XCTAssertEqual([dataSource tableView:nil numberOfRowsInSection:0], 1);
    XCTAssertEqual([dataSource tableView:nil titleForHeaderInSection:0], header.title);
    XCTAssertEqual([dataSource tableView:nil titleForFooterInSection:0], footer.title);
    XCTAssertEqual([dataModel lastSectionModel], sectionModel);
    XCTAssertEqual(dataModel.sectionModels[0], sectionModel);
}

- (void)testManualSectionAddingAfterAutomaticSectionAdded {
    // GIVEN:
    //   A cell model
    //   A section created manually
    RLDTestCellModel *testCellModel = [RLDTestCellModel new];

    RLDTableViewSectionModel *sectionModel = [RLDTableViewSectionModel new];
    
    // WHEN:
    //   We add the cell model to the table view model twice
    //   We add the cell model to the table view model three times
    //     specifying it should be added to the manually created section
    //   We inject the data model to the data source
    RLDRepeat([dataModel addCellModel:testCellModel], 2);
    RLDRepeat([dataModel addCellModel:testCellModel toSectionModel:sectionModel], 3);
    dataSource.tableViewModel = dataModel;
    
    // THEN:
    //   The data source should return two sections
    //   The data source should return two rows for the first section
    //   The data source should return three rows for the second section
    //   The last section in the model must be equal to the manually created section
    //   The second section in the model must be equal to the manually created section
    XCTAssertEqual([dataSource numberOfSectionsInTableView:nil], 2);
    XCTAssertEqual([dataSource tableView:nil numberOfRowsInSection:0], 2);
    XCTAssertEqual([dataSource tableView:nil numberOfRowsInSection:1], 3);
    XCTAssertEqual([dataModel lastSectionModel], sectionModel);
    XCTAssertEqual(dataModel.sectionModels[1], sectionModel);
}

- (void)testMultipleManualSectionAdding {
    // GIVEN:
    //   A cell model
    //   Two sections created manually
    RLDTestCellModel *testCellModel = [RLDTestCellModel new];
    
    RLDTableViewSectionModel *firstSectionModel = [RLDTableViewSectionModel new];
    RLDTableViewSectionModel *secondSectionModel = [RLDTableViewSectionModel new];
    
    // WHEN:
    //   We add the cell model to the table view model three times
    //     specifying it should be added to the first manually created section
    //   We add the cell model to the table view model three times
    //     specifying it should be added to the second manually created section
    //   We inject the data model to the data source
    RLDRepeat([dataModel addCellModel:testCellModel toSectionModel:firstSectionModel], 2);
    RLDRepeat([dataModel addCellModel:testCellModel toSectionModel:secondSectionModel], 3);
    dataSource.tableViewModel = dataModel;
    
    // THEN:
    //   The data source should return two sections
    //   The data source should return two rows for the first section
    //   The data source should return three rows for the second section
    //   The last section in the model must be equal to the second manually created section
    //   The first section in the model must be equal to the first manually created section
    //   The second section in the model must be equal to the second manually created section
    XCTAssertEqual([dataSource numberOfSectionsInTableView:nil], 2);
    XCTAssertEqual([dataSource tableView:nil numberOfRowsInSection:0], 2);
    XCTAssertEqual([dataSource tableView:nil numberOfRowsInSection:1], 3);
    XCTAssertEqual([dataModel lastSectionModel], secondSectionModel);
    XCTAssertEqual(dataModel.sectionModels[0], firstSectionModel);
    XCTAssertEqual(dataModel.sectionModels[1], secondSectionModel);
}

#pragma mark - Section index titles test cases

- (void)testAutomaticSectionIndexTitles {
    // GIVEN:
    //   A cell model
    //   Two sections created manually
    //     with its indexes titles set up
    RLDTestCellModel *testCellModel = [RLDTestCellModel new];
    
    RLDTableViewSectionModel *firstSectionModel = [RLDTableViewSectionModel new];
    firstSectionModel.indexTitle = @"1";
    RLDTableViewSectionModel *secondSectionModel = [RLDTableViewSectionModel new];
    secondSectionModel.indexTitle = @"2";
    
    // WHEN:
    //   We add the cell model to the table view model
    //     specifying it should be added to the first manually created section
    //   We add the cell model to the table view
    //     specifying it should be added to the second manually created section
    //   We inject the data model to the data source
    [dataModel addCellModel:testCellModel toSectionModel:firstSectionModel];
    [dataModel addCellModel:testCellModel toSectionModel:secondSectionModel];
    dataSource.tableViewModel = dataModel;
    
    // THEN:
    //   The data source should return and array with two section index titles
    //   The first one must be equal to the section index title of the first manually created section
    //   The second one must be equal to the section index title of the second manually created section
    NSArray *sectionIndexTitles = [dataSource sectionIndexTitlesForTableView:nil];
    XCTAssertEqual([sectionIndexTitles count], 2);
    XCTAssertEqual([sectionIndexTitles objectAtIndex:0], firstSectionModel.indexTitle);
    XCTAssertEqual([sectionIndexTitles objectAtIndex:1], secondSectionModel.indexTitle);
}

- (void)testManualSectionIndexTitles {
    // GIVEN:
    //   A data model
    //     with its section index titles set to numbers from 1 to 4
    //   A cell model
    //   Two sections created manually
    //     with its indexes titles set up to 1 and 2
    dataModel.sectionIndexTitles = @[@"1", @"2", @"3", @"4"];
    RLDTestCellModel *testCellModel = [RLDTestCellModel new];
    
    RLDTableViewSectionModel *firstSectionModel = [RLDTableViewSectionModel new];
    firstSectionModel.indexTitle = @"1";
    RLDTableViewSectionModel *secondSectionModel = [RLDTableViewSectionModel new];
    secondSectionModel.indexTitle = @"2";
    
    // WHEN:
    //   We add the cell model to the table view model
    //     specifying it should be added to the first manually created section
    //   We add the cell model to the table view
    //     specifying it should be added to the second manually created section
    //   We inject the data model to the data source
    [dataModel addCellModel:testCellModel toSectionModel:firstSectionModel];
    [dataModel addCellModel:testCellModel toSectionModel:secondSectionModel];
    dataSource.tableViewModel = dataModel;
    
    // THEN:
    //   The data source should return and array equal to the previously set up index title array of the data model
    NSArray *sectionIndexTitles = [dataSource sectionIndexTitlesForTableView:nil];
    XCTAssertEqual(sectionIndexTitles, dataModel.sectionIndexTitles);
}

- (void)testSectionIndexTitlesToSectionsRelationship {
    // GIVEN:
    //   An data model
    //     with its section index titles set to numbers from 1 to 4
    //   A cell model
    //   Two sections created manually
    //     with its indexes titles set up to 1 and 4
    dataModel.sectionIndexTitles = @[@"1", @"2", @"3", @"4"];
    RLDTestCellModel *testCellModel = [RLDTestCellModel new];
    
    RLDTableViewSectionModel *firstSectionModel = [RLDTableViewSectionModel new];
    firstSectionModel.indexTitle = @"1";
    RLDTableViewSectionModel *secondSectionModel = [RLDTableViewSectionModel new];
    secondSectionModel.indexTitle = @"4";
    
    // WHEN:
    //   We add the cell model to the table view model
    //     specifying it should be added to the first manually created section
    //   We add the cell model to the table view
    //     specifying it should be added to the second manually created section
    //   We inject the data model to the data source
    [dataModel addCellModel:testCellModel toSectionModel:firstSectionModel];
    [dataModel addCellModel:testCellModel toSectionModel:secondSectionModel];
    dataSource.tableViewModel = dataModel;
    
    // THEN:
    //   The data source should return the second section when asked to provide an index for the fourth element of the section index titles array
    XCTAssertEqual([dataSource tableView:nil sectionForSectionIndexTitle:@"4" atIndex:3], 1);
}

#pragma mark - Data source edition test cases

- (void)testCellModelEditionPreferences {
    // GIVEN:
    //   A table view data source
    //   A data model containing two cell models
    //     the first one being non editable
    //     the first one being editable
    RLDTestCellModel *firstCellModel = [RLDTestCellModel new];
    firstCellModel.editable = YES;
    RLDTestCellModel *secondCellModel = [RLDTestCellModel new];
    secondCellModel.editable = NO;
    [dataModel addCellModel:firstCellModel];
    [dataModel addCellModel:secondCellModel];
    
    // WHEN:
    //   We inject the data model to the data source
    dataSource.tableViewModel = dataModel;
    
    // THEN:
    //   The data source should identify the first cell in the first section as editable
    //   The data source should identify the second cell in the first section as non editable
    XCTAssertEqual([dataSource tableView:nil canEditRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]], YES);
    XCTAssertEqual([dataSource tableView:nil canEditRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]], NO);
}

- (void)testCellModelReorderingPreferences {
    // GIVEN:
    //   A table view data source
    //   A data model containing two cell models
    //     the first one being non movable
    //     the first one being movable
    RLDTestCellModel *firstCellModel = [RLDTestCellModel new];
    firstCellModel.movable = YES;
    RLDTestCellModel *secondCellModel = [RLDTestCellModel new];
    secondCellModel.movable = NO;
    [dataModel addCellModel:firstCellModel];
    [dataModel addCellModel:secondCellModel];
    
    // WHEN:
    //   We inject the data model to the data source
    dataSource.tableViewModel = dataModel;
    
    // THEN:
    //   The data source should identify the first cell in the first section as movable
    //   The data source should identify the second cell in the first section as non movable
    XCTAssertEqual([dataSource tableView:nil canMoveRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]], YES);
    XCTAssertEqual([dataSource tableView:nil canMoveRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]], NO);
}

- (void)testCellModelInsertion {
    // GIVEN:
    //   A table view data source
    //   A data model containing two cell models
    RLDTableViewSectionModel *sectionModel = [RLDTableViewSectionModel new];
    
    Class expectedClassForInsertedCellModel = [RLDTestCellModel class];
    sectionModel.defaultCellModelClassForInsertions = expectedClassForInsertedCellModel;
    
    NSMutableArray *testCellModels = [NSMutableArray arrayWithCapacity:2];
    RLDRepeat({
        RLDTestCellModel *testCellModel = [RLDSecondTestCellModel new];
        [testCellModels addObject:testCellModel];
        [dataModel addCellModel:testCellModel toSectionModel:sectionModel];
    }, 2);
    
    // WHEN:
    //   We inject the data model to the data source
    //   We ask the data source to insert a new cell at the second row in the first section
    dataSource.tableViewModel = dataModel;
    [dataSource tableView:nil
       commitEditingStyle:UITableViewCellEditingStyleInsert
        forRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    
    // THEN:
    //   The data source must return three rows for the first section
    //   The section model must contain three cell models
    //   The second cell model must have the expected class
    //   The first cell model must be the first one added
    //   The third cell model must be the second one added
    XCTAssertEqual([dataSource tableView:nil numberOfRowsInSection:0], 3);
    XCTAssertEqual([sectionModel.cellModels count], 3);
    XCTAssertEqual([sectionModel.cellModels[1] class], expectedClassForInsertedCellModel);
    XCTAssertEqual(sectionModel.cellModels[0], testCellModels[0]);
    XCTAssertEqual(sectionModel.cellModels[2], testCellModels[1]);
}

- (void)testCellModelDeletion {
    // GIVEN:
    //   A table view data source
    //     with a cell provider
    //   A data model
    //     with a section with a default cell model class for insertions
    //     containing three cell models
    NSMutableArray *testCellModels = [NSMutableArray arrayWithCapacity:3];
    RLDRepeat({
        RLDTestCellModel *testCellModel = [RLDTestCellModel new];
        [testCellModels addObject:testCellModel];
        [dataModel addCellModel:testCellModel];
    }, 3);
    RLDTableViewSectionModel *sectionModel = [dataModel lastSectionModel];
    
    // WHEN:
    //   We inject the data model to the data source
    //   We ask the data source to delete the second row in the first section
    dataSource.tableViewModel = dataModel;
    [dataSource tableView:nil
       commitEditingStyle:UITableViewCellEditingStyleDelete
        forRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    
    // THEN:
    //   The data source should return two rows for the first section
    //   The section model must contain two cell models
    //   The first cell model must be the first one added
    //   The second cell model must be the third one added
    XCTAssertEqual([dataSource tableView:nil numberOfRowsInSection:0], 2);
    XCTAssertEqual([sectionModel.cellModels count], 2);
    XCTAssertEqual(sectionModel.cellModels[0], testCellModels[0]);
    XCTAssertEqual(sectionModel.cellModels[1], testCellModels[2]);
}

- (void)testCellModelReordering {
    // GIVEN:
    //   A table view data source
    //     with a cell provider
    //   A data model
    //     with a first section with a cell model
    //     with a second section with a cell model
    NSMutableArray *testCellModels = [NSMutableArray arrayWithCapacity:2];
    RLDRepeat({
        RLDTestCellModel *testCellModel = [RLDTestCellModel new];
        [testCellModels addObject:testCellModel];
        [dataModel addCellModel:testCellModel toSectionModel:[RLDTableViewSectionModel new]];
    }, 2);
    RLDTableViewSectionModel *firstSectionModel = dataModel.sectionModels[0];
    RLDTableViewSectionModel *secondSectionModel = dataModel.sectionModels[1];
   
    // WHEN:
    //   We inject the data model to the data source
    //   We ask the data source to move the first row of the first section to the second row of the second section
    dataSource.tableViewModel = dataModel;
    [dataSource tableView:nil
       moveRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
              toIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
    
    // THEN:
    //   The data source should return zero rows for the first section
    //   The data source should return two rows for the second section
    //   The data model must contain zero cell models in its first section
    //   The data model must contain two cell models in its second section
    //   The first cell model in the second section must be the second one added
    //   The second cell model in the second section must be the first one added
    XCTAssertEqual([dataSource tableView:nil numberOfRowsInSection:0], 0);
    XCTAssertEqual([dataSource tableView:nil numberOfRowsInSection:1], 2);
    XCTAssertEqual([firstSectionModel.cellModels count], 0);
    XCTAssertEqual([secondSectionModel.cellModels count], 2);
    XCTAssertEqual(secondSectionModel.cellModels[0], testCellModels[1]);
    XCTAssertEqual(secondSectionModel.cellModels[1], testCellModels[0]);
}

#pragma mark - Test cell generation test cases

- (void)testCellGeneration {
    // GIVEN:
    //   A table view
    //   A table view data source
    //     assigned to the table view
    //   A data model
    //   A cell model
    //     added to the data model
    //   A UITableViewCell subclass
    //     registered with the table view for the cell model reuse identifier
    UITableView *tableView = [UITableView new];
    
    tableView.dataSource = dataSource;
    
    RLDTestCellModel *testCellModel = [RLDTestCellModel new];
    [dataModel addCellModel:testCellModel];
    dataSource.tableViewModel = dataModel;
    
    Class expectedCellClass = [RLDTestTableViewCell class];
    [tableView registerClass:expectedCellClass forCellReuseIdentifier:testCellModel.reuseIdentifier];
    
    // WHEN:
    //  We ask the data source for a cell in the first row of the first section of the table
    UITableViewCell *returnedCell = [dataSource tableView:tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    // THEN:
    //  The returned cell class must match the registered UITableViewCell subclass
    XCTAssertEqual([returnedCell class], expectedCellClass);
}

@end