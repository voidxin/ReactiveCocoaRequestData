//
//  DetailViewController.m
//  ReactiveCocoaRequestData
//
//  Created by voidxin on 16/6/14.
//  Copyright © 2016年 wugumofang. All rights reserved.
//

#import "DetailViewController.h"
#import "ReactiveCocoa.h"
#import "Masonry.h"
#import "DetailViewModel.h"
@interface DetailViewController()
@property(nonatomic,strong)UIButton *confirmBtn;
@property(nonatomic,strong)UITextField *textField;
@property(nonatomic,strong)DetailViewModel *viewModel;
@end
@implementation DetailViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.confirmBtn];
    [self.view addSubview:self.textField];
    [self bindViewModel];
}
- (void)viewWillLayoutSubviews{
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.equalTo(@100);
        make.height.equalTo(@50);
    }];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.equalTo(@100);
        make.height.equalTo(@44);
        make.top.equalTo(self.confirmBtn.mas_bottom).offset(30);
    }];
}
-(void)bindViewModel{
    self.viewModel=[[DetailViewModel alloc]init];
    RAC(self.viewModel,staffNumber)=[self.textField.rac_textSignal distinctUntilChanged];
    self.confirmBtn.rac_command=self.viewModel.confirmCommand;
    [[self.confirmBtn.rac_command.executionSignals switchToLatest] subscribeNext:^(NSString *str) {
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"title" message:str delegate:self cancelButtonTitle:@"confirm" otherButtonTitles:nil, nil];
        [alertView show];
    }];
}
- (UIButton *)confirmBtn{
    if (!_confirmBtn) {
        _confirmBtn=[UIButton buttonWithType:UIButtonTypeSystem];
        [_confirmBtn setTitle:@"congfirm" forState:UIControlStateNormal];
       
    }
    return _confirmBtn;
}

- (UITextField *)textField{
    if (!_textField) {
        _textField=[[UITextField alloc]init];
        _textField.placeholder=@"input...";
    }
    return _textField;
}

@end
