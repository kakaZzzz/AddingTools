//
//  ADNetwork.h
//  FetalMovement
//
//  Created by wangpeng on 14-3-11.
//  Copyright (c) 2014年 wang peng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeiboSDK.h"

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

#define  HTTP_HOST  @"www.addinghome.com"
#define  HTTP_TEST_HOST  @"www.addinghome.com:8080"

#define LOGIN_TEST_HOST @"www.addinghome.com:8080/api_oauth2/token"

#pragma mark - 各种账号

//加丁
#define ACCOUNT_ADDING_UID @"addingUid"
#define ACCOUNT_ADDING_TOKEN @"addingToken"
//sina
#define kSinaAppKey         @"717965101"
#define kSinaRedirectURI    @"https://api.weibo.com/oauth2/default.html"
#define ACCOUNT_SINA_KEY    @"accountSinaKay" //用于userdefault存储
#define ACCOUNT_SINA_TOKEN   @"accountSinaToken" //用于userdefault存储
#define ACCOUNT_SINA_EXPIRES   @"accountSinaExpires" //用于userdefault存储
#define ACCOUNT_SINA_UID   @"accountSinaUid" //用于userdefault存储

