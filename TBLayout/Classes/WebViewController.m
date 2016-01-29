//
//  WebViewController.m
//  TBDemo
//
//  Created by galen on 15/1/15.
//  Copyright (c) 2015年 galen. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController () <UIWebViewDelegate>
{
    NSInteger _retryCount;
}

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSURL *url = [NSURL URLWithString:self.url];
    self.title = [url host];
    [self.webView setDelegate:self];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSString *failedUrl = [[error userInfo] objectForKey:@"NSErrorFailingURLStringKey"];
    if ([failedUrl isEqualToString:self.url]) {
        self.title = [NSString stringWithFormat:@"Failed #%i", _retryCount+1];
        NSLog(@"WebView Error: %@", error);
        if (_retryCount < 3) {
            [self.webView reload];
            _retryCount++;
        }
    }
}

@end
