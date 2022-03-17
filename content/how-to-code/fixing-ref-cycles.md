---
title: "Fixing Ref Cycles"
date: 2022-03-17T23:47:10Z
draft: true
---

The setup
Based on a true story

We have a strong reference cycle between WebView and MessageHandler, meaning there’s a memory leak.

As if that’s not bad enough, WebView has multiple roles (views webs but also provides configs), which is an egregious violation of the S principle.


class WebView {
  private let messageHandler = MessageHandler()
  var config = Config()
  
  init() {
    // Shares mutable state, but not only that...
    // Creates a strong reference cycle
    messageHandler.webView = self
  }
}

class MessageHandler {
  var webView: WebView? // Strong reference
  
  func doStuff() {
    guard let config = webView?.config else {
      // Should never happen, is almost certainly untested
      return
    }
    
    // Do something with config
  }
}
weak to the rescue?
One might be tempted to change the reference to the WebView to be weak. This would work around the memory leak problem, but it still means that:

doStuff needs to check config and do something unusual if it's nil

There’s still a cycle of access between the two classes

WebView is still providing configs

Store that shared mutable state
What I would do instead is introduce a ConfigStore, which both WebView and MessageHandler share. This is :skull: shared mutable state :skull:, which is exactly what classes are for!


class ConfigStore {
  var config = Config()
}

class WebView {
  private let configStore: ConfigStore
  private let messageHandler: MessageHandler
  
  init() {
    configStore = ConfigStore()
    messageHandler = MessageHandler(configStore: configStore)
  }
}

class MessageHandler {
  private let configStore: ConfigStore
  
  init(configStore: ConfigStore) {
    self.configStore = configStore
  }
  
  func doStuff() {
    let config = configStore.config // Config cannot be nil
    // Do something with config
  }
}
Conclusion
tl;dr = :sunglasses: :beers: :smile: 

Shared mutable state is isolated in the Store class

WebView no longer has multiple roles (does not provide configs)

More stuff can be made private

Things which previously “should never” be nil now cannot be nil

No reference cycles
