#import <XCTest/XCTest.h>

// SUT
#import "RLDTableViewEventHandlerProvider.h"

// Collaborators
#import "RLDTableViewModel.h"
#import "TestHelpers.h"

@interface RLDTableViewEventHandlerProviderTest : XCTestCase {
    RLDTableViewEventHandlerProvider *sut;
}

@end

@implementation RLDTableViewEventHandlerProviderTest

#pragma mark - Tear down

- (void)setUp {
    [super setUp];
    
    sut = [RLDTableViewEventHandlerProvider new];
}

- (void)tearDown {
    [(NSMutableSet *)[[sut class] availableEventHandlerClasses] removeAllObjects];
    [RLDTestEventHandler reset];
    
    [super tearDown];
}

#pragma mark - Test classes

- (void)testAutomaticRegistrationOfClasses {
    // GIVEN:
    //   Several event handler classes
    //     not registered with the SUT
    // WHEN:
    //   We ask the SUT for all the available event handler classes
    NSSet *availableEventHandlerClasses = [RLDTableViewEventHandlerProvider availableEventHandlerClasses];
    
    // THEN:
    //   It returns a non-empty set
    XCTAssertGreaterThan([availableEventHandlerClasses count], 0);
}

- (void)testManualRegistrationOfClassesOverridesAutomaticRegistration {
    // GIVEN:
    //   A first event handler class
    //     not registered with the SUT
    //   A second event handler class
    //     registered with the SUT
    Class firstEventHandlerClass = [RLDTestEventHandler class];
    
    Class secondEventHandlerClass = [RLDSecondTestEventHandler class];
    [[sut class] registerEventHandlerClass:secondEventHandlerClass];
    
    // WHEN:
    //   We ask the SUT for all the available event handlers
    NSSet *availableEventHandlerClasses = [RLDTableViewEventHandlerProvider availableEventHandlerClasses];
    
    // THEN:
    //   It returns a set with just the second cell model
    XCTAssertEqual([availableEventHandlerClasses count], 1);
    XCTAssertFalse([availableEventHandlerClasses containsObject:firstEventHandlerClass]);
    XCTAssertEqual([availableEventHandlerClasses anyObject], secondEventHandlerClass);
}

- (void)testFactoryMethod {
    // GIVEN:
    //   Two cell models
    //   An event hanlder which is able to handle the first cell model
    //     registered with the SUT
    RLDTestCellModel *firstCellModel = [RLDTestCellModel new];
    RLDTestCellModel *secondCellModel = [RLDTestCellModel new];
    
    [RLDTestEventHandler setCanHandle:^BOOL(id<NSObject> model, UITableView *tableView, UIView *view) {
        return (model == firstCellModel);
    }];
    [[sut class] registerEventHandlerClass:[RLDTestEventHandler class]];
    
    // WHEN:
    //   We ask the sut for event handlers for each model
    id<RLDTableViewGenericEventHandler> firstEventHandler = [sut eventHandlerWithTableView:nil viewModel:firstCellModel view:nil];
    id<RLDTableViewGenericEventHandler> secondEventHandler = [sut eventHandlerWithTableView:nil viewModel:secondCellModel view:nil];
    
    // THEN:
    //   It is able to provide an event handler for the first cell model
    //   It is not able to provide an event handler for the first cell model
    XCTAssertNotNil(firstEventHandler);
    XCTAssertNil(secondEventHandler);
}

- (void)testEventHandlerIsSetUp {
    // GIVEN:
    //   A cell model
    //   An event hanlder
    //     which is able to handle the cell model
    //     registered with the SUT
    //   A table view
    //   A cell
    RLDTestCellModel *cellModel = [RLDTestCellModel new];
    [[sut class] registerEventHandlerClass:[RLDTestEventHandler class]];
    [RLDTestEventHandler setCanHandle:^BOOL(id<NSObject> model, UITableView *tableView, UIView *view) {
        return YES;
    }];
    UITableView *tableView = [UITableView new];
    UITableViewCell *cell = [UITableViewCell new];
    
    // WHEN:
    //   We ask the sut for a event handler for model, table view and cell
    RLDTestEventHandler *eventHanlder = (RLDTestEventHandler *)[sut eventHandlerWithTableView:tableView viewModel:cellModel view:cell];
    
    // THEN:
    //   It is able to provide an event handler
    //     With its model set up
    //     With its table view set up
    //     With its view set up
    XCTAssertNotNil(eventHanlder);
}

@end