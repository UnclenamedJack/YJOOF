//
//  SettingsTVCTableViewController.m
//  ProjectOne-weibao
//
//  Created by jack on 16/5/26.
//  Copyright © 2016年 伍新科技有限公司. All rights reserved.
//

#import "SettingsTVCTableViewController.h"
#import "LxxPlaySound.h"
#import "CustomCell.h"
#import "SecondCell.h"
#import "reSetPassWordVC.h"
#import "Header.h"
#import "loginViewController.h"
@interface SettingsTVCTableViewController ()

@property (nonatomic,strong) UISwitch *soundSwith;

@end

@implementation SettingsTVCTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (kHeight == 480.0) {
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:16.0]}];
    }else if (kHeight == 568.0){
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:18.0]}];
    }else if (kHeight == 667.0){
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:20.0]}];
    }else{
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:22.0]}];
    }

//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.navigationItem setTitle:@"设置"];
    
    self.soundSwith = [[UISwitch alloc] init];
    [self.soundSwith addTarget:self action:@selector(soundOnOrClose) forControlEvents:UIControlEventTouchUpInside];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
//静音模式下震动提醒与否  （待检验）
- (void)soundOnOrClose {
    LxxPlaySound *playSound = [[LxxPlaySound alloc] initForPlayingVibrate];
    if (self.soundSwith.on == YES) {
        [playSound play];
    }else{
        return;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
    //return 4;
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
//    if (section == 0) {
//        return 1;
//    }else if (section == 1){
//        return 3;
//    }else{
//        return 1;
//}
    if (section == 0) {
        return 1;
        
    }else if (section == 1){
        return 1;
    }else {
        return 1;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //CustomCell *cell = [[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    CustomCell *cell = [[NSBundle mainBundle] loadNibNamed:@"CustomCell" owner:nil options:nil][0];
    
    // Configure the cell...
//    if (indexPath.section == 0) {
//        [cell.icon setContentMode:UIViewContentModeScaleAspectFit];
//        cell.nameLabel.text = @"账号与安全";
//        cell.icon.image = [UIImage imageNamed:@"safe"];
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    }else
//    if (indexPath.section == 1 ){
//        if (indexPath.row == 0) {
//            [cell.icon setContentMode:UIViewContentModeScaleAspectFit];
//            cell.icon.image = [UIImage imageNamed:@"quiet"];
//            cell.nameLabel.text = @"静音模式提醒";
//            cell.accessoryView = self.soundSwith;
//
//        }else if (indexPath.row == 1){
//            [cell.icon setContentMode:UIViewContentModeScaleAspectFit];
//            cell.icon.image = [UIImage imageNamed:@"Microphone"];
//            cell.nameLabel.text = @"设置提醒音量";
//            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        }else{
//            
//            SecondCell *cell = [[NSBundle mainBundle] loadNibNamed:@"SecondCell" owner:nil options:nil][0];
//            [cell.icon setContentMode:UIViewContentModeScaleAspectFit];
//            cell.icon.image = [UIImage imageNamed:@"Speedometer"];
//            cell.nameLabel.text = @"设置延时时长";
//            cell.timeLabel.text = @"5分钟";
//            [cell.timeLabel setTextColor:[UIColor grayColor]];
//            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//            return cell;
//        }
//    }else if (indexPath.section == 2){
//        [cell.icon setContentMode:UIViewContentModeScaleAspectFit];
//        cell.icon.image = [UIImage imageNamed:@"Emoticon"];
//        cell.nameLabel.text = @"关于";
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    }else{
//        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
//        cell.textLabel.text = @"退出登录";
//        [cell.textLabel setTextColor:[UIColor redColor]];
//        [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
//        return cell;
//    }
//    return cell;
    
    if (indexPath.section == 0) {
        [cell.icon setContentMode:UIViewContentModeScaleAspectFit];
        cell.nameLabel.text = @"账号与安全";
        cell.icon.image = [UIImage imageNamed:@"safe"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if (indexPath.section == 1){
        [cell.icon setContentMode:UIViewContentModeScaleAspectFit];
        cell.icon.image = [UIImage imageNamed:@"Emoticon"];
        cell.nameLabel.text = @"关于";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.textLabel.text = @"退出登录";
        [cell.textLabel setTextColor:[UIColor redColor]];
        [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
        [cell.textLabel setFont:[UIFont systemFontOfSize:18.0]];
        return cell;
    }
    return cell;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.section == 0) {
//        reSetPassWordVC *VC = [[reSetPassWordVC alloc] init];
//        [self.navigationController pushViewController:VC animated:YES];
//    }else if (indexPath.section == 1 && indexPath.row == 2 ) {
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"请输入延时时长" preferredStyle:UIAlertControllerStyleAlert];
//        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
//            textField = [[UITextField alloc] init];
//            [textField setBackgroundColor:[UIColor blackColor]];
//            [textField setTextColor:[UIColor redColor]];
//            
//            [textField.layer setBorderWidth:1.0];
//            [textField.layer setBorderColor:[UIColor redColor].CGColor];
//        }];
//        [self presentViewController:alert animated:YES completion:nil];
//        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            NSString *delayTimeMinate =  alert.textFields[0].text;
//            SecondCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//            cell.timeLabel.text = [NSString stringWithFormat:@"%@分钟",delayTimeMinate];
//        }];
//        [alert addAction:action];
//    }else if (indexPath.section == 3){
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"退出登录" preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//        UIAlertAction *action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            [self.navigationController dismissViewControllerAnimated:YES completion:^{
//                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"zhanghao"];
//                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"mima"];
//                [[NSUserDefaults standardUserDefaults] synchronize];
//            }];
//        }];
//        [alert addAction:action1];
//        [alert addAction:action];
//        [self presentViewController:alert animated:YES completion:nil];
//        
//    }
    
    if (indexPath.section == 0) {
        reSetPassWordVC *VC = [[reSetPassWordVC alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
    }else if (indexPath.section == 2){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"退出登录" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"zhanghao"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"mima"];
            [[NSUserDefaults standardUserDefaults] synchronize];

            loginViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"loginVC"];
            [self.navigationController presentViewController:vc animated:YES completion:nil];
            //bug
//            [self.navigationController dismissViewControllerAnimated:YES completion:^{
//                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"zhanghao"];
//                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"mima"];
//                [[NSUserDefaults standardUserDefaults] synchronize];
//            }];
        }];
        [alert addAction:action1];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isCodeSuccess"];
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
