//
//  ADAccountCenter.h
//  FetalMovement
//
//  Created by wangpeng on 14-3-11.
//  Copyright (c) 2014年 wang peng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ADSingleton.h"//单例宏模板
@interface ADAccountCenter : NSObject<WBHttpRequestDelegate>

////Singleton define

+ (ADAccountCenter *)sharedADAccountCenter;
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
/**
 *  用户注册
 *
 *  @param name     邮箱
 *  @param pass     密码
 *  @param target   id target
 *  @param success SEL 成功回调方法
 *  @param failure SEL 失败回调方法
 */
- (void)userRegisterWithEmail:(NSString*)name passWord:(NSString*)pass withTarget:(id)target success:(SEL)success failure:(SEL)failure;

/**
 *  用户登录
 *
 *  @param name     手机号
 *  @param pass     密码
 *  @param target   id target
 *  @param success SEL 成功回调方法
 *  @param failure SEL 失败回调方法
 */
- (void)userLoginWithPhone:(NSString*)name passWord:(NSString*)pass withTarget:(id)target success:(SEL)success failure:(SEL)failure;

/**
 *  用户登录
 *
 *  @param name     邮箱
 *  @param pass     密码
 *  @param target   id target
 *  @param success SEL 成功回调方法
 *  @param failure SEL 失败回调方法
 */
- (void)userLoginWithEmail:(NSString*)name passWord:(NSString*)pass withTarget:(id)target success:(SEL)success failure:(SEL)failure;

/**
 *  将第三方账号token发给本地服务器 进行第三方登录
 */
- (void)postThirdpartyTokenTolocalServer:(NSString *)token thirdPartyType:(ADACCOUNT_TYPE)type;

/**
 *  将第三方账号token发给本地服务器 解除绑定
 */

- (void)removeBindingThirdpartyToken:(NSString *)token thirdPartyType:(ADACCOUNT_TYPE)type;

/**
 *  将第三方账号token发给本地服务器 进行绑定
 */

- (void)bindingThirdpartyToken:(NSString *)token thirdPartyType:(ADACCOUNT_TYPE)type;

#pragma mark - 新浪账户相关操作
/**
 *  通过新浪微博 进行第三方登录
 */
- (void)loginOAuthSina;

/**
 *  仅仅获得新浪微博授权
 */
- (void)getOAuthSina;

/**
 *  取消新浪微博授权
 */
- (void)outOAuthSina;

/**
 *  获取新浪微博用户昵称
 */
- (void)getSinaUserInfoWiheToken:(NSString *)token uid:(NSString *)uid;

/**
 *  分享文字和图片到新浪微博
 */
- (void)shareToSinaWeiboWithText:(NSString *)text picture:(NSData *)pictureData;

@end
