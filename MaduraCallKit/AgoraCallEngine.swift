//
//  AgoraCallEngine.swift
//  MaduraCallKit
//
//  Created by qiscus on 1/16/17.
//  Copyright © 2017 qiscus. All rights reserved.
//

import Foundation
class AgoraCallEngine : CallEngineCommand {
  

    private var agora: AgoraEngine? = nil
    internal var callEngineResponse: CallEngineResponse?
    private var appKey = ""
    
    init(callEngineResponse: CallEngineResponse, appKey:String) {
        self.appKey = appKey
        self.callEngineResponse = callEngineResponse
    }
    internal func leaveSession() {
        print("agora call engine is leaveSession....")
        self.agora?.leaveChannel()
    }
    
    internal func joinSession(callSessionId: String) {
        
        print("agora call engine is dialling to callsessionid \(callSessionId)")
        self.agora = AgoraEngine.init(delegate: self, appKey: self.appKey, room: callSessionId, video: true)
        
    
    }
}

extension AgoraCallEngine: AgoraEngineDelegate{
   
    func userDidOffline() {
        self.callEngineResponse?.userDidOffline()
    }
    
    func userDidLeaveCall() {
        print("agoracallengine did leave call")
        self.callEngineResponse?.userDidLeave()
    }
    
    func userDidReceiveLocalView(_ localView: UIView!) {
        print("agora engine delegate didreceive localview")
        self.callEngineResponse?.localVideoDidLoad(any: localView)
        
    }
    func userDidReceiveRemoteView(_ remoteView: UIView!) {
        print("agora engine delegate didReceiveRemoteView")
        self.callEngineResponse?.remoteVideoDidLoad(any: remoteView)
        
    }
}
