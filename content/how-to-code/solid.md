---
title: "Solid"
date: 2022-03-17T23:45:28Z
draft: true
---

Introduction
In order to help guide programmers to effectively apply OOP, the industry settled on what we call the SOLID principles.

I believe that while the SOLID principles were marketed to encourage “good” use of OOP, they effectively discourage the use of OOP!

Single responsibility principle
Class has one job to do. Each change in requirements can be done by changing just one class.

If a class has more than one public function, then it does more than one thing. Therefore, should each class only have one public function in it? And if so, what is the benefit in wrapping the function in a container class?

I say that OOP, by the bundling of functions into classes, effectively violates the single responsibility principle out of the gate.

The most effective way to make something have a single responsibility is to decouple it from everything else. In other words, don’t write classes. Write free functions instead.

I’m pretty sure I can count on one hand the number of times a nontrivial change in requirements has only necessitated a change in one class.

Open/closed principle
Class is happy (open) to be used by others. Class is not happy (closed) to be changed by others.

Swift can generally do better than extension via subclassing by using its extension mechanism.

Liskov substitution principle
Class can be replaced by any of its children. Children classes inherit parent's behaviours.

In practice, we subclass in order to change a base class behaviour rather than inherit it. And in that way, we’re violating both this principle (a base class and subclass are interchangeable) and the open/closed principle.

When a class is subclassed, the exact behaviour of the code involved stops being clear. It is split between the base class and any number of potential subclasses.

From a code comprehension point of view, the reader has to keep multiple classes in mind to fully grasp the big picture of how the program works.

Inheritance is nowadays generally frowned upon as a mechanism for code reuse, making this guideline feel somewhat based on a false premise.

Interface segregation principle
When classes promise each other something, they should separate these promises (interfaces) into many small promises, so it's easier to understand.

When this principle was written, the intent was for Java classes to inherit from interfaces (protocols in Swift or Objective-C.) This principle is about  reducing the size of those interfaces down to as small as possible.

So, for example, rather than having a complete WebView interface with all functionality that a real web view implements, split that interface into many small interfaces.

So far, so good, but we can do better outside of OOP.

The smallest interface is probably a closure. Many functions support the use of completion handlers to be called back when an operation completes. Sometimes you can supply a closure to provide information.

My view is that if you have a protocol with one function in it, then it should have been a closure.

Dependency inversion principle 
When classes talk to each other in a very specific way, they both depend on each other to never change. Instead classes should use promises (interfaces, parents), so classes can change as long as they keep the promise.

This principle is a kind of preface to the Interface segregation principle. I suppose they didn’t want to call them the SOLDI principles.

Swift can do better than interface subclasses. With protocols, you can extend existing classes, structs, and enums and declare conformance to an interface.
