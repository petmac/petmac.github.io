---
title: "Object-oriented Programming (OOP)"
date: 2022-03-17T16:58:12Z
---

# What is OOP?

First, read [Wikipedia](https://en.wikipedia.org/wiki/Object-oriented_programming).

# Characteristics of OOP

## Division of the problem into Objects which implement Classes

The programmer is able to model the problem space in terms of objects that talk to each other via messages (method calls.)

I believe this to be a poor approach to most data transformation problems.

### Accidental complexity

By writing this “architecture” code that does not directly address the data transformation problems at hand, we have burdened ourselves with accidental complexity and latent problems that will at some point prevent us from solving the actual problems we have.

### Many sources of truth

Breaking an app up into smaller communicating objects by definition scatters the state of the application across its codebase. It becomes hard to observe and reason about the state of the application.

According to accepted good practice an object should have a limited view of the world and little internal state (to limit the problem space for each object), which then leads to the following slippery slope:

1. Object has limited subset of world knowledge
2. Requirements change and object needs more knowledge to function
3. Object is given reference to another object that provides knowledge
4. Codebase becomes more entangled

Often a requirements change causes the programmer to decide between one or more quick fixes that introduce tech debt (e.g., give object A a reference to object B, or duplicate state and keep it in sync) or a difficult refactor of the object graph.

### Object management

Once the code is split into objects, the program needs to create and maintain the collection of objects, and the references in-between. Whole frameworks (Dependency Injection) have been created to try and remove the burden of object creation from the programmer.

The dynamically allocated nature of object memory also gives rise to its own problems, such as strong reference cycles in languages which use reference counting to automatically free memory of unused objects.

## Inheritance

Extending/overriding/reusing a class behaviour via subclassing.

When a class is subclassed, the exact behaviour of the code involved stops being clear. Behaviour is divided between the base class and any number of potential subclasses.

From a code comprehension point of view, the programmer has to keep multiple classes in mind, and multiple files open in their editor, to fully grasp the big picture of how the program works.

Overriding behaviour generally makes code difficult to follow, difficult to reason about, and leads to code smells such as empty overridden functions.

For these reasons (and probably others), inheritance is nowadays generally frowned upon as a mechanism for code reuse.

# Non-characteristics of OOP

These are characteristics which are claimed as those of OOP, which are in fact available to programmers independently of OOP.

## Information hiding

The ability to prevent access to functions or data via visibility specifiers like public, internal, private, etc. Most languages have mechanisms for making things private to a module or file, so OOP does not grant this ability.

## Encapsulation

The bundling of data with the functions that work with that data. Encapsulation is provided outside of OOP by way of modules.

Inheritance (arguably OOP’s defining feature) works against encapsulation. [Reference](https://en.wikipedia.org/wiki/Encapsulation_(computer_programming)#Encapsulation_and_inheritance)

In many cases, problems are solved when we take data from one place, do something with it, and pass it to another. In that case, what is the point in making the data inaccessible, or accessible only via getters and so on?

# How did OOP become the dominant paradigm?

My experience of OOP was that it came to be popular first through Java, then other languages like C++ and C#.

Java quickly gained popularity as it had a bunch of benefits, and attempted to tackle some big problems which existed in languages like C.

* “Write once, run anywhere” via the JVM
* Automatic memory management
* Available on servers, desktops, at work, home and in schools/universities
* Relatively simple to teach beginners
* Large standard library, which could do Internet stuff
* Cost-effective (effectively free) to try

People learned Java in schools and universities, and Java was OOP. By virtue of being the only way to code in Java, OOP effectively Trojan Horse’d its way to being the only way people practiced how to program, and the only way they taught others to program.

In addition to that, OOP was heavily marketed as an effective way to write programs:

1. Break down complex problems into small components
2. ...
3. Profit!

# What was so bad about Java and “pure” OOP?

Java had (past tense, as my Java experience is now outdated) a few very specific potentially harmful attributes.

Java was not a multi-paradigm language. It did not allow the programmer to write functions outside of classes. Even static functions which had no dependencies had to be put in a class. Programmers forgot that functions can be put at module scope, and started putting everything in classes, even when that adds complexity. C# continued this limitation.

There were no “data structure” types other than classes. This meant that data structures were generally mutable, and passed by reference. Programmers shared references to mutable state all over the place. We now all agree that shared mutable state is generally difficult to reason about, and that leads to bugs.

Shared mutable state is also awful for concurrency, but that’s a topic for another day.

# The never-ending plateau of learning OOP

Once OOP was established, there were a plethora of books written on the “right way” to architect OOP programs.

From Design Patterns to Effective C++, there were a lot of rules to help you solve problems by way of increased mastery and adoption of OOP, as well as avoiding shooting yourself in the foot by learning all the language pitfalls.

> Should it be considered a “red flag” that a paradigm is not able to be effectively used without a large number of rules and guidelines?

I was enjoying learning all the rules and systems, and I felt like I was making huge strides in competency as a programmer.

I didn’t know at the time, but it was like a cult where the only way to successfully use OOP was to pay to level up in OOP.

Clean architecture was always just around the corner, but after trying for approximately 15 years I never actually got there.

I’m not the only one who came to this conclusion: Casey Muratori recorded [an excellent rant on the topic](https://www.youtube.com/watch?v=ZM1ZDaaEyMY).

# Where is OOP headed?

OOP’s defining feature (inheritance) is generally regarded to be a poor form of code reuse, and is to be avoided.

Most languages that support OOP also have non-OOP features like closures, free functions, value types, and functional-style map/filter/flatMap, that sort of thing.

Even UI toolkits, traditionally the most prominent application of OOP, are leaning away from hierarchies of objects and towards declarative, functional approaches:

* React
* Elm
* SwiftUI
* Jetpack Compose

My belief is that OOP code should be considered legacy, and programmers should reach for functions and structs before they resort to writing a class.

That’s not to say classes are useless. Being a reference type, classes are good for shared mutable state. If you need to write a Store-type data structure which will be used to share data between multiple places, use a class.
