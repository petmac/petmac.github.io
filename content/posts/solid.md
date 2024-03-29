---
date: 2022-03-17T23:45:28Z
description: ""
draft: false
featured_image: ""
tags: []
title: "The SOLID Principles"
toc: true
type: "post"
---

## Introduction

In order to guide programmers to effectively apply object-oriented design, the industry settled on what we call [the SOLID principles](https://en.wikipedia.org/wiki/SOLID).

I believe that while the SOLID principles were marketed to encourage “good” use of OOP, they just as effectively _discourage_ the use of OOP!

## The principles

### Single responsibility principle

> every module, class or function in a computer program should have responsibility over a single part of that program's functionality, and it should encapsulate that part.

If a class has more than one public function, then it does more than one thing. Therefore, and I know I'm reducing to absurdity here, should each class only have one public function in it? And if so, what is the benefit in wrapping the function in a container class?

I say that OOP, through the bundling of functions into classes, pushes the programmer to violate the single responsibility principle.

The most effective way to make something have a single responsibility is to decouple it from everything else. In other words, don’t write classes, write free functions instead.

### Open-closed principle

> an entity can allow its behaviour to be extended without modifying its source code.

This principle is about a class being closed for modification, but open for extension.

Traditionally this extension would be done through subclassing, which we generally accept as a bad idea nowadays.

If, rather than a class, you just have a function, then you can extend its behaviour by merely calling another function after the first one completes. If you have to _change_ the functionality, then you need to modify or replace the first function.

Even if staying within the realm of OOP, Swift can generally do way better than extension via subclassing, through use of its `extension` mechanism.

It's almost like this principle is from a fantasy realm where people don't want to read or modify existing source code. In reality you need to both read and modify existing source code _all the time_. Changing or extending functionality by layering more stuff on top by definition leads to layers of wrappers.

### Liskov substitution principle

> an object (such as a class) and a sub-object (such as a class that extends the first class) must be interchangeable without breaking the program.

In practice, we subclass in order to _change_ a base class behaviour rather than inherit it. And in that way, we’re violating both this principle (that a base class and subclass are interchangeable) _and_ the _open-closed principle_.

Inheritance is nowadays generally frowned upon as a mechanism for code reuse, making this guideline feel somewhat based on a false premise.

### Dependency inversion principle

> depend on abstractions (e.g., interfaces).

Apologies for putting the principles in the wrong order. It's important to cover this one first before talking about the _interface segregation principle_ though.

You can often classify a dependency into one of the following categories:

- `A` needs a `B` to do something
- `A` needs a `B` for some information
- `A` can notify a `B` that something happened (e.g., `B` is an _observer_ of `A`, or `B` waits for "completion" of `A`)

In each case, that dependency can be satisfied through use of a closure, block, or function pointer. There is no need to create an interface, protocol or abstract base class.

Even if you have to use OOP, Swift can do better than Java-esque interfaces. You can extend classes, structs, and even value types to declare conformance to an interface using protocols. Not only that, but you can extend _existing_ classes. That's exemplifying the _open-closed principle_!

### Interface segregation principle

> no code should be forced to depend on methods it does not use.

When this principle was written, the intent was for Java classes to inherit from interfaces (protocols in Swift or Objective-C.) This principle is about reducing the size of those interfaces down to as small as possible.

So, for example, rather than having a large `WebView` interface with all functionality that a real web view supports, split that interface into smaller, more specific, interfaces such as:

- Page loading
- Execution of JavaScript
- Handling of cookies

I'm 100% on board with this principle. It eases testing and refactoring, and it clarifies the semantics of each dependency.

Tip: If you have an interface with only one function in it -- and interface segregation will often result in that -- then the interface should be rewritten as a _closure_ instead. That way you may _choose_ to implement the dependency with OOP (and be sucked into more object lifecycle maintenance) but you aren't _forced_ to go that route.
