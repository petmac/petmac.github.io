---
slug: removing-ref-cycles
title: Removing Reference Cycles
authors: [petmac]
tags: []
---

## Introduction

If you are gainfully employed as a programmer, you have probably been forced to accept object-oriented programming into your life. When working with a language like Swift or C++ which doesn't have garbage collection, you will end up in the debugger, trying to locate a strong reference cycle which has resulted in a memory leak.

<!-- truncate -->

Or, you're reviewing a Pull Request and notice that there is a cyclic relationship between some classes.

It's good to have some coping strategies for such events. Let's work through an example.

## The setup

> Based on a true story

Let's look at the code:

```swift
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
```

We have a strong reference cycle between the `WebView` and `MessageHandler` classes. `WebView` is the main object in this module. It owns a `MessageHandler`, and the `MessageHandler` depends on the `WebView` to provide its configuration.

Due to the strong reference cycle, there’s going to be a memory leak when we try to release the `WebView`.

As if that’s not bad enough, `WebView` has multiple roles: it views webs but _also_ provides `Config`s, and thus is an egregious violation of the _single responsibility principle_.

## `weak` to the rescue?

One might be tempted to change the reference in `MessageHandler` to the `WebView` to be weak. This would work around the memory leak problem, but it means that:

- `doStuff()` needs to check `config` and do something unusual if it's nil
- There’s still a cycle of access between the two classes
- `WebView` is still providing `Config`s

## Store that shared mutable state

What I would do instead is move the `config` property to a new `ConfigStore` class, which both `WebView` and `MessageHandler` will share.

This is 💀 **shared mutable state** 💀, but that's OK, because sharing mutable state is _exactly_ what classes are for!

```swift
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
```

## Result

- Shared mutable state is isolated in the `Store` class
- `WebView` no longer has multiple roles (does not provide `Config`s)
- More stuff can be made `private`
- Things which previously “should never” be nil now _cannot_ be nil
- No reference cycles at all, not even weak ones
