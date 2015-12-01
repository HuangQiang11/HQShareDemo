//
//  ViewController.m
//  HQShareDemo
//
//  Created by ttlgz-0022 on 15/12/1.
//  Copyright © 2015年 Transaction Technologies Limited. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)QQLogin:(id)sender {
    [[HQTenCentManager shareTenCentManager] loginTenCent];
}
- (IBAction)WeiBoLogin:(id)sender {
    [[HQWeiboManager shareWeiboManager] loginWeibo];
}
- (IBAction)weChatLogin:(id)sender {
    [[HQWeChatManager shareWeChatManager] loginWeChat];
}
- (IBAction)QQShare:(id)sender {
    [[HQTenCentManager shareTenCentManager] shareMessageToQQ];
}
- (IBAction)weiboShare:(id)sender {
    [[HQWeiboManager shareWeiboManager] shareToWeiboWith:@"message"];
}
- (IBAction)wechatShare:(id)sender {
    [[HQWeChatManager shareWeChatManager] shareToWeixinSession];
}
- (IBAction)QzoneShare:(id)sender {
    [[HQTenCentManager shareTenCentManager] shareMessageToToQZone];
}
- (IBAction)MonentsShare:(id)sender {
    [[HQWeChatManager shareWeChatManager] shareToWeixinTimeline];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
