//
//  DYMHTTPManager.m
//  Templet
//
//  Created by 丁一明 on 2018/6/15.
//  Copyright © 2018年 丁一明. All rights reserved.
//

#import "DYMHTTPManager.h"

@implementation DYMHTTPManager

+ (instancetype)sharedManager {
    static DYMHTTPManager *manager = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

-(instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (self) {
        // 请求超时设定
        self.requestSerializer.timeoutInterval = 5;
        self.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        
        self.requestSerializer = [AFHTTPRequestSerializer serializer];
        //self.requestSerializer = [AFJSONRequestSerializer serializer];
        
        //[self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept-Encoding"];
        [self.requestSerializer setValue:@"application/x-www-form-urlencoded;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [self.requestSerializer setValue:url.absoluteString forHTTPHeaderField:@"Referer"];

        
        self.responseSerializer = [AFHTTPResponseSerializer serializer];
        //self.responseSerializer = [AFJSONResponseSerializer serializer];
        
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"application/json;charset=UTF-8", @"text/plain", @"text/javascript", @"text/json", @"text/html",@"text/xml", nil];
        
        self.securityPolicy.allowInvalidCertificates = YES;
    }
    return self;
}

//get请求参数中含有中文要转码
- (NSString *)URLEncodedString:(NSString*)resource {
    NSString *result = [resource stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return result;
}

- (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

- (void)requestWithMethod:(HTTPMethod)method
                 WithPath:(NSString *)path
               WithParams:(NSDictionary*)params
         WithSuccessBlock:(requestSuccessBlock)success
          WithFailurBlock:(requestFailureBlock)failure
{
    
    //创建请求地址
    NSString *url=[self URLEncodedString:path];
    
    
    switch (method) {
        case GET:{
            [self GET:url
           parameters:params
             progress:nil
              success:^(NSURLSessionTask *task, NSDictionary * responseObject) {
                //NSLog(@"JSON: %@", responseObject);
                success(responseObject);
            }
              failure:^(NSURLSessionTask *operation, NSError *error) {
                  NSLog(@"Error: %@", error);
                  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:error.localizedDescription delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                  [alert show];
                  failure(error);
            }];
            break;
        }
        case POST:{
            
            NSString* param = [self dictionaryToJson:params];
            NSData *body  =[param dataUsingEncoding:NSUTF8StringEncoding];
            
            [self POST:path
            parameters:body
              progress:nil
               success:^(NSURLSessionTask *task, NSDictionary * responseObject) {
                NSLog(@"JSON: %@", responseObject);
                success(responseObject);
            }
               failure:^(NSURLSessionTask *operation, NSError *error) {
                NSLog(@"Error: %@", error);
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:error.localizedDescription delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                failure(error);
            }];
            break;
        }
        default:
            break;
    }
}



@end
