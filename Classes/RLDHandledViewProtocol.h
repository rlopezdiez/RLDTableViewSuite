@protocol RLDTableViewGenericEventHandler;

#pragma mark - RLDHandledViewProtocol protocol

@protocol RLDHandledViewProtocol <NSObject>

- (void)setEventHandler:(id<RLDTableViewGenericEventHandler>)eventHandler;

@optional

- (id<RLDTableViewGenericEventHandler>)eventHandler;

@end