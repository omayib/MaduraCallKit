//
//  MaduraCall.swift
//  MaduraCallKit
//
//  Created by qiscus on 1/16/17.
//  Copyright © 2017 qiscus. All rights reserved.
//

import Foundation
public protocol CallEngineCommand{
    func joinSession(callSessionId:String)
    func leaveSession()
}
