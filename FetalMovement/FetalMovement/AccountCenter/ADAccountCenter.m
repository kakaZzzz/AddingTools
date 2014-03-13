//
//  ADAccountCenter.m
//  FetalMovement
//
//  Created by wangpeng on 14-3-11.
//  Copyright (c) 2014年 wang peng. All rights reserved.
//

#import "ADAccountCenter.h"
#import "MKNetworkKit.h"
#import "ADNetwork.h"

@interface ADAccountCenter()
@property(nonatomic,strong)MKNetworkEngine *engine;
@property(nonatomic,assign)int sinaType;
@end
@implementation ADAccountCenter
//singleton synthesize

+ (ADAccountCenter *)sharedADAccountCenter {
    static ADAccountCenter *sharedADAccountCenter = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedADAccountCenter = [[self alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:sharedADAccountCenter selector:@selector(getSinaTokenSuccessful:) name:OAthoBySinaSuccessfulNotification object:nil];
    });
    return sharedADAccountCenter;
}


#pragma mark - private method
- (void)getSinaTokenSuccessful:(NSNotification *)notification
{
    switch (_sinaType) {
        case SINA_TYPE_LOGIN://登录时获取token
            [[NSNotificationCenter defaultCenter] postNotificationName:LoginBySinaSuccessfulNotification object:nil userInfo:[notification userInfo]];
            break;
        case SINA_TYPE_OATHO://设置里授权获取token
            [[NSNotificationCenter defaultCenter] postNotificationName:SettingBySinaSuccessfulNotification object:nil userInfo:[notification userInfo]];
            break;
        case SINA_TYPE_SHARE://分享获取token
            [[NSNotificationCenter defaultCenter] postNotificationName:ShareBySinaSuccessfulNotification object:nil userInfo:[notification userInfo]];
            break;
            
        default:
            break;
    }
}

/**
 *  用户注册
 *
 *  @param name     手机号
 *  @param pass     密码
 *  @param target   id target
 *  @param success SEL 成功回调方法
 *  @param failure SEL 失败回调方法
 */

- (void)userRegisterWithPhone:(NSString*)name passWord:(NSString*)pass withTarget:(id)target success:(SEL)success failure:(SEL)failure;
{
    
    //用MKNetworkKit进行异步网络请求
    /*GET请求 示例*/
    // NSString *utf8Name = [self GBKToUtf8Encoding:name];
    
    
    self.engine = [[MKNetworkEngine alloc] initWithHostName:HTTP_TEST_HOST customHeaderFields:nil];
    MKNetworkOperation *op = [_engine operationWithPath:[NSString stringWithFormat:@"api_account/register?phone=%@&password=%@", name,pass] params:nil httpMethod:@"GET" ssl:NO];
    
    NSLog(@"请求接口是%@",op);
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSLog(@"[operation responseData]-->>%@", [operation responseString]);
        
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:[operation responseData] options:NSJSONReadingAllowFragments error:nil];
        //解析字典中得数据，判断是否注册成功，并返回失败原因
        
        if ([resultDic objectForKey:@"error"] ==nil) {
            NSString *uid = [resultDic objectForKey:@"uid"];
            if (target && [target respondsToSelector:success]) {
                [target performSelectorOnMainThread:success withObject:uid waitUntilDone:NO];
            }
            
        }else{
            
            NSString * errorCode = [resultDic objectForKey:@"error_code"];
            NSLog(@"错误码是多少？%@",errorCode);
            if (target && [target respondsToSelector:success]) {
                [target performSelectorOnMainThread:failure withObject:errorCode waitUntilDone:NO];
            }
            
        }
        
        
    }errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
        
        //请求数据错误
        NSLog(@"MKNetwork request error------ : %@", [err localizedDescription]);
        
    }];
    [_engine enqueueOperation:op];
    
    
    
    
}

/**
 *  用户注册
 *
 *  @param name     邮箱
 *  @param pass     密码
 *  @param target   id target
 *  @param success SEL 成功回调方法
 *  @param failure SEL 失败回调方法
 */
- (void)userRegisterWithEmail:(NSString*)name passWord:(NSString*)pass withTarget:(id)target success:(SEL)success failure:(SEL)failure
{
    self.engine = [[MKNetworkEngine alloc] initWithHostName:HTTP_TEST_HOST customHeaderFields:nil];
    MKNetworkOperation *op = [_engine operationWithPath:[NSString stringWithFormat:@"api_account/register?email=%@&password=%@", name,pass] params:nil httpMethod:@"GET" ssl:NO];
    
    NSLog(@"请求接口是%@",op);
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSLog(@"[operation responseData]-->>%@", [operation responseString]);
        
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:[operation responseData] options:NSJSONReadingAllowFragments error:nil];
        //解析字典中得数据，判断是否注册成功，并返回失败原因
        
        if ([resultDic objectForKey:@"error"] ==nil) {
            NSString *uid = [resultDic objectForKey:@"uid"];
            if (target && [target respondsToSelector:success]) {
                [target performSelectorOnMainThread:success withObject:uid waitUntilDone:NO];
            }
            
        }else{
            
            NSString * errorCode = [resultDic objectForKey:@"error_code"];
            NSLog(@"错误码是多少？%@",errorCode);
            if (target && [target respondsToSelector:success]) {
                [target performSelectorOnMainThread:failure withObject:errorCode waitUntilDone:NO];
            }
            
        }
        
        
    }errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
        
        //请求数据错误
        NSLog(@"MKNetwork request error------ : %@", [err localizedDescription]);
        
    }];
    [_engine enqueueOperation:op];
    
}



//手机号登录
- (void)userLoginWithPhone:(NSString*)name passWord:(NSString*)pass withTarget:(id)target success:(SEL)success failure:(SEL)failure
{
    
    
    self.engine = [[MKNetworkEngine alloc] initWithHostName:LOGIN_TEST_HOST customHeaderFields:nil];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    [dic setValue:@"100" forKey:@"client_id"];
    [dic setValue:@"add3ing5add7ing" forKey:@"client_secret"];
    [dic setValue:@"password" forKey:@"grant_type"];
    
    [dic setValue:name forKey:@"username"];
    [dic setValue:pass forKey:@"password"];
    
    MKNetworkOperation *op = [_engine operationWithPath:nil params:dic httpMethod:@"POST"];
    //    MKNetworkOperation *op = [engine operationWithPath:[NSString stringWithFormat:@"api_oauth2/token?client_id=100&client_secret=add3ing5add7ing&grant_type=password&username=%@&password=%@", name,pass] params:nil httpMethod:@"GET" ssl:NO];
    
    NSLog(@"请求接口是%@",op);
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSLog(@"[operation responseData]-->>%@", [operation responseString]);
        
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:[operation responseData] options:NSJSONReadingAllowFragments error:nil];
        //解析字典中得数据，判断是否注册成功，并返回失败原因
        
        if ([resultDic objectForKey:@"error"] ==nil) {
            NSString *access_token = [resultDic objectForKey:@"access_token"];
            if (target && [target respondsToSelector:success]) {
                [target performSelectorOnMainThread:success withObject:access_token waitUntilDone:NO];
            }
            
        }else{
            
            NSString * errorCode = [resultDic objectForKey:@"error_code"];
            NSLog(@"错误码是多少？%@",errorCode);
            if (target && [target respondsToSelector:success]) {
                [target performSelectorOnMainThread:failure withObject:errorCode waitUntilDone:NO];
            }
            
        }
        
        
    }errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
        
        //请求数据错误
        NSLog(@"MKNetwork request error------ : %@", [err localizedDescription]);
        
    }];
    [_engine enqueueOperation:op];
    
}
//邮箱登录
- (void)userLoginWithEmail:(NSString*)name passWord:(NSString*)pass withTarget:(id)target success:(SEL)success failure:(SEL)failure
{
    
    
    self.engine = [[MKNetworkEngine alloc] initWithHostName:LOGIN_TEST_HOST customHeaderFields:nil];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    [dic setValue:@"100" forKey:@"client_id"];
    [dic setValue:@"add3ing5add7ing" forKey:@"client_secret"];
    [dic setValue:@"password" forKey:@"grant_type"];
    
    [dic setValue:name forKey:@"username"];
    [dic setValue:pass forKey:@"password"];
    
    MKNetworkOperation *op = [_engine operationWithPath:nil params:dic httpMethod:@"POST"];
    //    MKNetworkOperation *op = [engine operationWithPath:[NSString stringWithFormat:@"api_oauth2/token?client_id=100&client_secret=add3ing5add7ing&grant_type=password&username=%@&password=%@", name,pass] params:nil httpMethod:@"GET" ssl:NO];
    
    NSLog(@"请求接口是%@",op);
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSLog(@"[operation responseData]-->>%@", [operation responseString]);
        
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:[operation responseData] options:NSJSONReadingAllowFragments error:nil];
        //解析字典中得数据，判断是否注册成功，并返回失败原因
        
        if ([resultDic objectForKey:@"error"] ==nil) {
            NSString *access_token = [resultDic objectForKey:@"access_token"];
            if (target && [target respondsToSelector:success]) {
                [target performSelectorOnMainThread:success withObject:access_token waitUntilDone:NO];
            }
            
        }else{
            
            NSString * errorCode = [resultDic objectForKey:@"error_code"];
            NSLog(@"错误码是多少？%@",errorCode);
            if (target && [target respondsToSelector:success]) {
                [target performSelectorOnMainThread:failure withObject:errorCode waitUntilDone:NO];
            }
            
        }
        
        
    }errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
        
        //请求数据错误
        NSLog(@"MKNetwork request error------ : %@", [err localizedDescription]);
        
    }];
    [_engine enqueueOperation:op];
    
}

- (NSString *)GBKToUtf8Encoding:(NSString *)aString

{
    
    NSMutableString *GBKString = [NSMutableString stringWithFormat:@""];
    
    for (int i = 0 ; i < [aString length] ; i++)
        
    {
        
        NSUInteger index = i;
        
        //获取该字符转化为字符串，然后才可以调用编码方法（编码方法是针对字符串的）
        
        NSString *strTmp = [[NSString stringWithFormat:@"%C",[aString characterAtIndex:index]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        //拼接字符串
        [GBKString appendString:strTmp];
        
    }
    
    return GBKString;
    
}
/**
 *  将第三方账号token发给本地服务器。第三方登录
 */
- (void)postThirdpartyTokenTolocalServer:(NSString *)token thirdPartyType:(ADACCOUNT_TYPE)type
{
    
    
    
    self.engine = [[MKNetworkEngine alloc] initWithHostName:HTTP_TEST_HOST customHeaderFields:nil];
    MKNetworkOperation *op;
    switch (type) {
        case ADACCOUNT_TYPE_SINA:
            op = [_engine operationWithPath:[NSString stringWithFormat:@"api_account/partner_login?partner_token=%@&partner=weibo",token] params:nil httpMethod:@"GET" ssl:NO];
            break;
        case ADACCOUNT_TYPE_TENCENT:
            op = [_engine operationWithPath:[NSString stringWithFormat:@"api_account/partner_login?partner_token=%@&partner=qq",token] params:nil httpMethod:@"GET" ssl:NO];
            break;
        case ADACCOUNT_TYPE_BAIDU:
            op = [_engine operationWithPath:[NSString stringWithFormat:@"api_account/partner_login?partner_token%@&partner=baidu",token] params:nil httpMethod:@"GET" ssl:NO];
            break;
        default:
            break;
    }
    
    
    NSLog(@"请求接口是%@",op);
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSLog(@"[operation responseData]-->>%@", [operation responseString]);
        
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:[operation responseData] options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"合并token是什么%@",resultDic);
        if ([[NSUserDefaults standardUserDefaults] objectForKey:ACCOUNT_ADDING_TOKEN] == nil) {
            [[NSUserDefaults standardUserDefaults] setObject:[resultDic objectForKey:@"access_token"] forKey:ACCOUNT_ADDING_TOKEN];//加丁token.并保存起来
        }
        
        
        
    }errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
        
        //请求数据错误
        NSLog(@"MKNetwork request error------ : %@", [err localizedDescription]);
        
        
    }];
    [_engine enqueueOperation:op];
    
    
    
}

/**
 *  将第三方账号token发给本地服务器 进行绑定
 */

- (void)bindingThirdpartyToken:(NSString *)token thirdPartyType:(ADACCOUNT_TYPE)type
{
    self.engine = [[MKNetworkEngine alloc] initWithHostName:HTTP_TEST_HOST customHeaderFields:nil];
    MKNetworkOperation *op;
    //定参数
    NSString *oauth_token = [[NSUserDefaults standardUserDefaults] objectForKey:ACCOUNT_ADDING_TOKEN];
    
    
    switch (type) {
        case ADACCOUNT_TYPE_SINA:
            op = [_engine operationWithPath:[NSString stringWithFormat:@"api_account/partner_bind?oauth_token=%@&partner_token=%@&partner=weibo&bind=1",oauth_token,token] params:nil httpMethod:@"GET" ssl:NO];
            break;
        case ADACCOUNT_TYPE_TENCENT:
            op = [_engine operationWithPath:[NSString stringWithFormat:@"api_account/partner_bind?oauth_token=%@&partner_token=%@&partner=qq&bind=1",oauth_token,token] params:nil httpMethod:@"GET" ssl:NO];
            break;
        case ADACCOUNT_TYPE_BAIDU:
            op = [_engine operationWithPath:[NSString stringWithFormat:@"api_account/partner_bind?oauth_token=%@&partner_token=%@&partner=baidu&bind=1",oauth_token,token] params:nil httpMethod:@"GET" ssl:NO];
            break;
        default:
            break;
    }
    
    
    NSLog(@"请求接口是%@",op);
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSLog(@"[operation responseData]-->>%@", [operation responseString]);
        
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:[operation responseData] options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"合并token是什么%@",resultDic);
        
        //后续操作，绑定成功还是失败再进行操作........
        
    }errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
        
        //请求数据错误
        NSLog(@"MKNetwork request error------ : %@", [err localizedDescription]);
        
        
    }];
    [_engine enqueueOperation:op];
    
}

/**
 *  将第三方账号token发给本地服务器 解除绑定
 */

- (void)removeBindingThirdpartyToken:(NSString *)token thirdPartyType:(ADACCOUNT_TYPE)type
{
    self.engine = [[MKNetworkEngine alloc] initWithHostName:HTTP_TEST_HOST customHeaderFields:nil];
    MKNetworkOperation *op;
    //定参数
    NSString *oauth_token = [[NSUserDefaults standardUserDefaults] objectForKey:ACCOUNT_ADDING_TOKEN];
    
    
    switch (type) {
        case ADACCOUNT_TYPE_SINA:
            op = [_engine operationWithPath:[NSString stringWithFormat:@"api_account/partner_bind?oauth_token=%@&partner=weibo&bind=0",oauth_token] params:nil httpMethod:@"GET" ssl:NO];
            break;
        case ADACCOUNT_TYPE_TENCENT:
            op = [_engine operationWithPath:[NSString stringWithFormat:@"api_account/partner_bind?oauth_token=%@&partner=qq&bind=0",oauth_token] params:nil httpMethod:@"GET" ssl:NO];
            break;
        case ADACCOUNT_TYPE_BAIDU:
            op = [_engine operationWithPath:[NSString stringWithFormat:@"api_account/partner_bind?oauth_token=%@&partner=baidu&bind=0",oauth_token] params:nil httpMethod:@"GET" ssl:NO];
            break;
        default:
            break;
    }
    
    
    NSLog(@"请求接口是%@",op);
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSLog(@"[operation responseData]-->>%@", [operation responseString]);
        
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:[operation responseData] options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"合并token是什么%@",resultDic);
        
        //后续操作，绑定成功还是失败再进行操作........
        
    }errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
        
        //请求数据错误
        NSLog(@"MKNetwork request error------ : %@", [err localizedDescription]);
        
        
    }];
    [_engine enqueueOperation:op];
    
    
}


#pragma mark - 新浪账户有关操作
/**
 *  新浪账号登录操作，获得新浪微博授权
 */

- (void)loginOAuthSina
{
    _sinaType = SINA_TYPE_LOGIN;
 
    [self sinaOAuthRequest];
}
/**
 *  仅仅获得新浪微博授权
 */
- (void)getOAuthSina
{
    _sinaType = SINA_TYPE_OATHO;
    [self sinaOAuthRequest];
 }

- (void)sinaOAuthRequest
{
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = kSinaRedirectURI;
    request.scope = @"all";
    
    [WeiboSDK sendRequest:request];

}
/**
 *  取消新浪微博授权
 */
- (void)outOAuthSina
{
    NSString *sinaToken = [[NSUserDefaults standardUserDefaults] objectForKey:ACCOUNT_SINA_TOKEN];
    [WeiboSDK logOutWithToken:sinaToken delegate:self withTag:@"sina"];
    
}

/**
 *  获取新浪微博用户昵称
 */
- (void)getSinaUserInfoWiheToken:(NSString *)token uid:(NSString *)uid
{
    self.engine = [[MKNetworkEngine alloc] initWithHostName:@"api.weibo.com/2/users" customHeaderFields:nil];
    
    
    MKNetworkOperation * op = [_engine operationWithPath:[NSString stringWithFormat:@"show.json?source=%@&access_token=%@&uid=%@",kSinaAppKey,token,uid] params:nil httpMethod:@"GET" ssl:NO];
    
    NSLog(@"请求接口是%@",op);
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSLog(@"[operation responseData]-->>%@", [operation responseString]);
        
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:[operation responseData] options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"新浪用户信息是%@",resultDic);
        
        //后续操作，绑定成功还是失败再进行操作........
        
    }errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
        
        //请求数据错误
        NSLog(@"MKNetwork request error------ : %@", [err localizedDescription]);
        
        
    }];
    [_engine enqueueOperation:op];
    
}

/**
 *  分享文字和图片到新浪微博
 */
- (void)shareToSinaWeiboWithText:(NSString *)text picture:(NSData *)pictureData
{
    
    
    
    if (pictureData == nil) {
        [self shareToSinaWeiboWithText:text];
    }
    
    
    else{
        
        //        NSMutableDictionary *headerFields = [NSMutableDictionary dictionary];
        //        [headerFields setValue:@"multipart/form-data" forKey:@"Content-Type"];
        
        self.engine = [[MKNetworkEngine alloc] initWithHostName:@"upload.api.weibo.com/2/statuses" customHeaderFields:nil];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        
        NSDictionary *dicSina = [[NSUserDefaults standardUserDefaults] objectForKey:ACCOUNT_SINA_KEY];
        NSString *token = [dicSina objectForKey:ACCOUNT_SINA_TOKEN];
        
        [dic setValue:text forKey:@"status"];
        [dic setValue:token forKey:@"access_token"];
        [dic setValue:pictureData forKeyPath:@"pic"];
        
        MKNetworkOperation *op = [_engine operationWithPath:@"upload.json" params:dic httpMethod:@"POST" ssl:YES];
        //         [op addHeader:@"Content-Type" withValue:@"multipart/form-data"];
        //        [op addHeader:@"Content-Type" withValue:@"multipart/form-data"];
        [op addData:pictureData forKey:@"pic"];//上传图片 @"multipart/form-data"
        NSLog(@"请求接口是%@",op);
        [op addCompletionHandler:^(MKNetworkOperation *operation) {
            NSLog(@"[operation responseData]-->>%@", [operation responseString]);
            
            NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:[operation responseData] options:NSJSONReadingAllowFragments error:nil];
            
            
            NSLog(@"分享结果......%@",resultDic);
        }errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
            
            //请求数据错误
            NSLog(@"MKNetwork request error------ : %@", [err localizedDescription]);
            
        }];
        [_engine enqueueOperation:op];
        
    }
    
    
}

- (void)shareToSinaWeiboWithText:(NSString *)text
{
    self.engine = [[MKNetworkEngine alloc] initWithHostName:@"api.weibo.com/2/statuses" customHeaderFields:nil];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    NSDictionary *dicSina = [[NSUserDefaults standardUserDefaults] objectForKey:ACCOUNT_SINA_KEY];
    NSString *token = [dicSina objectForKey:ACCOUNT_SINA_TOKEN];
    
    [dic setValue:text forKey:@"status"];
    [dic setValue:token forKey:@"access_token"];
    
    MKNetworkOperation *op = [_engine operationWithPath:@"update.json" params:dic httpMethod:@"POST" ssl:YES];
    
    NSLog(@"请求接口是%@",op);
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSLog(@"[operation responseData]-->>%@", [operation responseString]);
        
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:[operation responseData] options:NSJSONReadingAllowFragments error:nil];
        //解析字典中得数据，判断是否注册成功，并返回失败原因
        
        NSLog(@"分享结果......%@",resultDic);
    }errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
        
        //请求数据错误
        NSLog(@"MKNetwork request error------ : %@", [err localizedDescription]);
        
    }];
    [_engine enqueueOperation:op];
    
    
}

@end
