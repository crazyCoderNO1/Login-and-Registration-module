//
//  BTLogin2RecoverPasswdUseEmailViewController.m
//  使用邮箱找回密码
//
//  Created by Carroll on 16/3/15.
//  Copyright © 2016年 MagicCycling Media Limited. All rights reserved.
//

#import "BTLogin2RecoverPasswdUseEmailViewController.h"
#import "BTLogin2TextField.h"
#import "BTLogin2Button.h"
#import "BTLogin2RequestAPI.h"
#import "BTNoticeShowManager.h"
#import "BTLogin2ManageViewController.h"
#import "BTHelper.h"

@interface BTLogin2RecoverPasswdUseEmailViewController ()

@property (nonatomic, strong) UILabel *emailTipsLabel;
@property (nonatomic, strong) BTLogin2Button *submitButton;

@end

@implementation BTLogin2RecoverPasswdUseEmailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureVC];
}

- (void)configureVC
{
    self.title = @"找回密码";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addBackButton];
    
    self.emailTipsLabel = UILabel.new;
    self.emailTipsLabel.text = F(@"已发送重置密码至您的注册邮箱%@", self.paramters[@"email"]);
    self.emailTipsLabel.font = [UIFont systemFontOfSize:15];
    self.emailTipsLabel.numberOfLines = 0;
    self.emailTipsLabel.textAlignment = NSTextAlignmentCenter;
    [self.emailTipsLabel setTextColor:RGB(71, 71, 71)];

    self.submitButton = [[BTLogin2Button alloc]initWithButtonType:ButtonType_HaveBorde_BlackFontColor];
    self.submitButton.textTips = @"确定";
    self.submitButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.submitButton addTarget:self action:@selector(didTapSubmiteButton:) forControlEvents:UIControlEventTouchUpInside];

    [self addSubviews];
}

#pragma mark - Layout

- (void)addSubviews
{
    [self.view addSubview:self.emailTipsLabel];
    [self.view addSubview:self.submitButton];

    [self.emailTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(140/2);
        make.left.equalTo(self.view).offset(40);
        make.right.equalTo(self.view).offset(-40);
        make.centerX.equalTo(self.view);
    }];
    
    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.emailTipsLabel.mas_bottom).offset(60/2);
        make.centerX.equalTo(self.view);
        make.width.equalTo(@140);
        make.height.equalTo(@45);
    }];
    
}

#pragma mark - Delgate

-(void)rightAction:(UIButton *)sender
{
        
}

- (void)didTapSubmiteButton:(UIButton *)button
{
    BTLogin2ManageViewController *loginVC = BTLogin2ManageViewController.new;
    loginVC.isGotoLogin = YES;
    [self.navigationController pushViewController:loginVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
