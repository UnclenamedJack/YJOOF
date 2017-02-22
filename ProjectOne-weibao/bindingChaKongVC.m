//
//  bindingChaKongVC.m
//  ProjectOne-weibao
//
//  Created by jack on 17/1/5.
//  Copyright © 2017年 伍新科技有限公司. All rights reserved.
//

#import "bindingChaKongVC.h"
#import "Masonry.h"
#import "IndexVC.h"
#import "bindingOrHistroyBindViewController.h"
#import "UIColor+Extend.h"
#import "ChaKongCell.h"
#import "Header.h"
#import "binddingModel.h"
#import "chapaiModel.h"
#import "searchModel.h"

@interface bindingChaKongVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong) UICollectionView *collectView;
@property(nonatomic,strong) NSMutableArray *datas;
@end

@implementation bindingChaKongVC
static NSString *identifier = @"collection";
- (NSMutableArray *)datas{
    if (self.hubs) {
        _datas = [NSMutableArray arrayWithArray:self.hubs];
    }
    return _datas;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTintColor:[UIColor hexChangeFloat:@"ffffff"]];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    [self.view setBackgroundColor:[UIColor hexChangeFloat:@"eaeaea"]];
    self.title = @"插排信息";
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"left_big"] style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    
    UIImageView *topView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chapai"]];
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(64);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(self.view).multipliedBy(0.2);
    }];
    
    UILabel *macDress = [[UILabel alloc] init];
    [macDress setTextColor:[UIColor hexChangeFloat:@"ffffff"]];
    if (_mac) {
        [macDress setText:[NSString stringWithFormat:@"Mac:%@",_mac]];
    }else{
        [macDress setText:@"MAC:5c:cf:7f:0a:11:d3:"];
    }
    if(ScreenHeight == 480.0){
        [macDress setFont:[UIFont systemFontOfSize:15]];
    }else if (ScreenHeight==568) {
        [macDress setFont:[UIFont systemFontOfSize:16]];
    }else if (ScreenHeight == 667){
        [macDress setFont:[UIFont systemFontOfSize:17]];
    }else{
        [macDress setFont:[UIFont systemFontOfSize:18]];
    }
//    [macDress setFont:[UIFont boldSystemFontOfSize:18.0]];
    [topView addSubview:macDress];
    [macDress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(topView);
        make.centerY.equalTo(topView).offset(-15);
        make.left.equalTo(topView).offset(25);
    }];
    
    UILabel *macName = [[UILabel alloc] init];
    [macName setTextColor:[UIColor hexChangeFloat:@"ffffff"]];
    [macName setText:@"8孔智能插排"];
    if(ScreenHeight == 480.0){
        [macName setFont:[UIFont systemFontOfSize:10.0]];
    }else if (ScreenHeight==568) {
        [macName setFont:[UIFont systemFontOfSize:12.0]];
    }else if (ScreenHeight == 667){
        [macName setFont:[UIFont systemFontOfSize:13.0]];
    }else{
        [macName setFont:[UIFont systemFontOfSize:14.0]];
    }
//    [macName setFont:[UIFont boldSystemFontOfSize:13.0]];
    [topView addSubview:macName];
    [macName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(topView);
        make.top.equalTo(macDress.mas_bottom).offset(8);
        make.left.equalTo(macDress);
    }];

    UILabel *label = [[UILabel alloc] init];
    if(ScreenHeight == 480.0){
        [label setFont:[UIFont systemFontOfSize:8.0]];
    }else if (ScreenHeight==568) {
        [label setFont:[UIFont systemFontOfSize:9.0]];
    }else if (ScreenHeight == 667){
        [label setFont:[UIFont systemFontOfSize:10.0]];
    }else{
        [label setFont:[UIFont systemFontOfSize:10.0]];
    }
//    [label setFont:[UIFont systemFontOfSize:10.0]];
    [label setTextColor:[UIColor hexChangeFloat:@"ffffff"]];
    [label setText:@"*8孔以插线板开关在左上方为顺序排列"];
    [topView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(macName);
        make.bottom.equalTo(topView).offset(-10);
    }];
    
   
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    [_collectView setBackgroundColor:[UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1.0]];
//    [collectView setBackgroundColor:[UIColor redColor]];
    _collectView.delegate = self;
    _collectView.dataSource = self;
    [self.view addSubview:_collectView];
    [_collectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom).offset(5);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    layout.itemSize = CGSizeMake(self.view.frame.size.width/2.0, _collectView.frame.size.height/4.0);
    [_collectView registerClass:[ChaKongCell class] forCellWithReuseIdentifier:identifier];
    [_collectView setScrollEnabled:NO];
    // Do any additional setup after loading the view.
}
- (void)back:(UIBarButtonItem *)sender {
    IndexVC *vc = [[IndexVC alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}
#pragma mark - UICollectionDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 8;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ChaKongCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    [cell.contentView setBackgroundColor:[UIColor whiteColor]];
    cell.index = indexPath.row + 1;
//    cell.mac = self.mac;
    NSDictionary *dict;
//    for (NSDictionary *dict1 in self.hubs) {
//        NSUInteger i = [self.hubs indexOfObject:dict1];
//        if (i == indexPath.row) {
//            dict = dict1;
//        }
//    }
//    dict = self.hubs[indexPath.row];
    dict = self.datas[indexPath.row];
    if (dict){
//        if (dict[@"bdasset"] != [NSNull null] || dict[@"bdmachine"] != [NSNull null]) {
        if ([dict.allKeys containsObject:@"bdasset"]){
//            cell.device = dict[@"bdasset"][@"name"];
//            cell.number = dict[@"bdasset"][@"num"];
            cell.model = [searchModel modelWithDictionary:dict[@"bdasset"]];
            cell.isBinding = YES;
             NSMutableArray *arr = [NSMutableArray array];
            if ([dict.allKeys containsObject:@"hbdassetList"]) {
//                [arr addObjectsFromArray:dict[@"hbdasset"]];
                for (NSDictionary *dictionary in dict[@"hbdassetList"]) {
                    searchModel *model = [searchModel modelWithDictionary:dictionary];
                    [arr addObject:model];
                }
            }
            if ([dict.allKeys containsObject:@"hbdmachineList"]) {
//                [arr addObjectsFromArray:dict[@"hbdmachine"]];
                for (NSDictionary *dictionary in dict[@"hbdmachineList"]) {
                    chapaiModel *Model = [chapaiModel modelWithDictionary:[NSDictionary dictionaryWithObjectsAndKeys:dictionary[@"mac"],@"mac",dictionary[@"machineid"],@"machineid",dictionary[@"type"],@"type",[dictionary[@"type"] intValue] ==1?@"86型智能插座":@"智能插排",@"name", nil]];
                    [arr addObject:Model];
                }
            }
            __weak ChaKongCell *weakCell = cell;
            cell.blcok = ^{
                bindingOrHistroyBindViewController *vc = [[bindingOrHistroyBindViewController alloc] init];
                vc.relaodCollectonBlock = ^(NSArray *arr){
                    if (arr.count > 0) {
                        if ([arr[0] isKindOfClass:[searchModel class]]) {
                            weakCell.model = arr[0]
                            ;
                        }else if ([arr[0] isKindOfClass:[binddingModel class]]){
                            weakCell.model1 = arr[0];
                        }else{//chapaimodel
                            weakCell.model2 = arr[0];
                        }
                        weakCell.isBinding = YES;
                    }else{
                        weakCell.isBinding = NO;
                    }
                    weakCell.index = indexPath.row + 1;
//                    [self.collectView reloadItemsAtIndexPaths:@[indexPath]];

                };
                vc.mac = self.mac;
                vc.WhatIsBinding = 1;
                vc.type = ChaPaiChaKong;
                vc.hubs = self.hubs[indexPath.row];
                vc.hbdArr = arr;
                vc.model = weakCell.model;
                vc.name = [NSString stringWithFormat:@"八孔插排-%zd号孔",indexPath.row+1];
                vc.title = [NSString stringWithFormat:@"%zd号插孔",indexPath.row + 1];
                [self.navigationController pushViewController:vc animated:YES];
            };
        }else{
            cell.isBinding = NO;
        }
    }else{
        cell.isBinding = NO;
    }
    
    
//    UIImageView *imageV;
//    if(indexPath.row < 4){
//        imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chakong"]];
//    }else{
//        imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chakongttt"]];
//    }
//    [cell.contentView addSubview:imageV];
//    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.equalTo(cell.contentView);
//        make.top.equalTo(cell.contentView).offset(30);
//        make.left.equalTo(cell.contentView).offset(135/2.0);
//    }];
//    
//    UILabel *label = [[UILabel alloc] init];
//    [label setText:[NSString stringWithFormat:@"%zd",indexPath.row+1]];
//    [imageV addSubview:label];
//    [label mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.equalTo(imageV);
//    }];
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ChaKongCell *cell = (ChaKongCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (cell.isBinding) {
        return;
    }
    bindingOrHistroyBindViewController *vc = [[bindingOrHistroyBindViewController alloc] init];
    vc.relaodCollectonBlock = ^(NSArray *arr){
        if(arr.count > 0){
        if([arr[0] isKindOfClass:[searchModel class]]){
            cell.model = arr[0];
        }else if ([arr[0] isKindOfClass:[binddingModel class]]){
            cell.model1 = arr[0];
        }else{
            cell.model2 = arr[0];
        }
        cell.isBinding = YES;
            cell.index = indexPath.row + 1;
//        [self.collectView reloadItemsAtIndexPaths:@[indexPath]];
        }else{
            cell.isBinding = NO;
        }
    };
    vc.mac = self.mac;
    vc.WhatIsBinding = 0;
    vc.type = ChaPaiChaKong;
    vc.hubs = self.hubs[indexPath.row];
    vc.name = [NSString stringWithFormat:@"八孔插排-%zd号孔",indexPath.row+1];
    vc.title = [NSString stringWithFormat:@"%zd号插孔",indexPath.row + 1];
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:( UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath

{
    
return CGSizeMake(self.view.bounds.size.width/2.0 ,(collectionView.bounds.size.height - 6)/4.0);
    
}
-(UIEdgeInsets )collectionView:( UICollectionView *)collectionView layout:( UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:( NSInteger )section
{
    
    return UIEdgeInsetsMake ( 0 , 0 , 0 , 0 );
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 2.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 2.0f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
