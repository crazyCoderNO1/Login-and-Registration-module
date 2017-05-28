//
//  BTLogin2APIEncryption.m
//  AIP接口加密 URL:
//
//  Created by Carroll on 16/3/17.
//  Copyright © 2016年 MagicCycling Media Limited. All rights reserved.
//

#import "BTLogin2APIEncryption.h"

#import <Security/Security.h>
#import <CommonCrypto/CommonDigest.h>  
#import <CommonCrypto/CommonCryptor.h>

@interface BTLogin2APIEncryption ()

@end

@implementation BTLogin2APIEncryption

// 将secret、timestamp、device、nonce 4个参数进行字典序排序, 并通过cha1加密
+ (NSString *)getEncryptedStr
{
    NSString *sortedArrayBystr = nil;
    NSString *cha1String = nil;
    NSString *encryptedString = nil;
    NSString *timestamp = [self currentTimeString];
    NSString *device = [self deviceUUIDString];
    NSString *nonce = [self randString];
    
    // 组成数组
    NSArray *signatureArray = @[ BT_CLIENT_SECRET_VALUE, timestamp, device, nonce ];
    
    // 排序
    NSArray *signaturedSorteArray = [signatureArray sortedArrayUsingSelector:@selector(compare:)];
    
    // 拼接
    sortedArrayBystr = [signaturedSorteArray componentsJoinedByString:sortedArrayBystr];
    
    // 加密 + 转小写
    cha1String = [[self sha1:sortedArrayBystr] lowercaseString];
    
    // 最终拼接的URL
    encryptedString = F(@"?signature=%@&timestamp=%@&device=%@&nonce=%@",cha1String, timestamp, device, nonce);
    
    return encryptedString;
}

// UUID是Universally Unique Identifier的缩写，中文意思是通用唯一识别码
+ (NSString *)deviceUUIDString
{
    NSString *uuidString = nil;
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    if (uuid) {
        uuidString = (NSString *)CFBridgingRelease(CFUUIDCreateString(NULL, uuid));
        CFRelease(uuid);
    }
    return [[uuidString substringToIndex:8] lowercaseString];
}

// 获取系统当前的时间戳
+ (NSString *)currentTimeString
{
    NSDate *localDate = [NSDate date]; //获取当前时间
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[localDate timeIntervalSince1970]]; //转化为UNIX时间戳
    return timeSp;
}

// 随机数
+ (NSString *)randString
{
    return [NSString stringWithFormat:@"%d", rand()];
}

+ (NSString *)sha1:(NSString *)input
{
    const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:input.length];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, data.length, digest);
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02X", digest[i]];
    return output;
}

@end
