//
//  ViewController.m
//  ReactiveCocoaRequestData
//
//  Created by voidxin on 16/6/13.
//  Copyright © 2016年 wugumofang. All rights reserved.
//

#import "ViewController.h"
#import "LoadStoreViewModel.h"
#import "ReactiveCocoa.h"
#import "Masonry.h"
#import "WGStoreModel.h"
#define kCode1 @"MWG08A09"
@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)NSString *code1;
@property(nonatomic,strong)LoadStoreViewModel *storeViewModel;
@property(nonatomic,assign)BOOL isLoading;

@property(nonatomic,strong)UITableView *tableView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addUI];
    [self bindViewModel];
}
-(void)addUI{
    [self.view addSubview:self.tableView];
}
- (void)viewDidLayoutSubviews{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
-(void)bindViewModel{
    @weakify(self);
    self.storeViewModel=[[LoadStoreViewModel alloc]init];
    self.isLoading=YES;
    self.code1=kCode1;
    RAC(self.storeViewModel,code1)=RACObserve(self, code1);
    
    //加载状态
   [RACObserve(self, isLoading) subscribeNext:^(id x) {
        UIApplication.sharedApplication.networkActivityIndicatorVisible = [x boolValue];
   }];
    
    //加载网络数据成功
    [[[RACObserve(self.storeViewModel, dataArray) ignore:nil] doNext:^(id x) {
        self.isLoading=YES;
    }] subscribeNext:^(id x) {
        @strongify(self);
        self.isLoading=NO;
        //刷新控件--
        [self.tableView reloadData];
    }];
    
    //加载网络数据失败
    [[RACObserve(self.storeViewModel, statues) filter:^BOOL(id value) {
        //filter是过滤
        return value !=nil;
    }] subscribeNext:^(NSString *str) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:str message:str preferredStyle: UIAlertControllerStyleActionSheet];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"error" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }];
        
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }];
    
}

#pragma mark -tableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.storeViewModel.dataArray count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indefier=@"CELL";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:indefier];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indefier];;
    }
    WGStoreModel *model=self.storeViewModel.dataArray[indexPath.row];
    cell.textLabel.text=model.shopName;
    
    return cell;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.showsVerticalScrollIndicator=NO;
        _tableView.rowHeight=49;
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
