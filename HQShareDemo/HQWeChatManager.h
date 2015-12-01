//
//  HQWeChatManager.h
//  HQShareDemo
//
//  Created by ttlgz-0022 on 15/12/1.
//  Copyright © 2015年 Transaction Technologies Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"
#import "WebServiceRequestHandler.h"

#define kWXAppKey @""
#define kSecret   @""
#define AuthorizationURL @"https://api.weixin.qq.com/sns/oauth2/access_token?"
#define GetUserinfoURL   @"https://api.weixin.qq.com/sns/userinfo?"
#define UrlStr   @""
@interface HQWeChatManager : NSObject<WXApiDelegate,WebServiceRequestHandlerDelegate>
+ (HQWeChatManager *)shareWeChatManager;
- (void)shareToWeixinSession;
- (void)shareToWeixinTimeline;
- (void)loginWeChat;
@end
