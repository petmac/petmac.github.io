---
title: "Strong and Weak Object References"
date: 2022-03-17T23:46:18Z
---

# Introduction

An object maintains a reference/pointer to another object so it can call a method or access a property. References are called _strong_ if the relationship between the objects is one of ownership, and _weak_ or _unowned_ if it the object containing the reference does not own the object being referred to.

In languages like Swift, Objective-C, and C++, it’s required that we don’t create _cycles_ of strong references, or we get memory leaks.

A cycle is when an object "A" points directly or indirectly to another object "B", and object "B" points directly or indirectly back to object "A".

Potential for bugs aside, creating cycles also suggests that the design is somewhat inelegant. We know that architecting a perfect arrangement of objects is not a goal, but we are often drawn into this conundrum by the use of OOP.

**Stop using OOP, stop solving OOP-specific problems.**

Let's find a way to help decide if a reference should be strong or weak.

# Types of reference

We tend to find that references to objects fall into 3 categories of purpose:

- "A" tells "B" to do something (e.g., "A" calls a method on "B")
- "A" asks "B" for information (e.g., "A" accesses a property of "B")
- "A" tells "B" that something happened (e.g., "B" is an observer of "A")

Is there an odd one out?

In the first two categories, if object "B" isn't there, the code cannot function. In other words, if "A" depends on "B" to get its work done, and "A" can’t communicate with "B", then "A" cannot do its work.

The latter category is different though, in that "A"'s work _can still succeed_, even when it is not observed by "B".

> If a tree falls in a forest and no one is around to hear it, does it make a sound?

Given that maintaining a reference to an observer is essentially _optional_, we should strive to make all references in first two categories **strong**, and references that fall into the latter category **weak**.

That way, in the common case where there is cyclic data flow from a controller object to a worker and back again, there isn't a strong reference cycle preventing the objects from being properly freed.

# Summary

References to objects that _do stuff_ should be **strong**.

References to objects that _observe stuff_ should be **weak**.
