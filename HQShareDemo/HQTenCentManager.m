//
//  HQTenCentManager.m
//  HQShareDemo
//
//  Created by ttlgz-0022 on 15/12/1.
//  Copyright © 2015年 Transaction Technologies Limited. All rights reserved.
//

#import "HQTenCentManager.h"

@implementation HQTenCentManager
static HQTenCentManager * manager;

+ (HQTenCentManager *)shareTenCentManager{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        manager = [[HQTenCentManager alloc] init];
        [manager authorize];
    });
    return manager;
}

- (void)authorize{
    self.oauth = [[TencentOAuth alloc] initWithAppId:kTenAppKey andDelegate:self];
}

#pragma mark common
- (void)loginTenCent{
    NSArray* permissions = [NSArray arrayWithObjects:
                            kOPEN_PERMISSION_GET_USER_INFO,
                            kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                            kOPEN_PERMISSION_ADD_ALBUM,
                            kOPEN_PERMISSION_ADD_IDOL,
                            kOPEN_PERMISSION_ADD_ONE_BLOG,
                            kOPEN_PERMISSION_ADD_PIC_T,
                            kOPEN_PERMISSION_ADD_SHARE,
                            kOPEN_PERMISSION_ADD_TOPIC,
                            kOPEN_PERMISSION_CHECK_PAGE_FANS,
                            kOPEN_PERMISSION_DEL_IDOL,
                            kOPEN_PERMISSION_DEL_T,
                            kOPEN_PERMISSION_GET_FANSLIST,
                            kOPEN_PERMISSION_GET_IDOLLIST,
                            kOPEN_PERMISSION_GET_INFO,
                            kOPEN_PERMISSION_GET_OTHER_INFO,
                            kOPEN_PERMISSION_GET_REPOST_LIST,
                            kOPEN_PERMISSION_LIST_ALBUM,
                            kOPEN_PERMISSION_UPLOAD_PIC,
                            kOPEN_PERMISSION_GET_VIP_INFO,
                            kOPEN_PERMISSION_GET_VIP_RICH_INFO,
                            kOPEN_PERMISSION_GET_INTIMATE_FRIENDS_WEIBO,
                            kOPEN_PERMISSION_MATCH_NICK_TIPS_WEIBO,
                            nil];
    
    [self.oauth authorize:permissions inSafari:NO];
}

- (void)shareMessageToQQ{
    
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:[self setBaseMessage]];
    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    [self handleSendResult:sent];
}

- (void)shareMessageToToQZone{
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:[self setBaseMessage]];
    QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
    [self handleSendResult:sent];
}

- (QQApiNewsObject *)setBaseMessage{
    NSData *imageData = UIImageJPEGRepresentation([UIImage imageNamed:@"applogo"], 0.5);
    QQApiNewsObject *txtObj = [QQApiNewsObject
                               objectWithURL:[NSURL URLWithString:RebackUrl]
                               title:@"title"
                               description:@"description"
                               previewImageData:imageData];
    return txtObj;
}

- (void)handleSendResult:(QQApiSendResultCode)sendResult
{
    switch (sendResult)
    {
        case EQQAPIAPPNOTREGISTED:
        {
            NSLog(@"App未注册");
            break;
        }
        case EQQAPIMESSAGECONTENTINVALID:
        case EQQAPIMESSAGECONTENTNULL:
        case EQQAPIMESSAGETYPEINVALID:
        {
            NSLog(@"发送参数错误");
            break;
        }
        case EQQAPIQQNOTINSTALLED:
        {
            NSLog(@"未安装手Q");
            break;
        }
        case EQQAPIQQNOTSUPPORTAPI:
        {
            NSLog(@"API接口不支持");
            break;
        }
        case EQQAPISENDFAILD:
        {
            NSLog(@"发送失败");
            break;
        }
        case EQQAPISENDSUCESS:
        {
            NSLog(@"发送成功");
            break;
        }
        default:
        {
            break;
        }
    }
}


#pragma mark TencentSessionDelegate

- (void)tencentDidLogin
{
    NSLog(@"tencentDidLogin");
    if (NO == [self.oauth getUserInfo]) {
        NSLog(@"didNotGetUserInfo");
    };
}

- (void)tencentDidNotLogin:(BOOL)cancelled
{
    NSLog(@"tencentDidNotLogin");
}

- (void)tencentDidNotNetWork
{
    NSLog(@"tencentDidNotNetWork");
}

- (NSArray *)getAuthorizedPermissions:(NSArray *)permissions withExtraParams:(NSDictionary *)extraParams
{
    return nil;
}

- (void)tencentDiNSLogout
{
    
}


- (BOOL)tencentNeedPerformIncrAuth:(TencentOAuth *)tencentOAuth withPermissions:(NSArray *)permissions
{
    return YES;
}


- (BOOL)tencentNeedPerformReAuth:(TencentOAuth *)tencentOAuth
{
    return YES;
}

- (void)tencentDidUpdate:(TencentOAuth *)tencentOAuth
{
}


- (void)tencentFailedUpdate:(UpdateFailType)reason
{
}


- (void)getUserInfoResponse:(APIResponse*) response
{
    NSLog(@"getUserInfoResponse:%@",response.message);
    if (URLREQUEST_SUCCEED == response.retCode && kOpenSDKErrorSuccess == response.detailRetCode)
    {
        NSMutableString *str=[NSMutableString stringWithFormat:@""];
        for (id key in response.jsonResponse)
        {
            [str appendString: [NSString stringWithFormat:@"%@:%@\n",key,[response.jsonResponse objectForKey:key]]];
        }
        NSLog(@"getUserInfo Success");
    }
    else
    {
        NSLog(@"getUserInfo fail");
    }
    
}


- (void)getListAlbumResponse:(APIResponse*) response
{
    
}


- (void)getListPhotoResponse:(APIResponse*) response
{
    
}


- (void)checkPageFansResponse:(APIResponse*) response
{
    
}


- (void)addShareResponse:(APIResponse*) response
{
    
}


- (void)addAlbumResponse:(APIResponse*) response
{
    
}

- (void)uploadPicResponse:(APIResponse*) response
{
    
}

- (void)addOneBlogResponse:(APIResponse*) response
{
    
}

- (void)addTopicResponse:(APIResponse*) response
{
    
}


- (void)setUserHeadpicResponse:(APIResponse*) response
{
    
}


- (void)getVipInfoResponse:(APIResponse*) response
{
    
}


- (void)getVipRichInfoResponse:(APIResponse*) response
{
    
}


- (void)matchNickTipsResponse:(APIResponse*) response
{
    
}


- (void)getIntimateFriendsResponse:(APIResponse*) response
{
    
}


- (void)sendStoryResponse:(APIResponse*) response
{
    
}

- (void)tencentOAuth:(TencentOAuth *)tencentOAuth didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite userData:(id)userData
{
    
}


- (void)tencentOAuth:(TencentOAuth *)tencentOAuth doCloseViewController:(UIViewController *)viewController
{
    
}


@end
