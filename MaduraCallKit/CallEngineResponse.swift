//
//  CallEngineResponse.swift
//  MaduraCallKit
//
//  Created by qiscus on 1/17/17.
//  Copyright © 2017 qiscus. All rights reserved.
//

import Foundation
public protocol CallEngineResponse{
    func userDidLeave()
    func userDidOffline()
    func localVideoDidLoad(any: Any?)
    func remoteVideoDidLoad(any: Any?)
}
