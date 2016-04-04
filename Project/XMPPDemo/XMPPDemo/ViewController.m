//
//  ViewController.m
//  XMPPDemo
//
//  Created by pk on 15/1/28.
//  Copyright (c) 2015年 pk. All rights reserved.
//

#import "ViewController.h"
#import "XMPPFramework.h"

#define HOST @"1000phone.net"
@interface ViewController ()<XMPPStreamDelegate>{
    IBOutlet UITextField* _nameField;
    IBOutlet UITextField* _passwordField;
    IBOutlet UITextField* _friendField;
    IBOutlet UITextField* _textField;
    XMPPStream* _stream;
}

- (IBAction)reg:(id)sender;
- (IBAction)login:(id)sender;
- (IBAction)addFriend:(id)sender;
- (IBAction)sendText:(id)sender;
- (IBAction)getFriendList:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _stream = [[XMPPStream alloc] init];
    [_stream setHostName:HOST];
    [_stream addDelegate:self delegateQueue:dispatch_get_main_queue()];
}

//上线
- (void)goOnline{
    //<presence/>
    XMPPPresence* presence = [XMPPPresence presence];
    [_stream sendElement:presence];
}

//下线
- (void)goOffline{
    //<presence type="unavailable"/>
    XMPPPresence* presence = [XMPPPresence presenceWithType:@"unavailable"];
    [_stream sendElement:presence];
    [_stream disconnect];
}

//注册
- (IBAction)reg:(id)sender{
    //如果已经连接，先断开
    if (_stream.isConnected) {
        [self goOffline];
    }
    [_stream setMyJID:[XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@", _nameField.text, HOST]]];
    _stream.tag = @"注册";
    [_stream connectWithTimeout:30 error:nil];
}

//登陆
- (IBAction)login:(id)sender{
    //如果已经连接，先断开
    if (_stream.isConnected) {
        [self goOffline];
    }
    //设置要登陆的jid
    [_stream setMyJID:[XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@", _nameField.text, HOST]]];
    _stream.tag = @"登陆";
    //连接
    [_stream connectWithTimeout:30 error:nil];
}

//添加好友
- (IBAction)addFriend:(id)sender{
    /*
     <presence type="subscribe" to="好友jid"/>
     */
    XMPPPresence* presence = [XMPPPresence presenceWithType:@"subscribe" to:[XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@", _friendField.text, HOST]]];
    [_stream sendElement:presence];
}

//接收好友请求
- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence{
    //判断是否是一个好友请求
    if ([presence.type isEqualToString:@"subscribe"]) {
        //同意好友请求
        XMPPPresence* pre = [XMPPPresence presenceWithType:@"subscribed" to:presence.from];
        [_stream sendElement:pre];
    }
    //判断是否添加成功
    if ([presence.type isEqualToString:@"subscribed"]) {
        NSLog(@"添加好友 %@ 成功", presence.fromStr);
    }
    NSLog(@"%@", presence.type);
}

//好友列表
- (IBAction)getFriendList:(id)sender{
    /*
     <iq type="get" id="roster">
        <query xmlns="jabber:iq:roster"/>
     </iq>
     */
    XMPPIQ* iq = [XMPPIQ iqWithType:@"get"];
    [iq addAttributeWithName:@"id" stringValue:@"roster"];
    NSXMLElement* query = [NSXMLElement elementWithName:@"query" xmlns:@"jabber:iq:roster"];
    [iq addChild:query];
    [_stream sendElement:iq];
}

//接收好友列表
- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq{
    /*
     <iq>
        <query>
             <item jid=""/>
             <item jid=""/>
             <item jid=""/>
        </query>
     </iq>
     */
    NSXMLElement* query = iq.children[0];
    for (NSXMLElement* item in query.children) {
        NSLog(@"%@", item.XMLString);
    }
    
    return YES;
}


//发送消息
- (IBAction)sendText:(id)sender{
    /*
     <message to="老郭" type="chat">
        <body>
            老严吃醋了。
        </body>
     </message>
     */
    XMPPMessage* message = [XMPPMessage messageWithType:@"chat" to:[XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@", _friendField.text, HOST]]];
    NSXMLElement* body = [NSXMLElement elementWithName:@"body" stringValue:_textField.text];
    [message addChild:body];
    [_stream sendElement:message];
}

//接收消息
- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message{
    NSLog(@"%@:%@", message.fromStr, message.stringValue);
}

//连接成功
- (void)xmppStreamDidConnect:(XMPPStream *)sender{
    NSLog(@"连接成功");
    //注册
    if ([sender.tag isEqualToString:@"注册"]) {
        [_stream registerWithPassword:_passwordField.text error:nil];
    }
    //登陆
    if ([sender.tag isEqualToString:@"登陆"]) {
        [_stream authenticateWithPassword:_passwordField.text error:nil];
    }
}

//登陆成功
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender{
    NSLog(@"登陆成功");
    [self goOnline];
}

//注册成功
- (void)xmppStreamDidRegister:(XMPPStream *)sender{
    NSLog(@"注册成功");
}




@end
