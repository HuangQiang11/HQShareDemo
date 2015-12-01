//
//  HQWeiboManager.m
//  HQShareDemo
//
//  Created by ttlgz-0022 on 15/12/1.
//  Copyright © 2015年 Transaction Technologies Limited. All rights reserved.
//

#import "HQWeiboManager.h"

@implementation HQWeiboManager
static HQWeiboManager * manager;

+ (HQWeiboManager *)shareWeiboManager{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        manager = [[HQWeiboManager alloc] init];
    });
    return manager;
}

#pragma mark common method
- (void)loginWeibo{
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = kRedirectURI;
    request.scope = @"all";
    request.userInfo = @{@"SSO_From": @"SendMessageToWeiboViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    [WeiboSDK sendRequest:request];
}

- (void)shareToWeiboWith:(NSString *)message{
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.redirectURI = kRedirectURI;
    authRequest.scope = @"all";
    
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:[self messageToShare:message] authInfo:authRequest access_token:@"2.00JMd_rCA8tTcEf43d34436dqr3nXD"];
    request.userInfo = @{@"ShareMessageFrom": @"SendMessageToWeiboViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    [WeiboSDK sendRequest:request];
}

- (void)logoutWeibo{
    [WeiboSDK logOutWithToken:self.wbtoken delegate:self withTag:@"user1"];
}

- (void)getFriendsListOfUser
{
    
    //just set extraPara for http request as you want, more paras description can be found on the API website,
    //for this API, details are from http://open.weibo.com/wiki/2/friendships/friends/en .
    //    NSMutableDictionary* extraParaDict = [NSMutableDictionary dictionary];
    //    [extraParaDict setObject:@"2" forKey:@"cursor"];
    //    [extraParaDict setObject:@"3" forKey:@"count"];
    
    [WBHttpRequest requestForFriendsListOfUser:self.wbCurrentUserID withAccessToken:self.wbtoken andOtherProperties:nil queue:nil withCompletionHandler:^(WBHttpRequest *httpRequest, id result, NSError *error) {
        
        DemoRequestHanlder(httpRequest, result, error);
        NSLog(@"result:%@",result);
        
        
    }];
    
}


#pragma mark private method
- (WBMessageObject *)messageToShare:(NSString *) messageStr
{
    WBMessageObject *message = [WBMessageObject message];
    message.text = messageStr;
    WBWebpageObject *webpage = [WBWebpageObject object];
    webpage.objectID = @"identifier1";
    webpage.title = @"title";
    webpage.description = @"description";
    webpage.thumbnailData = UIImageJPEGRepresentation([UIImage imageNamed:@"applogo"], 0.5);
    webpage.webpageUrl = kRedirectURI;
    message.mediaObject = webpage;
    return message;
}

void DemoRequestHanlder(WBHttpRequest *httpRequest, id result, NSError *error)
{
    NSString *title = nil;
    UIAlertView *alert = nil;
    
    if (error)
    {
        title = NSLocalizedString(@"请求异常", nil);
        alert = [[UIAlertView alloc] initWithTitle:title
                                           message:[NSString stringWithFormat:@"%@",error]
                                          delegate:nil
                                 cancelButtonTitle:NSLocalizedString(@"确定", nil)
                                 otherButtonTitles:nil];
    }
    else
    {
        title = NSLocalizedString(@"收到网络回调", nil);
        alert = [[UIAlertView alloc] initWithTitle:title
                                           message:[NSString stringWithFormat:@"%@",result]
                                          delegate:nil
                                 cancelButtonTitle:NSLocalizedString(@"确定", nil)
                                 otherButtonTitles:nil];
    }
    
    [alert show];
}


#pragma mark weibo delegate
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
    {
        WBSendMessageToWeiboResponse* sendMessageToWeiboResponse = (WBSendMessageToWeiboResponse*)response;
        NSString* accessToken = [sendMessageToWeiboResponse.authResponse accessToken];
        if (accessToken)
        {
            NSLog(@"accessToken:%@",accessToken);
        }
        NSString* userID = [sendMessageToWeiboResponse.authResponse userID];
        if (userID) {
            NSLog(@"userID:%@",userID);
        }
        NSLog(@"%@",response.requestUserInfo);
        NSLog(@"%@",response.userInfo);
    }
    else if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
        NSLog(@"accessToken:%@",[(WBAuthorizeResponse *)response accessToken]);
        self.wbtoken = [(WBAuthorizeResponse *)response accessToken];
        self.wbCurrentUserID = [(WBAuthorizeResponse *)response userID];
        NSLog(@"%@",response.requestUserInfo);
        NSLog(@"%@",response.userInfo);
    }
}
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    
}

@end
