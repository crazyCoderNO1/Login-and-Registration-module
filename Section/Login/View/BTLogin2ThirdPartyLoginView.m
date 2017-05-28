//
//  BTLogin2ThirdPartyLoginView.m
//  第三方登录注册
//
//  Created by Carroll on 16/3/25.
//  Copyright © 2016年 MagicCycling Media Limited. All rights reserved.
//

#import "BTLogin2ThirdPartyLoginView.h"

@interface BTLogin2ThirdPartyLoginView ()

@property (nonatomic, strong) UILabel *thirdPartyLoginTipsLable;

@property (nonatomic, strong) UIView *leftLineView;
@property (nonatomic, strong) UIView *rightLineView;

@property (nonatomic, strong) UIButton *wechatButton;
@property (nonatomic, strong) UIButton *qqButton;
@property (nonatomic, strong) UIButton *weiboButton;

@end

@implementation BTLogin2ThirdPartyLoginView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configureView];
    }
    return self;
}

- (void)configureView
{
    self.thirdPartyLoginTipsLable = UILabel.new;
    self.thirdPartyLoginTipsLable.text = @"第三方账号登录";
    self.thirdPartyLoginTipsLable.font = [UIFont systemFontOfSize:12];
    self.thirdPartyLoginTipsLable.textColor = Common_Gray_Color;

    self.leftLineView = UIView.new;
    self.leftLineView.backgroundColor = Common_Gray_Color;
    
    self.rightLineView = UIView.new;
    self.rightLineView.backgroundColor = Common_Gray_Color;
    
    self.wechatButton = UIButton.new;
    [self.wechatButton setBackgroundImage:[UIImage imageNamed:@"icon_wechat.png"] forState:UIControlStateNormal];
    [self.wechatButton addTarget:self action:@selector(didTapWechatButton:) forControlEvents:UIControlEventTouchUpInside];
    
    self.qqButton = UIButton.new;
    [self.qqButton setBackgroundImage:[UIImage imageNamed:@"icon_tencent_qq.png"] forState:UIControlStateNormal];
    [self.qqButton addTarget:self action:@selector(didTapQQButton:) forControlEvents:UIControlEventTouchUpInside];

    self.weiboButton = UIButton.new;
    [self.weiboButton setBackgroundImage:[UIImage imageNamed:@"icon_sina_weibo.png"] forState:UIControlStateNormal];
    [self.weiboButton addTarget:self action:@selector(didTapWeiboButton:) forControlEvents:UIControlEventTouchUpInside];

    [self addsubViews];
}

- (void)addsubViews
{
    [self addSubview:self.thirdPartyLoginTipsLable];
    [self addSubview:self.leftLineView];
    [self addSubview:self.rightLineView];
    
    [self addSubview:self.qqButton];
    [self addSubview:self.wechatButton];
    [self addSubview:self.weiboButton];
    
    [self.thirdPartyLoginTipsLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.centerX.equalTo(self);
    }];
    
    [self.leftLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.thirdPartyLoginTipsLable);
        make.left.equalTo(self);
        make.right.equalTo(self.thirdPartyLoginTipsLable.mas_left).offset(-16/2);
        make.height.equalTo(@0.8);
    }];
    
    [self.rightLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.thirdPartyLoginTipsLable);
        make.left.equalTo(self.thirdPartyLoginTipsLable.mas_right).offset(16/2);
        make.right.equalTo(self);
        make.height.equalTo(@0.8);
    }];
    
    [self.qqButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@21);
        make.height.equalTo(@25);
        make.centerX.equalTo(self);
        make.top.equalTo(self.thirdPartyLoginTipsLable.mas_bottom).offset(42/2);
    }];
    
    [self.wechatButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@26);
        make.height.equalTo(@22);
        make.right.equalTo(self.qqButton.mas_left).offset(-70/2);
         make.centerY.equalTo(self.qqButton);
    }];
    
    [self.weiboButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@25);
        make.height.equalTo(@21);
        make.left.equalTo(self.qqButton.mas_right).offset(70/2);
        make.centerY.equalTo(self.qqButton);
    }];
}

#pragma mark - Delegate

- (void)didTapWechatButton:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(didTapWechatButton)]) {
        [self.delegate didTapWechatButton];
    }
}

- (void)didTapQQButton:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(didTapQQButton)]) {
         [self.delegate didTapQQButton];
    }
}

- (void)didTapWeiboButton:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(didTapWeiboButton)]) {
        [self.delegate didTapWeiboButton];
    }
}


@end
