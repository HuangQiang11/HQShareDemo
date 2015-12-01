//
//  HQWeiboManager.h
//  HQShareDemo
//
//  Created by ttlgz-0022 on 15/12/1.
//  Copyright © 2015年 Transaction Technologies Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeiboSDK.h"

#define kWBAppKey         @""
#define kRedirectURI      @""  //授权回调页
@interface HQWeiboManager : NSObject<WeiboSDKDelegate, WBHttpRequestDelegate>
@property (nonatomic, strong) NSString * wbtoken;
@property (nonatomic, strong) NSString * wbCurrentUserID;
+ (HQWeiboManager *)shareWeiboManager;
- (void)loginWeibo;
- (void)shareToWeiboWith:(NSString *)message;
- (void)logoutWeibo;
- (void)getFriendsListOfUser;
@end
