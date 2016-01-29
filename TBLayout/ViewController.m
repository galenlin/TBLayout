//
//  ViewController.m
//  TBLayout
//
//  Created by galen on 15/1/15.
//  Copyright (c) 2015年 galen. All rights reserved.
//

#import "ViewController.h"
#import "TBViewItem.h"
#import "WebViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.layoutScrollView loadDataWithPlist:@"homeContent"];
    [self.view setBackgroundColor:[UIColor redColor]];
    [self.layoutScrollView setBackgroundColor:[UIColor colorWithWhite:0xF1/255.0 alpha:1]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewItemClick:) name:TBViewItemClickNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TBViewItemClickNotification object:nil];
}

- (void)viewItemClick:(NSNotification *)notification {
    WebViewController *webController = [[WebViewController alloc] init];
    webController.url = notification.object;
    [self.navigationController pushViewController:webController animated:YES];
}

@end
