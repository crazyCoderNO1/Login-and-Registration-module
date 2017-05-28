//
//  BTLogin2ThirdPartyLoginViewController.h
//  biketo
//
//  Created by Carroll on 16/3/30.
//  Copyright © 2016年 MagicCycling Media Limited. All rights reserved.
//

#import "BTRootViewController.h"
#import "WeiboSDK.h"
#import "WXApi.h"

@class TencentOAuth;

@protocol BTLogin2ThirdPartyLoginVCProtocol <NSObject>

- (void)thirdPartyLoginSuccess;

@end

@interface BTLogin2ThirdPartyLoginViewController : BTRootViewController
{
    TencentOAuth *_tencentOauth;
    NSArray *_permission;
    NSDictionary *_wxCode;
}

@property (nonatomic, assign) BOOL isLoginVC;

@property (nonatomic, assign) id <BTLogin2ThirdPartyLoginVCProtocol> delegate;

@end
