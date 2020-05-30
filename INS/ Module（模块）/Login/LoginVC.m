//
//  LoginVC.m
//  INS
//
//  Created by lu peihan on 2020/5/30.
//  Copyright © 2020 lu peihan. All rights reserved.
//

#import "LoginVC.h"
#import "AppDelegate.h"

// 临时
#import "RequestTool.h"
#import "DepartMent.h"



@interface LoginVC ()

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
}

- (IBAction)login:(id)sender
{
      [((AppDelegate*) AppDelegateInstance) setupHomeViewController];
}




#warning 临时参考调用代码
// 数据请求
- (void)requestTest
{
    NSString *url = @"http://119.23.47.203:7005/UTAPPService/JOYOD/LoginCheckByNameOrTel";


    [RequestTool GET:url
          parameters:@{@"userName":@"LPH",
                       @"pwd":@"98212E3BAFB80DF6",
                       @"pdaId":@"1B11558A-AC20-4B9D-AC28-E91EE7CCBCD1"
          }
             success:^(id responseObject) {



    } failure:^(NSError *error) {

    }];
}




// 数据库调用示例
- (void)DBTest
{
    //  批量保存
    NSMutableArray *arrayData = [[NSMutableArray alloc] init];
    NSDictionary *dicDepartMent = @{@"Dept":@"123459789"};
    NSDictionary *dicDepartMent2 = @{@"Dept":@"呵呵"};
    DepartMent *model1 = [DepartMent modelWithDict:dicDepartMent];
    DepartMent *model2 = [DepartMent modelWithDict:dicDepartMent2];
    [arrayData addObject:model1];
    [arrayData addObject:model2];
    [DepartMent saveObjects:arrayData];
    
    //  单个保存
    // 字典转model
   NSDictionary *dicDepartMent3 = @{@"Dept":@"字典转model"};
    DepartMent *model3 = [DepartMent modelWithDict:dicDepartMent3];
    [model3 save];

    // 更新
    model3.Dept = @"0000";
    [model3 update];
    
    // 查询
    NSArray *arrayDB = [DepartMent findByCriteria:[NSString stringWithFormat:@"WHERE Dept=%@",@"123459789"]];
    
    // 查询
    NSArray *arr = [DepartMent findAll];
    
    // 删除 方式一
    //     [DepartMent deleteObjectsByCriteria:[NSString stringWithFormat:@"Where Dept = '%@'",@"0000"]];
    // 删除 方式二
    [DepartMent deleteObjects:arr Column:@"Dept" value:@"0000"];
    
        // 清空
    [DepartMent clearTable];
}


@end
