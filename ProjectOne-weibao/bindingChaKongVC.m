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


@interface bindingChaKongVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@end

@implementation bindingChaKongVC
static NSString *identifier = @"collection";
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
    [macDress setFont:[UIFont boldSystemFontOfSize:18.0]];
    [topView addSubview:macDress];
    [macDress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(topView);
        make.centerY.equalTo(topView).offset(-15);
        make.left.equalTo(topView).offset(25);
    }];
    
    UILabel *macName = [[UILabel alloc] init];
    [macName setTextColor:[UIColor hexChangeFloat:@"ffffff"]];
    [macName setText:@"8孔智能插排"];
    [macName setFont:[UIFont boldSystemFontOfSize:13.0]];
    [topView addSubview:macName];
    [macName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(topView);
        make.top.equalTo(macDress.mas_bottom).offset(8);
        make.left.equalTo(macDress);
    }];

    UILabel *label = [[UILabel alloc] init];
    [label setFont:[UIFont systemFontOfSize:10.0]];
    [label setTextColor:[UIColor hexChangeFloat:@"ffffff"]];
    [label setText:@"*8孔以插线板开关在左上方为顺序排列"];
    [topView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(macName);
        make.bottom.equalTo(topView).offset(-10);
    }];
    
   
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    UICollectionView *collectView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
//    [collectView setBackgroundColor:[UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1.0]];
    [collectView setBackgroundColor:[UIColor redColor]];
    collectView.delegate = self;
    collectView.dataSource = self;
    [self.view addSubview:collectView];
    [collectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom).offset(5);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    layout.itemSize = CGSizeMake(self.view.frame.size.width/2.0, collectView.frame.size.height/4.0);
    [collectView registerClass:[ChaKongCell class] forCellWithReuseIdentifier:identifier];
    [collectView setScrollEnabled:NO];
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
    cell.mac = self.mac;
    NSDictionary *dict;
    for (NSDictionary *dict1 in self.hubs) {
        if ([dict1[@"num"] integerValue] == indexPath.row + 1) {
            dict = dict1;
        }
    }
    if (dict){
        if (dict[@"bdassetid"] != [NSNull null] || dict[@"bdmachineid"] != [NSNull null]) {
            cell.isBinding = YES;
            cell.blcok = ^{
                bindingOrHistroyBindViewController *vc = [[bindingOrHistroyBindViewController alloc] init];
                vc.mac = self.mac;
                vc.WhatIsBinding = 0;
                vc.type = ChaPaiChaKong;
                vc.hubs = self.hubs[indexPath.row];
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
    bindingOrHistroyBindViewController *vc = [[bindingOrHistroyBindViewController alloc] init];
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
    
return CGSizeMake(self.view.bounds.size.width/2.0 ,(collectionView.bounds.size.height)/4.0);
    
}
-(UIEdgeInsets )collectionView:( UICollectionView *)collectionView layout:( UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:( NSInteger )section
{
    
    return UIEdgeInsetsMake ( 0 , 0 , 0 , 0 );
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 2;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
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
