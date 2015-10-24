//
//  MainViewController.h
//  HackthonGame
//
//  Created by 锄禾日当午 on 15/10/24.
//  Copyright (c) 2015年 B&K. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *what;
@property (weak, nonatomic) IBOutlet UILabel *attackNumLabel;

@property (weak, nonatomic) IBOutlet UIButton *attackBtn;
//@property (weak, nonatomic) IBOutlet UILabel *lifeLabel;
@property (weak, nonatomic) IBOutlet UILabel *lifeLabel;

@property (weak, nonatomic) IBOutlet UILabel *defendLabel;

@end
