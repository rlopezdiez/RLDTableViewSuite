#import "RLDWebViewController.h"

@interface RLDWebViewController ()

@property (strong, nonatomic) IBOutlet UIWebView *view;

@end

@implementation RLDWebViewController

@dynamic view;

- (void)setUrl:(NSString *)url {
    _url = url;

    if (url) {
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
        [self.view loadRequest:urlRequest];
    }
}

@end