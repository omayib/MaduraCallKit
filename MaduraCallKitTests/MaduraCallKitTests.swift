//
//  MaduraCallKitTests.swift
//  MaduraCallKitTests
//
//  Created by qiscus on 1/15/17.
//  Copyright © 2017 qiscus. All rights reserved.
//

import XCTest
@testable import MaduraCallKit

class MaduraCallKitTests: XCTestCase {
    var callerEngineReponse: CallEngineResponse?
    var calleeEngineReponse: CallEngineResponse?
    var callerKey="12ee6202b79f4b17962c4d819d43bb60"
    var calleeKey="25f870f0316740ae812fa6576576030e"
    var callerCommand, calleeCommand: CallEngineCommand?
    var callSessionId: String = ""
    var userId: String = "123"
    
    override func setUp() {
        super.setUp()
        
        let timestamp = Date().timeIntervalSince1970
        callSessionId = UUID().uuidString+self.userId+String.init(format: "%.0f", timestamp)
        
        callerEngineReponse = MockCallerResponse()
        calleeEngineReponse = MockCalleeResponse()
        
        let callEngine = MaduraCallEngine(engineVersion: .Bangkalan, responseHandler: callerEngineReponse!)
        callerCommand = callEngine.callEngineCommand!
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    func testCreateCallSessionId(){
        let timestamp = Date().timeIntervalSince1970
        let callSessionId = UUID().uuidString+self.userId+String.init(format: "%.0f", timestamp)
        
        XCTAssertNotNil(callSessionId)
        
    }
    func testJoinToACallSession() {
        let response = callerEngineReponse as! MockCallerResponse
        response.expLocalVideo = expectation(description: "join to call engine succeed")
        
        callerCommand?.joinSession(callSessionId: callSessionId)
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertNotNil(response.localVideo)
    }
    func testLeaveFromACallSession() {
        let timestamp = Date().timeIntervalSince1970
        let callSessionId = UUID().uuidString+self.userId+String.init(format: "%.0f", timestamp)
        
        let response = callerEngineReponse as! MockCallerResponse
        response.expLocalVideo = expectation(description: "join to callsesion")
        
        callerCommand?.joinSession(callSessionId: callSessionId)
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertNotNil(response.localVideo)
        
        response.expLocalVideo = expectation(description: "leave from callsesion")
        callerCommand?.leaveSession()
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertNil(response.localVideo)
    }
    
}

class MockCallerResponse: CallEngineResponse{
    
    var expLocalVideo, expRemoteVideo : XCTestExpectation?
    var localVideo, remoteVideo: Any?
    
    
    
    func remoteVideoDidLoad(any: Any?) {
        print("caller gajah")
        remoteVideo = any!
        expRemoteVideo?.fulfill()
    }
    func localVideoDidLoad(any: Any?) {
        print("caller jerapah")
        localVideo = any!
        expLocalVideo?.fulfill()
    }
}


class MockCalleeResponse: CallEngineResponse{
    
    var expLocalVideo, expRemoteVideo : XCTestExpectation?
    var localVideo, remoteVideo: Any?
    
    func remoteVideoDidLoad(any: Any?) {
        print("callee gajah")
        remoteVideo = any!
        expRemoteVideo?.fulfill()
    }
    func localVideoDidLoad(any: Any?) {
        print("callee jerapah")
        localVideo = any!
        expLocalVideo?.fulfill()
    }
}
