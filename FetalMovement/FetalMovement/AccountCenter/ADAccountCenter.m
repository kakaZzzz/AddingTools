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
#import "ADFetalMovementManager.h"
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
         [[NSNotificationCenter defaultCenter] addObserver:sharedADAccountCenter selector:@selector(getSinaTokenFailure:) name:OAthoBySinaFailureNotification object:nil];
    });
    return sharedADAccountCenter;
}


#pragma mark - private method

- (void)getSinaTokenFailure:(NSNotification *)notification
{
    switch (_sinaType) {
        case SINA_TYPE_LOGIN://登录时获取token
            [[NSNotificationCenter defaultCenter] postNotificationName:LoginBySinaFailureNotification object:nil];
            break;
        case SINA_TYPE_OATHO://设置里授权获取token
            [[NSNotificationCenter defaultCenter] postNotificationName:SettingBySinaFailureNotification object:nil];
            break;
        case SINA_TYPE_SHARE://分享获取token
            [[NSNotificationCenter defaultCenter] postNotificationName:ShareBySinaFailureNotification object:nil];
            break;
            
        default:
            break;
    }
}

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

- (void)userRegisterWithPhone:(NSString*)name passWord:(NSString*)pass codeid:(NSString *)codeid code:(NSString *)code withTarget:(id)target success:(SEL)success failure:(SEL)failure
{
    //用MKNetworkKit进行异步网络请求
    /*GET请求 示例*/
    // NSString *utf8Name = [self GBKToUtf8Encoding:name];
    
    
    self.engine = [[MKNetworkEngine alloc] initWithHostName:HTTP_TEST_HOST customHeaderFields:nil];
    [self.engine cancelAllOperations];
    MKNetworkOperation *op = [_engine operationWithPath:[NSString stringWithFormat:@"api_account/register?phone=%@&password=%@&codeId=%@&code=%@", name,pass,codeid,code] params:nil httpMethod:@"GET" ssl:NO];
    
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
 *  用户注册 请求验证码
 *
 *  @param name     手机号
 *  @param pass     密码
 *  @param target   id target
 *  @param success SEL 成功回调方法
 *  @param failure SEL 失败回调方法
 */
- (void)getCodeWhenRegisterWithPhone:(NSString*)name  withTarget:(id)target success:(SEL)success failure:(SEL)failure
{
    
    self.engine = [[MKNetworkEngine alloc] initWithHostName:HTTP_HOST customHeaderFields:nil];
    [_engine cancelAllOperations];
    MKNetworkOperation *op = [_engine operationWithPath:[NSString stringWithFormat:@"account/phone_send_code?phone=%@&type=register", name] params:nil httpMethod:@"GET" ssl:NO];
    
    NSLog(@"请求验证码的请求接口是%@",op);
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSLog(@"[operation responseData]-->>%@", [operation responseString]);
        
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:[operation responseData] options:NSJSONReadingAllowFragments error:nil];
        //解析字典中得数据，判断是否注册成功，并返回失败原因
        
        if ([resultDic objectForKey:@"error"] ==nil) {
            NSString *uid = [resultDic objectForKey:@"codeId"];
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
    [self.engine cancelAllOperations];
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
    

    

    self.engine = [[MKNetworkEngine alloc] initWithHostName:HTTP_HOST customHeaderFields:nil];
    [self.engine cancelAllOperations];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    [dic setValue:@"100" forKey:@"client_id"];
    [dic setValue:@"add3ing5add7ing" forKey:@"client_secret"];
    [dic setValue:@"password" forKey:@"grant_type"];
    
    [dic setValue:name forKey:@"username"];
    [dic setValue:pass forKey:@"password"];
    
    MKNetworkOperation *op = [_engine operationWithPath:@"oauth2/token" params:dic httpMethod:@"POST"];
    //    MKNetworkOperation *op = [engine operationWithPath:[NSString stringWithFormat:@"api_oauth2/token?client_id=100&client_secret=add3ing5add7ing&grant_type=password&username=%@&password=%@", name,pass] params:nil httpMethod:@"GET" ssl:NO];
    
    NSLog(@"加丁账号请求接口是%@",op);
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
            NSLog(@"加丁账号登录错误码是多少？%@",errorCode);
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
    
    
    self.engine = [[MKNetworkEngine alloc] initWithHostName:HTTP_HOST customHeaderFields:nil];
    [self.engine cancelAllOperations];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    [dic setValue:@"100" forKey:@"client_id"];
    [dic setValue:@"add3ing5add7ing" forKey:@"client_secret"];
    [dic setValue:@"password" forKey:@"grant_type"];
    
    [dic setValue:name forKey:@"username"];
    [dic setValue:pass forKey:@"password"];
    
    MKNetworkOperation *op = [_engine operationWithPath:@"oauth2/token" params:dic httpMethod:@"POST"];
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
/**
 *  获取用户信息
 *
 *  @param token     账号token
 *  @param target   id target
 *  @param success SEL 成功回调方法
 *  @param failure SEL 失败回调方法
 */
- (void)getUserInfoWithToken:(NSString*)token  withTarget:(id)target success:(SEL)success failure:(SEL)failure
{

    NSString *usrToken;
    if (token == nil) {
        usrToken = [[NSUserDefaults standardUserDefaults] objectForKey:ACCOUNT_ADDING_TOKEN];
        
    }else{
        usrToken = token;
    }
    
    
    self.engine = [[MKNetworkEngine alloc] initWithHostName:HTTP_HOST customHeaderFields:nil];
    [_engine cancelAllOperations];
    MKNetworkOperation *op = [_engine operationWithPath:[NSString stringWithFormat:@"account/get_full_account?oauth_token=%@", usrToken] params:nil httpMethod:@"GET" ssl:NO];
    
    NSLog(@"获取用户信息的请求接口是%@",op);
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSLog(@"[operation responseData]-->>%@", [operation responseString]);
        
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:[operation responseData] options:NSJSONReadingAllowFragments error:nil];
        
        
        if ([resultDic objectForKey:@"error"] ==nil) {
            
            NSString *nickname;
            if (![[resultDic objectForKey:@"nickname"] isEqualToString:@""]) {
                nickname = [resultDic objectForKey:@"nickname"];
            }
            
            [[NSUserDefaults standardUserDefaults] setObject:nickname forKey:ACCOUNT_ADDING_NICKNAME];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            
            if (target && [target respondsToSelector:success]) {
            [target performSelectorOnMainThread:success withObject:nickname waitUntilDone:NO];
            }
            
        }else{
            
            NSString * errorCode = [resultDic objectForKey:@"error_code"];
            NSLog(@"获取用户信息的错误码是多少？%@",errorCode);
            if (target && [target respondsToSelector:failure]) {
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
- (void)postThirdpartyTokenTolocalServer:(NSString *)token thirdPartyType:(ADACCOUNT_TYPE)type withTarget:(id)target success:(SEL)success failure:(SEL)failure
{
    
    
    self.engine = [[MKNetworkEngine alloc] initWithHostName:HTTP_HOST customHeaderFields:nil];
    [self.engine cancelAllOperations];
    MKNetworkOperation *op;
    switch (type) {
        case ADACCOUNT_TYPE_SINA:
            op = [_engine operationWithPath:[NSString stringWithFormat:@"account/partner_login?partner_token=%@&partner=weibo",token] params:nil httpMethod:@"GET" ssl:NO];
            break;
        case ADACCOUNT_TYPE_TENCENT:
            op = [_engine operationWithPath:[NSString stringWithFormat:@"account/partner_login?partner_token=%@&partner=qq",token] params:nil httpMethod:@"GET" ssl:NO];
            break;
        case ADACCOUNT_TYPE_BAIDU:
            op = [_engine operationWithPath:[NSString stringWithFormat:@"account/partner_login?partner_token%@&partner=baidu",token] params:nil httpMethod:@"GET" ssl:NO];
            break;
        default:
            break;
    }
    
    
    NSLog(@"请求接口是%@",op);
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSLog(@"[operation responseData]-->>%@", [operation responseString]);
        
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:[operation responseData] options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"合并token是什么%@",resultDic);
       // if ([[NSUserDefaults standardUserDefaults] objectForKey:ACCOUNT_ADDING_TOKEN] == nil) {
            
            [[NSUserDefaults standardUserDefaults] setObject:[resultDic objectForKey:@"access_token"] forKey:ACCOUNT_ADDING_TOKEN];//加丁token.并保存起来
            [[NSUserDefaults standardUserDefaults] synchronize];
       // }
        
        
        if ([resultDic objectForKey:@"error"] ==nil) {
            if (target && [target respondsToSelector:success]) {
                [target performSelectorOnMainThread:success withObject:nil waitUntilDone:NO];
            }
            
        }else{
            
            NSString * errorCode = [resultDic objectForKey:@"error_code"];
            NSLog(@"获取用户信息的错误码是多少？%@",errorCode);
            if (target && [target respondsToSelector:failure]) {
                [target performSelectorOnMainThread:failure withObject:errorCode waitUntilDone:NO];
            }
        }
        
    }errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
        
        if (target && [target respondsToSelector:failure]) {
            [target performSelectorOnMainThread:failure withObject:nil waitUntilDone:NO];
        }

        //请求数据错误
        NSLog(@"MKNetwork request error------ : %@", [err localizedDescription]);
        
        
    }];
    [_engine enqueueOperation:op];
    
    
    
}

/**
 *  将第三方账号token发给本地服务器 进行绑定
 */

- (void)bindingThirdpartyToken:(NSString *)token thirdPartyType:(ADACCOUNT_TYPE)type withTarget:(id)target success:(SEL)success failure:(SEL)failure;
{
    
    
    self.engine = [[MKNetworkEngine alloc] initWithHostName:HTTP_HOST customHeaderFields:nil];
    [self.engine cancelAllOperations];
    MKNetworkOperation *op;
    //定参数
    NSString *oauth_token = [[NSUserDefaults standardUserDefaults] objectForKey:ACCOUNT_ADDING_TOKEN];
    
    
    switch (type) {
        case ADACCOUNT_TYPE_SINA:
            op = [_engine operationWithPath:[NSString stringWithFormat:@"account/partner_bind?oauth_token=%@&partner_token=%@&partner=weibo&bind=1",oauth_token,token] params:nil httpMethod:@"GET" ssl:NO];
            break;
        case ADACCOUNT_TYPE_TENCENT:
            op = [_engine operationWithPath:[NSString stringWithFormat:@"account/partner_bind?oauth_token=%@&partner_token=%@&partner=qq&bind=1",oauth_token,token] params:nil httpMethod:@"GET" ssl:NO];
            break;
        case ADACCOUNT_TYPE_BAIDU:
            op = [_engine operationWithPath:[NSString stringWithFormat:@"account/partner_bind?oauth_token=%@&partner_token=%@&partner=baidu&bind=1",oauth_token,token] params:nil httpMethod:@"GET" ssl:NO];
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
        if ([resultDic objectForKey:@"error"] ==nil) {
            if (target && [target respondsToSelector:success]) {
                [target performSelectorOnMainThread:success withObject:nil waitUntilDone:NO];
            }
            
        }else{
            
            NSString * errorCode = [resultDic objectForKey:@"error_code"];
            NSLog(@"获取用户信息的错误码是多少？%@",errorCode);
            if (target && [target respondsToSelector:failure]) {
                [target performSelectorOnMainThread:failure withObject:errorCode waitUntilDone:NO];
            }
        }

    }errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
        
        //请求数据错误
        NSLog(@"MKNetwork request error------ : %@", [err localizedDescription]);
        if (target && [target respondsToSelector:failure]) {
            [target performSelectorOnMainThread:failure withObject:nil waitUntilDone:NO];
        }

        
    }];
    [_engine enqueueOperation:op];
    
}

/**
 *  将第三方账号token发给本地服务器 解除绑定
 */

- (void)removeBindingThirdpartyToken:(NSString *)token thirdPartyType:(ADACCOUNT_TYPE)type withTarget:(id)target success:(SEL)success failure:(SEL)failure
{
    

    
    self.engine = [[MKNetworkEngine alloc] initWithHostName:HTTP_HOST customHeaderFields:nil];
                   
    [self.engine cancelAllOperations];
    MKNetworkOperation *op;
    //定参数
    NSString *oauth_token = [[NSUserDefaults standardUserDefaults] objectForKey:ACCOUNT_ADDING_TOKEN];
    
    
    switch (type) {
        case ADACCOUNT_TYPE_SINA:
            op = [_engine operationWithPath:[NSString stringWithFormat:@"account/partner_bind?oauth_token=%@&partner=weibo&bind=0",oauth_token] params:nil httpMethod:@"GET" ssl:NO];
            break;
        case ADACCOUNT_TYPE_TENCENT:
            op = [_engine operationWithPath:[NSString stringWithFormat:@"account/partner_bind?oauth_token=%@&partner=qq&bind=0",oauth_token] params:nil httpMethod:@"GET" ssl:NO];
            break;
        case ADACCOUNT_TYPE_BAIDU:
            op = [_engine operationWithPath:[NSString stringWithFormat:@"account/partner_bind?oauth_token=%@&partner=baidu&bind=0",oauth_token] params:nil httpMethod:@"GET" ssl:NO];
            break;
        default:
            break;
    }
 
    NSLog(@"请求接口是%@",op);
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSLog(@"[operation responseData]-->>%@", [operation responseString]);
        
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:[operation responseData] options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"解除绑定token是什么%@",resultDic);
        
        
        if ([resultDic objectForKey:@"error"] ==nil) {
            if (target && [target respondsToSelector:success]) {
                [target performSelectorOnMainThread:success withObject:nil waitUntilDone:NO];
            }
            
        }else{
            
            NSString * errorCode = [resultDic objectForKey:@"error_code"];
            NSLog(@"解除绑定的错误码是多少？%@",errorCode);
            if (target && [target respondsToSelector:failure]) {
                [target performSelectorOnMainThread:failure withObject:errorCode waitUntilDone:NO];
            }
        }

        
    }errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
        
        //请求数据错误
        NSLog(@"MKNetwork request error------ : %@", [err localizedDescription]);
        if (target && [target respondsToSelector:failure]) {
            [target performSelectorOnMainThread:failure withObject:nil waitUntilDone:NO];
        }

        
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
    [self.engine cancelAllOperations];
    
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
        [self.engine cancelAllOperations];
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
    [self.engine cancelAllOperations];
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
#pragma mark - 将预产期存起来
/**
 *  将预产期存到userDefault里
 */
- (void)writeDuedateToUserdefalutWithDate:(NSDate *)date
{
    [[NSUserDefaults standardUserDefaults] setObject:date forKey:USER_DUEDATE_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}
/**
 *  读取预产期
 */
- (NSDate *)getDuedate
{
   return [[NSUserDefaults standardUserDefaults] objectForKey:USER_DUEDATE_KEY];
}

#pragma mark - 将用户信息存起来
/**
 *  将预产期存到userDefault里
 */
- (void)writeUserInfoToUserdefalutWithUserInfo:(NSDictionary *)userInfo
{
    [[NSUserDefaults standardUserDefaults] setObject:userInfo forKey:USER_USERINFO_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**
 *  读取用户信息
 */
- (NSDictionary *)getUserInfo
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:USER_USERINFO_KEY];
}
#pragma mark - 和云端同步数据

#pragma mark - 主动向云端发起数据
/**
 *  同步数据
 */
static int remoteSync = 0;
- (void)syncDataBySendData:(NSDate *)date
{
   
    //先拿到远程同步时间
    NSString *token =[[NSUserDefaults standardUserDefaults] objectForKey:ACCOUNT_ADDING_TOKEN];//token
    NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];//手机唯一标示符


    self.engine = [[MKNetworkEngine alloc] initWithHostName:@"api.addinghome.com" customHeaderFields:nil];
    [self.engine cancelAllOperations];
    MKNetworkOperation *op;
    if (token) {
        op = [_engine operationWithPath:[NSString stringWithFormat:@"sync/fetalMovement/get_remote_synctime?oauth_token=%@&cid=%@&anonymous=1", token,idfv] params:nil httpMethod:@"GET" ssl:NO];
    }else{
        op = [_engine operationWithPath:[NSString stringWithFormat:@"sync/fetalMovement/get_remote_synctime?cid=%@&anonymous=1",idfv] params:nil httpMethod:@"GET" ssl:NO];

    }
    
    
    NSLog(@"请求接口是%@",op);
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSLog(@"[operation responseData]-->>%@", [operation responseString]);
        
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:[operation responseData] options:NSJSONReadingAllowFragments error:nil];
        //解析字典中得数据，判断是否注册成功，并返回失败原因
        
        if ([resultDic objectForKey:@"error"] !=nil) {
            NSLog(@"请求远程同步时间时出错:");
            }
        else{
            
            NSString * remoteSyneTime = [resultDic objectForKey:@"synctime"];
            NSLog(@"远程同步时间？%@",remoteSyneTime);
            
            remoteSync = [remoteSyneTime intValue];
            
            NSNumber *localSyncTime = [[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_SYNC_TIME];
            NSNumber *localUpdateTime = [[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_UPDATE_TIME];
            if ([remoteSyneTime doubleValue] == [localSyncTime doubleValue] || [remoteSyneTime doubleValue] == 0) {
                
                if (([localUpdateTime doubleValue]!= 0) && ([localSyncTime doubleValue] < [localUpdateTime doubleValue])) {
                     //更新数据
                    [self beginSendData];
                }else{
                    NSLog(@"不用同步.....");
                }
               
            }
            
        }
        
        
    }errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
        
        //请求数据错误
        NSLog(@"MKNetwork request error------ : %@", [err localizedDescription]);
        
    }];
    [_engine enqueueOperation:op];

}
#pragma mark - 同步数据的私有方法
- (void)beginSendData
{
    NSNumber *localSyncTime = [[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_SYNC_TIME];
    NSNumber *localUpdateTime = [[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_UPDATE_TIME];
    
    //先拿到远程同步时间
    NSString *token =[[NSUserDefaults standardUserDefaults] objectForKey:ACCOUNT_ADDING_TOKEN];//token
    NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];//手机唯一标示符
    
    
    self.engine = [[MKNetworkEngine alloc] initWithHostName:@"api.addinghome.com" customHeaderFields:nil];
    [self.engine cancelAllOperations];
    MKNetworkOperation *op;
    if (token) {
        op = [_engine operationWithPath:[NSString stringWithFormat:@"sync/fetalMovement/send_begin?oauth_token=%@&cid=%@&anonymous=1", token,idfv] params:nil httpMethod:@"GET" ssl:NO];

    }else{
        op = [_engine operationWithPath:[NSString stringWithFormat:@"sync/fetalMovement/send_begin?cid=%@&anonymous=1",idfv] params:nil httpMethod:@"GET" ssl:NO];

    }
    
    NSLog(@"请求接口是%@",op);
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSLog(@"[operation responseData]-->>%@", [operation responseString]);
        
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:[operation responseData] options:NSJSONReadingAllowFragments error:nil];
        //解析字典中得数据，判断是否注册成功，并返回失败原因
        
        if ([resultDic objectForKey:@"error"] !=nil) {
            NSLog(@"请求远程同步时间时出错:");
        }
        else{
            
            NSString * batchSize = [resultDic objectForKey:@"batchSize"];
            NSString * sendId = [resultDic objectForKey:@"sendId"];
            
            NSLog(@"开始发送请求？%@    %@",batchSize,sendId);

            //从coredata中选取数据
            __block NSArray *dataArray;
            
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_queue_t queue1 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_group_t group = dispatch_group_create();
            dispatch_group_async(group, queue, ^{
                dataArray = (NSArray *)[[ADFetalMovementManager sharedADFetalMovementManager] getNeedToSyncDataWithStartDate:[localSyncTime doubleValue] endDate:[localUpdateTime doubleValue]];
                
                DLog(@"-- %@",dataArray);
                
            });
            dispatch_group_notify(group, queue1, ^{
                
                BOOL handleCom = NO;
                    int loopCount = ([dataArray count]/[batchSize intValue])+1;
                    for (int i = 0; i < loopCount; i ++) {
                        
                        int length = [batchSize intValue];
                        if (i == (loopCount -1)) {
                            length = [dataArray count]%[batchSize intValue];
                            handleCom = YES;
                        }
                        NSArray *subArray = [dataArray subarrayWithRange:NSMakeRange(i*[batchSize intValue], length)];
                        
                        [self handleSendWithDataArray:subArray sendId:sendId isLastHandle:handleCom];
                        
                    }
                
                
            });  

            
            
    }
        
        
    }errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
        
        //请求数据错误
        NSLog(@"MKNetwork request error------ : %@", [err localizedDescription]);
        
    }];
    [_engine enqueueOperation:op];

}

- (void)handleSendWithDataArray:(NSArray *)dataArray sendId:(NSString *)sendId isLastHandle:(BOOL)lastHandle
{
    NSNumber *localSyncTime = [[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_SYNC_TIME];
    NSNumber *localUpdateTime = [[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_UPDATE_TIME];


        NSString *token =[[NSUserDefaults standardUserDefaults] objectForKey:ACCOUNT_ADDING_TOKEN];//token
        NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];//手机唯一标示符
        
        self.engine = [[MKNetworkEngine alloc] initWithHostName:@"api.addinghome.com/sync/fetalMovement/send_handle" customHeaderFields:nil];
        [self.engine cancelAllOperations];
        
        NSData *data = [NSJSONSerialization dataWithJSONObject:dataArray options:0 error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:data
                                                     encoding:NSUTF8StringEncoding];
        NSMutableDictionary *dicParams = [[NSMutableDictionary alloc] init];
    
        [dicParams setValue:idfv forKey:@"cid"];
        [dicParams setValue:token forKey:@"access_token"];
        [dicParams setValue:@"1" forKey:@"anonymous"];
        [dicParams setValue:sendId forKey:@"sendId"];
        [dicParams setValue:jsonString forKey:@"records"];
        DLog(@"json - %@",data);
    
        MKNetworkOperation *op = [_engine operationWithPath:nil params:dicParams httpMethod:@"POST" ssl:NO];
        
        NSLog(@"请求接口是%@",op);
        [op addCompletionHandler:^(MKNetworkOperation *operation) {
            NSLog(@"[operation responseData]-->>%@", [operation responseString]);
            
            NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:[operation responseData] options:NSJSONReadingAllowFragments error:nil];
            //解析字典中得数据，判断是否注册成功，并返回失败原因
            
            if ([resultDic objectForKey:@"error"] !=nil) {
                NSLog(@"请求传数据时出错:");
            }
            else{
            
                NSLog(@"发送成功");
                //提交
                if (lastHandle == YES) {
                [self commitSyncWithStatTime:[localSyncTime intValue] endTime:[localUpdateTime intValue] sendId:sendId];
                }
               
            }
            
            
        }errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
            
            //请求数据错误
            NSLog(@"MKNetwork request error------ : %@", [err localizedDescription]);
            
        }];
        [_engine enqueueOperation:op];

 
}

- (void)commitSyncWithStatTime:(int)startTime endTime:(int)endTime sendId:(NSString *)sendId
{

  
    
    //上传数据
    NSString *token =[[NSUserDefaults standardUserDefaults] objectForKey:ACCOUNT_ADDING_TOKEN];//token
    NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];//手机唯一标示符
    
    self.engine = [[MKNetworkEngine alloc] initWithHostName:@"api.addinghome.com" customHeaderFields:nil];
    [self.engine cancelAllOperations];
    MKNetworkOperation *op;
    if (token) {
       op = [_engine operationWithPath:[NSString stringWithFormat:@"sync/fetalMovement/send_commit?oauth_token=%@&cid=%@&anonymous=1&sendId=%@&startTime=%d&endTime=%d&currentRemoteSynctime=%d", token,idfv,sendId,startTime,endTime,remoteSync] params:nil httpMethod:@"GET" ssl:NO];
    }else{
        op = [_engine operationWithPath:[NSString stringWithFormat:@"sync/fetalMovement/send_commit?cid=%@&anonymous=1&sendId=%@&startTime=%d&endTime=%d&currentRemoteSynctime=%d",idfv,sendId,startTime,endTime,remoteSync] params:nil httpMethod:@"GET" ssl:NO];
    }
    
    
    NSLog(@"请求接口是%@",op);
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSLog(@"[operation responseData]-->>%@", [operation responseString]);
        
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:[operation responseData] options:NSJSONReadingAllowFragments error:nil];
        //解析字典中得数据，判断是否注册成功，并返回失败原因
        
        if ([resultDic objectForKey:@"error"] !=nil) {
            NSLog(@"请求远程同步时间时出错:");
        }
        else{
            NSString *syncTime = [resultDic objectForKey:@"synctime"];
            NSNumber *remoteSynctime = [NSNumber numberWithInt:[syncTime intValue]];
            [[NSUserDefaults standardUserDefaults] setObject:remoteSynctime forKey:LOCAL_SYNC_TIME];//拿到远程同步时间存到本地
            [[NSUserDefaults standardUserDefaults] synchronize];
            NSLog(@"提交同步成功");
        }
        
        
    }errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
        
        //请求数据错误
        NSLog(@"MKNetwork request error------ : %@", [err localizedDescription]);
        
    }];
    [_engine enqueueOperation:op];

    
}


#pragma mark - 获取第三方账号绑定信息
/**
 *  获取第三方账号绑定信息
 */
- (void)getThirdPartyBindInfomationWithOAuthtoken:(NSString *)oauth_token
{
    
    NSString *token;
    if (oauth_token == nil) {
        token = [[NSUserDefaults standardUserDefaults] objectForKey:ACCOUNT_ADDING_TOKEN];
    }else{
        token = oauth_token;
    }
    
    MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:HTTP_HOST customHeaderFields:nil];
    [engine cancelAllOperations];
    MKNetworkOperation * op = [engine operationWithPath:[NSString stringWithFormat:@"account/partner_get_bind?oauth_token=%@",token] params:nil httpMethod:@"GET" ssl:NO];
    
    NSLog(@"获取第三方账户绑定信息请求接口是%@",op);
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSLog(@"[operation responseData]-->>%@", [operation responseString]);
        
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:[operation responseData] options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"获取第三方账户绑定信息是%@",resultDic);
        
        
        [[NSUserDefaults standardUserDefaults] setObject:[resultDic objectForKey:@"weibo_enabled"] forKey:WEIBO_ENABLED_KEY];
        [[NSUserDefaults standardUserDefaults] setObject:[resultDic objectForKey:@"qq_enabled"] forKey:QQ_ENABLED_KEY];
        [[NSUserDefaults standardUserDefaults] setObject:[resultDic objectForKey:@"baidu_enabled"] forKey:BAIDU_ENABLED_KEY];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
     
        //后续操作，绑定成功还是失败再进行操作........
        
    }errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
        
        //请求数据错误
        NSLog(@"MKNetwork request error------ : %@", [err localizedDescription]);
        
        
    }];
    [engine enqueueOperation:op];

}

#pragma mark - 显示Alert提醒
/**
 *  显示Alert提醒
 */
- (void)showAlertWithMessage:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"亲" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

#pragma mark - 退出登录
/**
 *  退出登录
 */
- (void)exit
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:ACCOUNT_ADDING_TOKEN];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
