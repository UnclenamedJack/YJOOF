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

@interface bindingChaKongVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@end

@implementation bindingChaKongVC
static NSString *identifier = @"collection";
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.title = @"插排信息";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    
    UIView *topView = [[UIView alloc] init];
    [topView setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(self.view).multipliedBy(0.25);
    }];
    
    UILabel *macDress = [[UILabel alloc] init];
    if (_mac) {
        [macDress setText:_mac];
    }else{
        [macDress setText:@"MAC:5c:cf:7f:0a:11:d3:"];
    }
    [macDress setFont:[UIFont boldSystemFontOfSize:16.0]];
    [topView addSubview:macDress];
    [macDress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(topView);
        make.centerY.equalTo(topView).offset(-15);
    }];
    
    UILabel *macName = [[UILabel alloc] init];
    [macName setText:@"86型智能插座"];
    [macName setFont:[UIFont boldSystemFontOfSize:16.0]];
    [topView addSubview:macName];
    [macName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(topView);
        make.top.equalTo(macDress.mas_bottom).offset(8);
    }];

   
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    UICollectionView *collectView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    [collectView setBackgroundColor:[UIColor greenColor]];
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
    [collectView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:identifier];
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
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor redColor];
    UILabel *label = [[UILabel alloc] init];
    [label setText:[NSString stringWithFormat:@"%ld",indexPath.row+1]];
    [cell.contentView addSubview:label];
    [cell.contentView setBackgroundColor:[UIColor redColor]];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(cell.contentView);
    }];
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    bindingOrHistroyBindViewController *vc = [[bindingOrHistroyBindViewController alloc] init];
    vc.mac = self.mac;
    vc.WhatIsBinding = 0;
    vc.hubs = self.hubs[indexPath.row];
    vc.name = [NSString stringWithFormat:@"八孔插排-%ld号孔",indexPath.row+1];
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:( UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath

{
    
return CGSizeMake(self.view.bounds.size.width/2.0,(collectionView.bounds.size.height)/4.0);
    
}
-(UIEdgeInsets )collectionView:( UICollectionView *)collectionView layout:( UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:( NSInteger )section
{
    
    return UIEdgeInsetsMake ( 0 , 0 , 0 , 0 );
    
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
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
