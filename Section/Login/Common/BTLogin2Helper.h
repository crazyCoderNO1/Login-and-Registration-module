//
//  BTLogin2Helper.h
//  biketo
//
//  Created by Carroll on 16/3/23.
//  Copyright © 2016年 MagicCycling Media Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTLogin2Helper : NSObject

// 判断是否包含emoji表情
+ (BOOL)stringContainsEmoji:(NSString *)string;

// 判断是否是正确的手机号码段
+ (BOOL)checkPhoneNumInput:(NSString *)number;

// 判断是否是正确的email格式
+ (BOOL)isValidateEmail:(NSString *)email;

@end
