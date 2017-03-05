//
//  MaduraApplication.swift
//  MaduraCallKit
//
//  Created by qiscus on 1/16/17.
//  Copyright © 2017 qiscus. All rights reserved.
//

import Foundation
/**
 MaduraCallSdk is consist of more than one call engine. We can using Agora, Toxbox, Eros or other third library. We declare each engine with different initial name.
 */
public enum EngineVersion{
    /**
     madura will using Agora call engine.
     */
    case Bangkalan
    /**
     madura will using Toxbox call engine.
     */
    case Sampangan
    /**
     madura will using Eros call engine.
     */
    case Pamekasan
    /**
     madura will using other call engine.
     */
    case Sumenep
}
/**
 Hi, i am MaduraCallEngine. My responsibility is decide the specific call engine should be used. Please notice, we are using strategy pattern to support switching feature among call engine on runtime.
 */
public class MaduraCallEngine  {
    
    private(set) public var callEngineCommand : CallEngineCommand?
    private var agoraAppKey = "12ee6202b79f4b17962c4d819d43bb60"
    
    public init(engineVersion: EngineVersion, responseHandler: CallEngineResponse) {
        
        switch engineVersion {
        case .Bangkalan:
            print("using agora...")
            self.callEngineCommand = AgoraCallEngine(callEngineResponse: responseHandler, appKey: agoraAppKey)
            break
        default:
            print("using other engine...")
        }
    }
}
