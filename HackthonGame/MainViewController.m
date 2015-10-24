//
//  MainViewController.m
//  HackthonGame
//
//  Created by 锄禾日当午 on 15/10/24.
//  Copyright (c) 2015年 B&K. All rights reserved.
//
#define ATTACKENERGY 10
#define DEFENDACESS 50
#import "MainViewController.h"
#import <CoreMotion/CoreMotion.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import <CoreGraphics/CoreGraphics.h>
#define SERVICE_TYPE @"etayu"

@interface MainViewController ()<MCSessionDelegate,MCBrowserViewControllerDelegate>
@property (nonatomic, strong)CMMotionManager *motionManager;

@property(nonatomic,retain) MCPeerID *peelId;
@property (nonatomic,retain)MCPeerID *anotherPeelId;
@property(nonatomic,retain) MCSession *session;
@property(nonatomic,retain) MCAdvertiserAssistant *advertiserAssistant;
@property (nonatomic)int life;
@property(nonatomic,retain) MCBrowserViewController *browser;
@end

@implementation MainViewController
@synthesize lifeLabel = _lifeLabel;
static  int num = 0;
static int attackNum = 0;
//static int life = 100;
static const int attackEnergy = 45;

static int defend = 0;
-(CMMotionManager *)motionManager
{
    if(_motionManager == nil){
        
        _motionManager=[[CMMotionManager alloc]init];
        _motionManager.accelerometerUpdateInterval = 0.1; // 告诉manager，更新频率是100Hz
        [_motionManager startDeviceMotionUpdates];
        [_motionManager startAccelerometerUpdates];
        [_motionManager startGyroUpdates];
        [_motionManager startMagnetometerUpdates];
        
        
    }
    return _motionManager;
}

//-(UILabel *)lifeLabel
//{
//    if(_lifeLabel == nil)
//    {
//        _lifeLabel.text = [NSString stringWithFormat:@"%d",self.life];
//    }
//    return _lifeLabel;
//}

-(void)setLife:(int)life
{
    _life = life;
//    self.lifeLabel.text = [NSString stringWithFormat:@"%d",_life];
}

//-(void)setLifeLabel:(UILabel *)lifeLabel
//{
//    _lifeLabel = lifeLabel;
//    
//    self.lifeLabel.text = [NSString stringWithFormat:@"%d",self.life];
//    
//}

#pragma mark - 生命周期函数
- (void)viewDidLoad {
    [super viewDidLoad];
   
    // 设置允许摇一摇功能
    [UIApplication sharedApplication].applicationSupportsShakeToEdit = YES;
    // 并让自己成为第一响应者
    [self becomeFirstResponder];
    self.life = 100;
  
    self.peelId = [[MCPeerID alloc] initWithDisplayName:[[UIDevice currentDevice] name]];
    NSLog(@"%@",self.peelId);
    self.session = [[MCSession alloc] initWithPeer:_peelId];
    _session.delegate = self;
    self.advertiserAssistant = [[MCAdvertiserAssistant alloc] initWithServiceType:SERVICE_TYPE discoveryInfo:nil session:_session] ;
    [_advertiserAssistant start];
    

}

-(IBAction)clientStart:(id)sender{
    if (nil == _browser) {
        self.browser = [[MCBrowserViewController alloc] initWithServiceType:SERVICE_TYPE session:_session] ;
        _browser.delegate = self;
    }
    [self presentViewController:_browser animated:YES completion:nil];
}

- (IBAction)updateClick:(id)sender {
    if(attackNum<1)return;
    
    defend += DEFENDACESS;
    attackNum--;
    self.attackNumLabel.text = [NSString stringWithFormat:@"%d",attackNum];
    self.defendLabel.text = [NSString stringWithFormat:@"%d",defend];
}

- (IBAction)clearClick:(id)sender {
    self.life = 100;
    self.lifeLabel.text = [NSString stringWithFormat:@"%d",self.life];
    defend = 0;
    self.defendLabel.text = [NSString stringWithFormat:@"%d",defend];
    attackNum =0;
    self.attackNumLabel.text = [NSString stringWithFormat:@"%d",attackNum];
    num = 0;
    self.what.text = @"what";
    if (_session) {
        [_session disconnect];
    }
}
- (IBAction)whateverClick:(id)sender {
    if(attackNum<1)return;
    int a = arc4random_uniform(80)%81;
    NSLog(@"%d",a);
    if(a/2 == 0){
        defend = a;
        self.defendLabel.text = [NSString stringWithFormat:@"%d",defend];
    }else{
        //    [UIView animateWithDuration:1 animations:^{
        int attackBetter = a;
        NSData *data = [NSData dataWithBytes: &attackBetter length: sizeof(attackBetter)];
        [self.session sendData:data toPeers:@[self.anotherPeelId] withMode:MCSessionSendDataReliable error:nil];
       
        
    }
      attackNum--;
     self.attackNumLabel.text = [NSString stringWithFormat:@"%d",attackNum];
    
}

- (IBAction)attackClick:(id)sender {
    if(attackNum<1)return;
//    [UIView animateWithDuration:1 animations:^{
        NSLog(@"发送信息");
        NSData *data = [NSData dataWithBytes: &attackEnergy length: sizeof(attackEnergy)];
        [self.session sendData:data toPeers:@[self.anotherPeelId] withMode:MCSessionSendDataReliable error:nil];
        
        attackNum--;
        self.attackNumLabel.text = [NSString stringWithFormat:@"%d",attackNum];
        
//    } completion:^(BOOL finished) {
//

}


#pragma mark - 摇一摇相关方法
// 摇一摇开始摇动
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    NSLog(@"开始摇动");
    num++;
    if(num == ATTACKENERGY){
        attackNum++;
        num = 0;
    }
    self.what.text = [NSString stringWithFormat:@"%d",num];
    self.attackNumLabel.text = [NSString stringWithFormat:@"%d",attackNum];
    
    return;
}

// 摇一摇取消摇动
- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    NSLog(@"取消摇动");
    return;
}

// 摇一摇摇动结束
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (event.subtype == UIEventSubtypeMotionShake) { // 判断是否是摇动结束
        NSLog(@"摇动结束");
    }
    return;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark- MCSessionDelegate
// Remote peer changed state
- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state{
//    NSLog(@"session:%@ peer:%@ didChangeState:%ld",session,peerID,(long)state);
    NSLog(@"lalalaaal%@",peerID);
    self.anotherPeelId = peerID;
    NSLog(@"环境改变");
}

// Received data from remote peer
- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID{
//    NSLog(@"session:%@ didReceiveData:%@ fromPeer:%@",session,data,peerID);
//    NSString *str = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
//
//    if([str isEqual:@"you win"]){
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"you win" message:nil delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
//        [alert show];
//        [self clearClick:nil];
//    }
    NSLog(@"受到伤害");
    
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    int attack = [str intValue];
    NSLog(@"attack:%d",attack);
//    life -= num;
    int destroy = attackEnergy-defend;
    NSLog(@"%d",defend);
    if(destroy>=0){
        self.life= self.life - destroy;
//        NSLog(@"当前生命值%d",self.life);
       
         dispatch_sync(dispatch_get_main_queue(), ^{
             
             self.lifeLabel.text = [NSString stringWithFormat:@"%d",self.life];
             if(self.life<=0){
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"you lose" message:nil delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
                 [alert show];
                 [self clearClick:nil];
                 NSData *data =  [@"you win" dataUsingEncoding:NSUTF8StringEncoding];
                 [self.session sendData:data toPeers:@[self.anotherPeelId] withMode:MCSessionSendDataReliable error:nil];
             }
            
        });
    }else{
        defend -=DEFENDACESS;
       
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            self.defendLabel.text = [NSString stringWithFormat:@"%d",defend];
            
            
        });
    }
    //    }];
  

  
}

// Received a byte stream from remote peer
- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID{
//    NSLog(@"session:%@ didReceiveStream:%@ fromPeer:%@",session,stream,peerID);
}

// Start receiving a resource from remote peer
- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress{
//    NSLog(@"session:%@ didStartReceivingResourceWithName:%@ fromPeer:%@ withProgress:%@",session,resourceName,peerID,progress);
}

// Finished receiving a resource from remote peer and saved the content in a temporary location - the app is responsible for moving the file to a permanent location within its sandbox
- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error{
//    NSLog(@"session:%@ didStartReceivingResourceWithName:%@ fromPeer:%@ atURL:%@ withError:%@",session,resourceName,peerID,localURL,error);
}

#pragma mark- MCBrowserViewControllerDelegate
// Notifies the delegate, when the user taps the done button
- (void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController{
//    NSLog(@"browserViewControllerDidFinish:%@",browserViewController);
    [browserViewController dismissViewControllerAnimated:YES completion:NULL];
}

// Notifies delegate that the user taps the cancel button.
- (void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController{
//    NSLog(@"browserViewControllerWasCancelled:%@",browserViewController);
    [browserViewController dismissViewControllerAnimated:YES completion:NULL];
}



@end
