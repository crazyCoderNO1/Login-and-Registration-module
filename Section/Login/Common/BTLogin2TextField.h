//
//  BTLogin2TextField.h
//  biketo
//
//  Created by Carroll on 16/3/11.
//  Copyright © 2016年 MagicCycling Media Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger{
    textFieldTypeDefault,
    textFieldTypePassword,
    textFieldTypePhoneNumber
} BTLogin2TextFieldType;

@interface BTLogin2TextField : UITextField

@property (nonatomic, strong) NSString *textTips; // 文字
@property (nonatomic, assign) NSInteger borderTypeOfNumber; // 显示边框类型，默认显示下边框, = 1是显示下边框
@property (nonatomic, assign) BTLogin2TextFieldType type;

@end
