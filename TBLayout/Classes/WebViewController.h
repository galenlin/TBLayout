//
//  WebViewController.h
//  TBDemo
//
//  Created by galen on 15/1/15.
//  Copyright (c) 2015年 galen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController

@property (nonatomic, strong) NSString *url;
@property (strong, nonatomic) IBOutlet UIWebView *webView;

@end
