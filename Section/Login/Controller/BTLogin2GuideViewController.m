//
//  BTLogin2GuideViewController.m
//  登录引导页
//
//  Created by Carroll on 16/3/15.
//  Copyright © 2016年 MagicCycling Media Limited. All rights reserved.
//

#import "BTLogin2GuideViewController.h"
#import "BTLogin2Button.h"
#import "BTSubModuleRootViewController.h"

#import "BTLogin2ManageViewController.h"

@interface BTLogin2GuideViewController ()

@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) BTLogin2Button *gotoRegistButton;
@property (nonatomic, strong) BTLogin2Button *gotoLoginButton;
@property (nonatomic, strong) UIButton *skipButton;

@end

@implementation BTLogin2GuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureVC];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.isSetStatusBarStyleLight = YES;
}

- (void)configureVC
{    
    self.logoImageView = UIImageView.new;
    self.logoImageView.image = [UIImage imageNamed:@"BTLoginManage_textLogo"];
    
    self.bgImageView = UIImageView.new;
    self.bgImageView.image = [UIImage imageNamed:@"BTLoginGuide_bg"];
    self.bgImageView.clipsToBounds = YES;
    self.bgImageView.contentMode = UIViewContentModeScaleAspectFill;

    self.gotoRegistButton = [[BTLogin2Button alloc]initWithButtonType:ButtonType_HaveBorde_WhiteFontColor];
    self.gotoRegistButton.textTips = @"新用户注册";
    [self.gotoRegistButton addTarget:self action:@selector(didTapGotoRegistButton:) forControlEvents:UIControlEventTouchUpInside];
    
    self.gotoLoginButton = [[BTLogin2Button alloc]initWithButtonType:ButtonType_HaveBorde_WhiteFontColor];
    self.gotoLoginButton.textTips = @"登录";
    [self.gotoLoginButton addTarget:self action:@selector(didTapGotoLoginButton:) forControlEvents:UIControlEventTouchUpInside];
    
    self.skipButton = UIButton.new;
    [self.skipButton setTitle:@"我先逛逛" forState:UIControlStateNormal];
    [self.skipButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [self.skipButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.skipButton setTitleColor:Common_LightGray_Color forState:UIControlStateHighlighted];
    [self.skipButton addTarget:self action:@selector(didTapGotoSkipButton:) forControlEvents:UIControlEventTouchUpInside];

    [self addSubviews];
}

#pragma mark - Layout

- (void)addSubviews
{
    [self.view addSubview:self.bgImageView];
    [self.view addSubview:self.logoImageView];
    [self.view addSubview:self.gotoRegistButton];
    [self.view addSubview:self.gotoLoginButton];
    [self.view addSubview:self.skipButton];
    
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view); 
    }];
    
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(@(260/2));
        make.width.equalTo(@(214/2));
        make.height.equalTo(@(156/2));
    }];
    
    [self.gotoRegistButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        if (Iphone_4) {
            make.top.equalTo(@(Screen_Height * 0.6));
        }else {
            make.top.equalTo(@(Screen_Height * 0.7));
        }
        make.width.equalTo(@(460/2));
        make.height.equalTo(@(90/2));
    }];
    
    [self.gotoLoginButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.gotoRegistButton.mas_bottom).offset(15);
        make.width.and.height.equalTo(self.gotoRegistButton);
    }];
    
    [self.skipButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.gotoLoginButton);
        make.bottom.equalTo(self.view.mas_bottom).offset(-25);
    }];
}

#pragma mark - Delegate

- (void)didTapGotoRegistButton:(UIButton *)button
{
    BTLogin2ManageViewController *registerVC = BTLogin2ManageViewController.new;
    registerVC.isGotoLogin = NO;
    [self.navigationController pushViewController:registerVC animated:YES];
}

- (void)didTapGotoLoginButton:(UIButton *)button
{
    BTLogin2ManageViewController *loginVC = BTLogin2ManageViewController.new;
    loginVC.isGotoLogin = YES;
    [self.navigationController pushViewController:loginVC animated:YES];
}

- (void)didTapGotoSkipButton:(UIButton *)button
{
    //统计点
    [[BTMobClick shareInstance] clickEventType:@"skip_reg" module:nil];

    ((BTSubModuleRootViewController *)self.frostedViewController).isFirstLaunch = NO;
    [self enterMainInterface];
}


@end
