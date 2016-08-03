//
//  ViewController.m
//  手势密码锁
//
//  Created by lzldy on 16/2/25.
//  Copyright © 2016年 lzldy. All rights reserved.
//

#import "ViewController.h"
#import "lzlView.h"

@interface ViewController ()<lzlLockViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *bImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [bImageView setImage:[UIImage imageNamed:@"Home_refresh_bg"]];
    [self.view addSubview:bImageView];
    
    lzlView *bView=[[lzlView alloc]initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, 100)];
    bView.delegate=self;
    [self.view addSubview:bView];
    
}

-(void)lockView:(lzlView *)lockView didFinishPath:(NSString *)path{
    if ([path isEqualToString:@"012345678"]) {
        [self alertWithTitle:@"密码正确" AndMessage:nil];
    }else{
        [self alertWithTitle:@"密码错误" AndMessage:nil];
    }
}

-(void)alertWithTitle:(NSString *)title AndMessage:(NSString *)message{
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
