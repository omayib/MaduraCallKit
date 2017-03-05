//
//  MClient.m
//  MaduraCallKit
//
//  Created by qiscus on 1/16/17.
//  Copyright © 2017 qiscus. All rights reserved.
//


#import "AgoraEngine.h"
#import <AgoraRtcEngineKit/AgoraRtcEngineKit.h>

#define VENDOR_KEY @""

@interface AgoraEngine()<AgoraRtcEngineDelegate>
@property (nonatomic, strong) AgoraRtcEngineKit *agoraKit;

@end

@implementation AgoraEngine

- (instancetype)initWithDelegate:(id<AgoraEngineDelegate>)delegate appKey:(NSString *)appKey room:(NSString *)room video:(Boolean)video{
    if (self = [super init]) {
        _delegate = delegate;
        [self initializeAgoraEngine:(appKey)];
        [self setupVideo:(video)];
        [self setupLocalVideo];
        [self joinChannel:(room)];
    }
    return self;
}

- (void)initializeAgoraEngine:(NSString *)key {
    self.agoraKit = [AgoraRtcEngineKit sharedEngineWithAppId:key delegate:self];
    
    //    [_delegate mClient:@"Helelo" didChangeState:@"hi"];
}

- (void)setupVideo:(Boolean)video {
    if (video) {
        [self.agoraKit enableVideo];
        // Default mode is disableVideo
        
        [self.agoraKit setVideoProfile:AgoraRtc_VideoProfile_360P swapWidthAndHeight: false];
        // Default video profile is 360P
    }
}

- (void)setupLocalVideo {
    AgoraRtcVideoCanvas *videoCanvas = [[AgoraRtcVideoCanvas alloc] init];
    videoCanvas.uid = 0;
    // UID = 0 means we let Agora pick a UID for us
    
    // Default 640x360
    _localVideo = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 360, 640)];
    
    videoCanvas.view = _localVideo;
    videoCanvas.renderMode = AgoraRtc_Render_Adaptive;
    [self.agoraKit setupLocalVideo:videoCanvas];
    // Bind local video stream to view
    [_delegate UserDidReceiveLocalView:_localVideo];
}

- (void)joinChannel:(NSString *)room {
    [self.agoraKit joinChannelByKey:nil channelName:room info:nil uid:0 joinSuccess:^(NSString *channel, NSUInteger uid, NSInteger elapsed) {
        // Join channel "demoChannel1"
        [self.agoraKit setEnableSpeakerphone:YES];
        [UIApplication sharedApplication].idleTimerDisabled = YES;
    }];
}

- (void)leaveChannel {
    [self.agoraKit leaveChannel:^(AgoraRtcStats *stat) {
        // [self hideControlButtons];     // Tutorial Step 8
        [UIApplication sharedApplication].idleTimerDisabled = NO;
        [self.remoteVideo removeFromSuperview];
        [self.localVideo removeFromSuperview];
        self.agoraKit = nil;
        NSLog(@"end call");
        [_delegate UserDidLeaveCall];
    }];
}

// MARK: Agora Delegate
- (void)rtcEngine:(AgoraRtcEngineKit *)engine firstRemoteVideoDecodedOfUid:(NSUInteger)uid size: (CGSize)size elapsed:(NSInteger)elapsed {
    NSLog(@"%@", engine);
    AgoraRtcVideoCanvas *videoCanvas = [[AgoraRtcVideoCanvas alloc] init];
    videoCanvas.uid = uid;
    // Since we are making a simple 1:1 video chat app, for simplicity sake, we are not storing the UIDs. You could use a mechanism such as an array to store the UIDs in a channel.
    _remoteVideo = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    videoCanvas.view = _remoteVideo;
    videoCanvas.renderMode = AgoraRtc_Render_Adaptive;
    [self.agoraKit setupRemoteVideo:videoCanvas];
    // Bind remote video stream to view
    
    [_delegate UserDidReceiveRemoteView:_remoteVideo];
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine didOfflineOfUid:(NSUInteger)uid reason:(AgoraRtcUserOfflineReason)reason {
    /*
     AgoraRtc_UserOffline_Quit: User has quit the call.
     AgoraRtc_UserOffline_Dropped: Session time out, unreliable,
     */
    //self.remoteVideo.hidden = true;
    NSLog(@"%lu", (unsigned long)reason);
    [_delegate UserDidOffline];
}



@end
