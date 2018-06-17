//
//  IntentHandler.swift
//  siriKintai
//
//  Created by kkamakur on 2018/06/07.
//  Copyright © 2018年 KAMAKURAKAZUHIRO. All rights reserved.
//

import Intents

// As an example, this class is set up to handle Message intents.
// You will want to replace this or add other intents as appropriate.
// The intents you wish to handle must be declared in the extension's Info.plist.

// You can test your example integration by saying things to Siri like:
// "Send a message using <myApp>"
// "<myApp> John saying hello"
// "Search for messages in <myApp>"

class IntentHandler: INExtension, SendMailIntentHandling {
    
    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        
        return self
    }
    
    func confirm(intent: SendMailIntent, completion: @escaping (SendMailIntentResponse) -> Void) {
        // First gets called, yes or no? Do we confirm the action
    }
    
    func handle(intent: SendMailIntent, completion: @escaping (SendMailIntentResponse) -> Void) {
        // Actually handle the intent!
    }
}