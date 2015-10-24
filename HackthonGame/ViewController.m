//
//  ViewController.m
//  MultiPeerConnectivity
//
//  Created by Huang XiaoWen on 14-4-8.
//  Copyright (c) 2014年 Huang XiaoWen. All rights reserved.
//

#import "ViewController.h"
#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import <CoreGraphics/CoreGraphics.h>
#define SERVICE_TYPE @"etayu"

@interface ViewController ()
@property(nonatomic,retain) IBOutlet UISwitch *serverSwitch;
@property(nonatomic,retain) IBOutlet UIButton *clientStopButton;
@property(nonatomic,retain) IBOutlet UIButton *clientStartButton;

@property(nonatomic,retain) MCPeerID *peelId;
@property(nonatomic,retain) MCSession *session;
@property(nonatomic,retain) MCAdvertiserAssistant *advertiserAssistant;
@property(nonatomic,retain) MCBrowserViewController *browser;

@end

@implementation ViewController
@synthesize serverSwitch = _serverSwitch;
@synthesize clientStopButton = _clientStopButton;
@synthesize clientStartButton = _clientStartButton;
@synthesize peelId = _peelId;
@synthesize session = _session;
@synthesize advertiserAssistant = _advertiserAssistant;
@synthesize browser = _browser;

#pragma mark- 界面处理
-(void)serverStateChangeClientButton{
    if (_serverSwitch.on) {
        [_clientStartButton setEnabled:NO];
        [_clientStopButton setEnabled:NO];
    }else{
        [_clientStartButton setEnabled:YES];
        [_clientStopButton setEnabled:YES];
    }
}

#pragma mark- 重写
- (void)viewDidLoad{
    [super viewDidLoad];
    self.peelId = [[MCPeerID alloc] initWithDisplayName:[[UIDevice currentDevice] name]];
    self.session = [[MCSession alloc] initWithPeer:_peelId];
    _session.delegate = self;
    
    _serverSwitch.on = NO;
    [self serverStateChangeClientButton];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- 操作
-(void)disconnectSession{
    if (_session) {
        [_session disconnect];
    }
}

#pragma mark- 消息事件
-(IBAction)serverValueChange:(id)sender{
    [self serverStateChangeClientButton];
    if (_serverSwitch.on) {
        if (nil == _advertiserAssistant) {
            self.advertiserAssistant = [[MCAdvertiserAssistant alloc] initWithServiceType:SERVICE_TYPE discoveryInfo:nil session:_session] ;
            [_advertiserAssistant start];
        }
    }else{
        [self disconnectSession];
    }
}

-(IBAction)clientStart:(id)sender{
    if (nil == _browser) {
        self.browser = [[MCBrowserViewController alloc] initWithServiceType:SERVICE_TYPE session:_session] ;
        _browser.delegate = self;
    }
    [self presentViewController:_browser animated:YES completion:nil];
}

-(IBAction)clientStop:(id)sender{
    [self disconnectSession];
}

#pragma mark- MCSessionDelegate
// Remote peer changed state
- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state{
    NSLog(@"session:%@ peer:%@ didChangeState:%d",session,peerID,state);
}

// Received data from remote peer
- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID{
    NSLog(@"session:%@ didReceiveData:%@ fromPeer:%@",session,data,peerID);
}

// Received a byte stream from remote peer
- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID{
    NSLog(@"session:%@ didReceiveStream:%@ fromPeer:%@",session,stream,peerID);
}

// Start receiving a resource from remote peer
- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress{
    NSLog(@"session:%@ didStartReceivingResourceWithName:%@ fromPeer:%@ withProgress:%@",session,resourceName,peerID,progress);
}

// Finished receiving a resource from remote peer and saved the content in a temporary location - the app is responsible for moving the file to a permanent location within its sandbox
- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error{
    NSLog(@"session:%@ didStartReceivingResourceWithName:%@ fromPeer:%@ atURL:%@ withError:%@",session,resourceName,peerID,localURL,error);
}

#pragma mark- MCBrowserViewControllerDelegate
// Notifies the delegate, when the user taps the done button
- (void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController{
    NSLog(@"browserViewControllerDidFinish:%@",browserViewController);
    [browserViewController dismissViewControllerAnimated:YES completion:NULL];
}

// Notifies delegate that the user taps the cancel button.
- (void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController{
    NSLog(@"browserViewControllerWasCancelled:%@",browserViewController);
    [browserViewController dismissViewControllerAnimated:YES completion:NULL];
}



@end
