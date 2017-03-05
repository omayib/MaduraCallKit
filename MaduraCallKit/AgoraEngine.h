//
//  MClient.h
//  MaduraCallKit
//
//  Created by qiscus on 1/16/17.
//  Copyright © 2017 qiscus. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol AgoraEngineDelegate

- (void)UserDidOffline;

- (void)UserDidLeaveCall;

- (void)UserDidReceiveLocalView:(UIView *)localView;

- (void)UserDidReceiveRemoteView:(UIView *)remoteView;

@end

@interface AgoraEngine : NSObject

@property(nonatomic, weak) id<AgoraEngineDelegate> delegate;

@property (strong, nonatomic) UIView *localVideo;
@property (strong, nonatomic) UIView *remoteVideo;

- (instancetype)initWithDelegate:(id<AgoraEngineDelegate>)delegate appKey:(NSString *)appKey room:(NSString *)room video:(Boolean)video;

- (void)leaveChannel;


@end
