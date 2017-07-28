//
//  DemoViewController.m
//  TitleAndViewChange
//
//  Created by GHZ on 2017/7/28.
//  Copyright © 2017年 hongzhong. All rights reserved.
//

#import "DemoViewController.h"

@interface DemoViewController ()

@end

@implementation DemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 添加子控制器
    [self setupChildViewController];
}

- (void)setupChildViewController {
    
    UIViewController *vc = [[UIViewController alloc] init];
    vc.view.backgroundColor = [UIColor lightGrayColor];
    vc.title = @"独孤九剑";
    [self addChildViewController:vc];
    
    UIViewController *vc1 = [[UIViewController alloc] init];
    vc1.view.backgroundColor = [UIColor greenColor];
    vc1.title = @"葵花宝典";
    [self addChildViewController:vc1];
}

@end
