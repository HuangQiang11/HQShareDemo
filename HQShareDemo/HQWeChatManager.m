//
//  HQWeChatManager.m
//  HQShareDemo
//
//  Created by ttlgz-0022 on 15/12/1.
//  Copyright © 2015年 Transaction Technologies Limited. All rights reserved.
//

#import "HQWeChatManager.h"

@implementation HQWeChatManager
static HQWeChatManager * manager;
+ (HQWeChatManager *)shareWeChatManager{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        manager = [[HQWeChatManager alloc] init];
    });
    return manager;
    
}

- (void)loginWeChat{
    SendAuthReq* req =[[SendAuthReq alloc ] init ];
    req.scope = @"snsapi_userinfo" ;
    req.state = @"123" ;
    [WXApi sendReq:req];
}

- (void)shareToWeixinSession{
    [self shareToWeixinBase:WXSceneSession];
}

- (void)shareToWeixinTimeline{
    [self shareToWeixinBase:WXSceneTimeline];
}

- (void)shareToWeixinBase:(enum WXScene)scene
{
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"title";
    message.description = @"description";
    [message setThumbImage:[UIImage imageNamed:@"applogo"]];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = UrlStr;
    
    message.mediaObject = ext;
    message.mediaTagName = @"WECHAT_TAG_JUMP_SHOWRANK";
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = scene;
    [WXApi sendReq:req];
    
}


#pragma mark WXApiDelegate
-(void) onReq:(BaseReq*)req{
    NSLog(@"did req");
}

-(void) onResp:(BaseResp*)resp{
    if ([resp isKindOfClass:[SendMessageToWXResp class]]){
        //        SendMessageToWXResp *messageResp = (SendMessageToWXResp *)resp;
    }else if ([resp isKindOfClass:[SendAuthResp class]]){
        SendAuthResp *authResp = (SendAuthResp *)resp;
        NSLog(@"code:%@",authResp.code);
        
        NSMutableDictionary * paramDit = [NSMutableDictionary dictionary];
        [paramDit setObject:kWXAppKey forKey:@"appid"];
        [paramDit setObject:kSecret forKey:@"secret"];
        [paramDit setObject:authResp.code forKey:@"code"];
        [paramDit setObject:@"authorization_code" forKey:@"grant_type"];
        [[WebServiceRequestHandler shareWebServiceRequestHandler] loadWebServiceRequestWithParams:paramDit aURL:AuthorizationURL method:kGET delegate:self];
        
    }else if ([resp isKindOfClass:[AddCardToWXCardPackageResp class]]){
        //         AddCardToWXCardPackageResp *addCardResp = (AddCardToWXCardPackageResp *)resp;
    }
}

#pragma mark WebServiceRequestHandlerDelegate
- (void)webServiceRequested:(AFHTTPRequestOperation *)operation parsed:(NSMutableDictionary *)responseDict{
    if ([operation.request.URL.absoluteString hasPrefix:AuthorizationURL]) {
        NSMutableDictionary * paramDit = [NSMutableDictionary dictionary];
        [paramDit setObject:[responseDict objectForKey:@"access_token"] forKey:@"access_token"];
        [paramDit setObject:[responseDict objectForKey:@"openid"] forKey:@"openid"];
        
        [[WebServiceRequestHandler shareWebServiceRequestHandler] loadWebServiceRequestWithParams:paramDit aURL:GetUserinfoURL method:kGET delegate:self];
    }else if ([operation.request.URL.absoluteString hasPrefix:GetUserinfoURL]){
        NSLog(@"name:%@",[responseDict objectForKey:@"nickname"]);
    }
    NSLog(@"dict:%@",responseDict);
}
- (void)webServiceRequestFailed:(AFHTTPRequestOperation *)operation error:(NSError *)error{
    NSLog(@"webServiceRequestFailed");
}

@end
