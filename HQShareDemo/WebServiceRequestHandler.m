//
//  WebServiceRequestHandler.m
//  iGathering
//
//  Created by RyanLee on 5/25/15.
//  Copyright (c) 2015 Transaction Technologies Limited. All rights reserved.
//

#import "WebServiceRequestHandler.h"
#import "AFHTTPRequestOperationManager.h"

@implementation WebServiceRequestHandler {
    AFHTTPRequestOperationManager *manager;
    
}

+ (WebServiceRequestHandler *)shareWebServiceRequestHandler {
    static dispatch_once_t once;
    static WebServiceRequestHandler *webServiceRequestHandler;
    dispatch_once(&once, ^{
        webServiceRequestHandler = [[WebServiceRequestHandler alloc] init];
    });
    return webServiceRequestHandler;
}

- (WebServiceRequestHandler *)init {
    self = [super init];
    if (self) {
        manager = [AFHTTPRequestOperationManager manager];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
//        manager.responseSerializer = [AFJSONResponseSerializer serializer];
//        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css",@"text/plain", nil];
    }
    return self;
}

- (void)loadWebServiceRequestWithParams:(NSMutableDictionary *)params aURL:(NSString *)aURL method:(NSString *)method delegate:(id)delegate {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"kToken"]) {
        [manager.requestSerializer setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"kToken"] forHTTPHeaderField:@"X-CSRF-Token"];
    }
    
    if ([method isEqual:kPOST]) {
        [manager POST:aURL parameters:params
              success:^(AFHTTPRequestOperation *operation, id responseObject){
                  [self requestFinished:operation delegate:delegate];
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error){
                  [self requestFailed:operation error:error delegate:delegate];
              }];
    }
    else if ([method isEqual:kGET]) {
        [manager GET:aURL parameters:params
             success:^(AFHTTPRequestOperation *operation, id responseObject){
                 [self requestFinished:operation delegate:delegate];
             }
             failure:^(AFHTTPRequestOperation *operation, NSError *error){
                 [self requestFailed:operation error:error delegate:delegate];
             }];
    }
    else if ([method isEqual:kPUT]) {
        [manager PUT:aURL parameters:params
              success:^(AFHTTPRequestOperation *operation, id responseObject){
                  [self requestFinished:operation delegate:delegate];
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error){
                  [self requestFailed:operation error:error delegate:delegate];
              }];
    }
    else if ([method isEqual:kDELETE]) {
        [manager DELETE:aURL parameters:params
                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    [self requestFinished:operation delegate:delegate];
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [self requestFailed:operation error:error delegate:delegate];
        }];
    }
}

- (void)requestFinished:(AFHTTPRequestOperation *)operation delegate:(id<WebServiceRequestHandlerDelegate>)delegate {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    NSMutableDictionary *responseDict = [[NSMutableDictionary alloc] init];
    responseDict = [NSJSONSerialization JSONObjectWithData:[operation responseData] options:NSJSONReadingMutableContainers error:nil];
    
    NSLog(@"%@\n%@ %@", operation.request.URL.absoluteString, [delegate class], responseDict);
    
    if (delegate && [delegate respondsToSelector:@selector(webServiceRequested:parsed:)]) {
        [delegate webServiceRequested:operation parsed:responseDict];
    }
}

- (void)requestFailed:(AFHTTPRequestOperation *)operation error:(NSError *)error delegate:(id<WebServiceRequestHandlerDelegate>)delegate {
    NSLog(@"%@ %@ %ld %@", operation.request.URL.absoluteString, [delegate class], (long)error.code, error.localizedDescription);
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    if (delegate && [delegate respondsToSelector:@selector(webServiceRequestFailed:error:)]) {
        [delegate webServiceRequestFailed:operation error:error];
    }
}

@end
