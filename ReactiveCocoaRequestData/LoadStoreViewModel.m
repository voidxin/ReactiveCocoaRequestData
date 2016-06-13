//
//  loadStoreViewModel.m
//  ReactiveCocoaRequestData
//
//  Created by voidxin on 16/6/13.
//  Copyright © 2016年 wugumofang. All rights reserved.
//

#import "LoadStoreViewModel.h"
#import "AFHTTPRequestOperationManager+RACSupport.h"
#import "ReactiveCocoa.h"
#import "WGStoreModel.h"
#import "MJExtension.h"
//
#define kLoadURL @"http://test.wgmf.com/mkt-back/question/shops"

@interface LoadStoreViewModel()
@property(nonatomic,strong)RACSignal *loadDataSignal;
@end
@implementation LoadStoreViewModel
-(id)init{
    self=[super init];
    if (self) {
        [self initWithSubscrible];
    }
    return self;
}

-(void)initWithSubscrible{
    [[self.loadDataSignal deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(RACTuple *jsonDataResult) {
        //请求成功，加载数据
        NSDictionary *tuple=[jsonDataResult objectAtIndex:0];
        NSArray *resultList=tuple[@"resultList"];
        if (resultList.count>0) {
            self.dataArray=[[[resultList.rac_sequence
                              map:^id(NSDictionary *dataSource) {
                              NSDictionary *dic=[(NSDictionary *)dataSource mutableCopy];
                                  WGStoreModel *model=[WGStoreModel mj_objectWithKeyValues:dic];
                                  return model;
                            }] array] mutableCopy];
        }
    }];
    
    //请求失败
    [self.loadDataSignal subscribeError:^(NSError *error) {
       self.statues=@"没有网络，哈哈";
    }];
}

//
- (RACSignal *)loadDataSignal{
    if (_loadDataSignal==nil) {
        AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
        manager.requestSerializer=[[AFJSONRequestSerializer alloc]init];
        NSDictionary *params=@{@"code1":@"MWG08A09"};
        _loadDataSignal=[manager rac_GET:kLoadURL parameters:params];
    }
    return _loadDataSignal;
}
@end
