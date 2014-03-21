//
//  ADNetwork.h
//  FetalMovement
//
//  Created by wangpeng on 14-3-11.
//  Copyright (c) 2014年 wang peng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeiboSDK.h"
#import"TencentOpenAPI/TencentOAuth.h"

//新浪账户三种操作方式（获取token）
typedef enum {
    
    SINA_TYPE_LOGIN = 1,
    SINA_TYPE_OATHO = 2,
    SINA_TYPE_SHARE
    
}SINA_TYPE;

typedef enum {
    
    ADACCOUNT_TYPE_UNKNOW = -1,
    ADACCOUNT_TYPE_SINA = 0,
    ADACCOUNT_TYPE_TENCENT,
    ADACCOUNT_TYPE_TENCENTWEIBO,
    ADACCOUNT_TYPE_BAIDU
    
}ADACCOUNT_TYPE;


//注册错误码
typedef enum {
    
    ADREGISTER_ERROR_INVALID_EMAIL = 20001,
    ADREGISTER_ERROR_EXISTED_EMAIL = 20002,
    ADREGISTER_ERROR_INVALID_PHONE,
    ADREGISTER_ERROR_EXISTED_PHONE,
    ADREGISTER_ERROR_INVALID_PASSWORD,
}ADREGISTER_ERROR_CODE;

#define  HTTP_HOST  @"api.addinghome.com"
#define  HTTP_TEST_HOST  @"www.addinghome.com:8080"

#define LOGIN_TEST_HOST @"www.addinghome.com:8080/api_oauth2/token"

#pragma mark - 各种账号

//加丁
#define ACCOUNT_ADDING_UID @"addingUid"
#define ACCOUNT_ADDING_TOKEN @"addingToken"
#define ACCOUNT_ADDING_NICKNAME @"addingNickname"
#define ACCOUNT_ADDING_ISADDING @"isAdding"

//sina
#define kSinaAppKey         @"717965101"
#define kSinaRedirectURI    @"https://api.weibo.com/oauth2/default.html"
#define ACCOUNT_SINA_KEY    @"accountSinaKay" //用于userdefault存储
#define ACCOUNT_SINA_TOKEN   @"accountSinaToken" //用于userdefault存储
#define ACCOUNT_SINA_EXPIRES   @"accountSinaExpires" //用于userdefault存储
#define ACCOUNT_SINA_UID   @"accountSinaUid" //用于userdefault存储

//tencent
#define kTencentAppKey         @"801487685"
#define kTencentAppSecret      @"aa392bb7beec56ba92ebff50d8aa3a25"
#define kTencentRedirectURI    @"http://addinghome.com/"
#define ACCOUNT_TENCENT_KEY    @"accountTencentKay" //用于userdefault存储
#define ACCOUNT_TENCENT_TOKEN   @"accountTencentToken" //用于userdefault存储
#define ACCOUNT_TENCENT_EXPIRES   @"accountTencentExpires" //用于userdefault存储
#define ACCOUNT_TENCENT_UID   @"accountTencentUid" //用于userdefault存储

//qq
#define kQQAppKey         @"101040562"
#define kQQRedirectURI    @"http://www.qq.com/"
#define ACCOUNT_QQ_KEY    @"accountQQKay" //用于userdefault存储
#define ACCOUNT_QQ_TOKEN   @"accountQQToken" //用于userdefault存储
#define ACCOUNT_QQ_EXPIRES   @"accountQQExpires" //用于userdefault存储
#define ACCOUNT_QQ_UID   @"accountQQUid" //用于userdefault存储

//baidu
#define kBaiduAppKey         @"717965101"
#define kBaiduRedirectURI    @"https://api.weibo.com/oauth2/default.html"
#define ACCOUNT_BAIDU_KEY    @"accountBaiduKay" //用于userdefault存储
#define ACCOUNT_BAIDU_TOKEN   @"accountBaiduToken" //用于userdefault存储
#define ACCOUNT_BAIDU_EXPIRES   @"accountBaiduExpires" //用于userdefault存储
#define ACCOUNT_BAIDU_UID   @"accountBaiduUid" //用于userdefault存储


//第三方账号绑定信息key值
#define THIRDPARTY_BIND_KEY  @"thirdPartyBindKey" //用于userdefault存储
#define WEIBO_ENABLED_KEY  @"weibo_enabled" //用于userdefault存储
#define QQ_ENABLED_KEY  @"qq_enabled" //用于userdefault存储
#define BAIDU_ENABLED_KEY  @"baidu_enabled" //用于userdefault存储
/**
 *  预产期key值
 */
#define USER_DUEDATE_KEY @"duedateKey"

/**
 *  用户信息key值
 */
#define USER_USERINFO_KEY @"userInfoKey"


/**
 *  同步数据key值
 */
#define LOCAL_SYNC_TIME @"localSyncTime"
#define LOCAL_UPDATE_TIME @"localUpdateTime"


