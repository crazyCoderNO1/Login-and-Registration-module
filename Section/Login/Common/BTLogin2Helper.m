//
//  BTLogin2Helper.m
//  biketo
//
//  Created by Carroll on 16/3/23.
//  Copyright © 2016年 MagicCycling Media Limited. All rights reserved.
//

#import "BTLogin2Helper.h"

@implementation BTLogin2Helper

+ (BOOL)stringContainsEmoji:(NSString *)string
{
 __block BOOL returnValue = NO;

[string enumerateSubstringsInRange:NSMakeRange(0, [string length]) 
    options:NSStringEnumerationByComposedCharacterSequences 
 usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
     const unichar hs = [substring characterAtIndex:0];
     if (0xd800 <= hs && hs <= 0xdbff) {
         if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
             if (0x1d000 <= uc && uc <= 0x1f77f) {
                 returnValue = YES;
             }
         }
     } else if (substring.length > 1) {
         const unichar ls = [substring characterAtIndex:1];
         if (ls == 0x20e3) {
             returnValue = YES;
         }
     } else {
         if (0x2100 <= hs && hs <= 0x27ff) {
             returnValue = YES;
         } else if (0x2B05 <= hs && hs <= 0x2b07) {
             returnValue = YES;
         } else if (0x2934 <= hs && hs <= 0x2935) {
             returnValue = YES;
         } else if (0x3297 <= hs && hs <= 0x3299) {
             returnValue = YES;
         } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
             returnValue = YES;
         }
     }
 }];
    
return returnValue;
    
}

+ (BOOL)checkPhoneNumInput:(NSString *)number
{
    // 判断是否为整形
    NSScanner *scan = [NSScanner scannerWithString:number];
    int val;
    
    if (([scan scanInt:&val] && [scan isAtEnd]) && number.length == 11) {
        return YES;
    }
    
    return NO;
}

+ (BOOL)isValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

@end
