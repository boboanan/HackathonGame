//
//  ViewController.h
//  MultiPeerConnectivity
//
//  Created by Huang XiaoWen on 14-4-8.
//  Copyright (c) 2014年 Huang XiaoWen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface ViewController : UIViewController<MCSessionDelegate,MCBrowserViewControllerDelegate>{
    
}

#pragma mark- 消息事件
-(IBAction)serverValueChange:(id)sender;
-(IBAction)clientStart:(id)sender;
-(IBAction)clientStop:(id)sender;


@end
