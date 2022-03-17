---
title: "Object Refs"
date: 2022-03-17T23:46:18Z
draft: true
---

Introduction
An object maintains a reference to another object so it can call a method or access a property.

In Swift and Objective-C, it’s required that we don’t create cycles of strong references, or we get a memory leak.

Creating cycles also suggests that the design is somewhat confused or inelegant.

Architecting a perfect arrangement of objects is not a goal, but we are often drawn into this conundrum by the use of OOP.

Stop using OOP, stop solving OOP problems.

Types of references
We tend to find that references to objects fall into 3 categories of purpose:

I’m telling you to do something (e.g., call a method)

I’m asking you for something (e.g., access a property)

I’m telling you something happened (e.g., notify an observer)

Is there an odd one out?

In the first two categories, if the objects being referenced aren’t there, the code cannot work.

In other words, if I depend on you to get my work done, and I can’t communicate with you, I cannot do my work.

If a tree falls in a forest 

I would say the latter case is different then, in that the code can succeed, even when it is not observed.

For this reason, we should strive to make the first two categories of references strong, and the latter weak.

Conclusion
References to objects that do stuff should be strong.

References to objects that observe stuff should be weak.
