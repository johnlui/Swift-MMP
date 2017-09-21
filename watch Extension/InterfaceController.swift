//
//  InterfaceController.swift
//  watch Extension
//
//  Created by John Lui on 2017/9/14.
//  Copyright © 2017年 John Lui. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class InterfaceController: WKInterfaceController {
    
    let session: WCSession? = WCSession.isSupported() ? WCSession.default : nil
    
    @IBOutlet var hintLabel: WKInterfaceLabel!
    @IBOutlet var avatarImage: WKInterfaceImage!
    @IBOutlet var mainButton: WKInterfaceButton!
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        self.session?.delegate = self;
        self.session?.activate()
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    @IBAction func mainButtonBeTapped() {
        if let session = self.session {
            if session.isReachable {
                session.sendMessage(["action": "toggle"], replyHandler: nil, errorHandler: { error in
                    print(error)
                });
            }
        }
    }
    
}

extension InterfaceController: WCSessionDelegate {
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            if message["action"] as? String == "init" {
                self.hintLabel.setHidden(true)
                self.avatarImage.setHidden(false)
                self.mainButton.setHidden(false)
            }
            if message["action"] as? String == "play" {
                self.mainButton.setBackgroundImageNamed(message["status"] as? String == "playing" ? "pause" : "play")
                if let data = message["artwork"] as? Data,
                    let image = UIImage(data: data) {
                    self.avatarImage.setImage(image)
                }
            }
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let receiedError = error {
            print(receiedError)
        }
    }
}
