//
//  WebServiceRequestHandler.h
//  iGathering
//
//  Created by RyanLee on 5/25/15.
//  Copyright (c) 2015 Transaction Technologies Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

#define kPOST @"POSTMETHOD"
#define kGET @"GETMETHOD"
#define kPUT @"PUTTMETHOD"
#define kDELETE @"DELETEMETHOD"
@protocol WebServiceRequestHandlerDelegate <NSObject>

- (void)webServiceRequested:(AFHTTPRequestOperation *)operation parsed:(NSMutableDictionary *)responseDict;
- (void)webServiceRequestFailed:(AFHTTPRequestOperation *)operation error:(NSError *)error;

@end

@interface WebServiceRequestHandler : NSObject


+ (WebServiceRequestHandler *)shareWebServiceRequestHandler;
- (void)loadWebServiceRequestWithParams:(NSMutableDictionary *)params aURL:(NSString *)aURL method:(NSString *)method delegate:(id) delegate;

@end
