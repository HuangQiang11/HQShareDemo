//
//  HQTenCentManager.h
//  HQShareDemo
//
//  Created by ttlgz-0022 on 15/12/1.
//  Copyright © 2015年 Transaction Technologies Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/TencentApiInterface.h>
#import <TencentOpenAPI/QQApiInterface.h>

#define kTenAppKey @""
#define RebackUrl  @""
@interface HQTenCentManager : NSObject<TencentSessionDelegate>
@property (nonatomic, strong) TencentOAuth * oauth;

+ (HQTenCentManager *)shareTenCentManager;
- (void)loginTenCent;
- (void)shareMessageToQQ;
- (void)shareMessageToToQZone;
@end
