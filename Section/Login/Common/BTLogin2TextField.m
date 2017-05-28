//
//  BTLogin2TextField.m
//  biketo
//
//  Created by Carroll on 16/3/11.
//  Copyright © 2016年 MagicCycling Media Limited. All rights reserved.
//

#import "BTLogin2TextField.h"

@implementation BTLogin2TextField

-(instancetype)init
{
    self = [super init];
    if (self) {
        [self configureTextField];
        self.borderTypeOfNumber = 2;
    }
    return self;
}

#pragma mark Configure

- (void)configureTextField
{
    self.layer.masksToBounds = YES;
    self.font = [UIFont systemFontOfSize:15];
    if (Iphone_4) {
        self.font = [UIFont systemFontOfSize:14];
    }
    [self setTextColor:RGB(190, 190, 190)];
    [self setTextAlignment:NSTextAlignmentCenter];
}

#pragma mark - Properties

-(void)setBorderTypeOfNumber:(NSInteger)borderTypeOfNumber
{
    [self.layer addSublayer:[self createFieldBorderWithType:borderTypeOfNumber]];
}

-(void)setTextTips:(NSString *)textTips
{
    self.placeholder = textTips;
}

-(void)setType:(BTLogin2TextFieldType)type
{
    
    switch (type) {
        case textFieldTypeDefault:
            
            break;
            
        case textFieldTypePassword:
            break;
            
        default:
            break;
    }
}

#pragma mark - CALayer

- (CALayer *)createFieldBorderWithType:(NSInteger)type
{
    CALayer *border = [CALayer layer];
    CGFloat borderWidth = 1;
    CGFloat fieldWith = Screen_Width;
    CGFloat fieldHeight = 110/Screen_AutoScaleValue;
    
    border.borderColor = RGB(227, 227, 227).CGColor;
    border.borderWidth = borderWidth;
    
    if (type == 1) { // 1 = 显示上边框
        border.frame = CGRectMake(0, 0, fieldWith, 1);
    } else if(type == 2) { // 2 = 下边框
        border.frame = CGRectMake(0, fieldHeight - borderWidth, fieldWith, 1);
    } else if(type == 3) { // 3 = 上下边框
         border.frame = CGRectMake(0, 0, fieldWith, 1);

    }
    return border;
}

@end
