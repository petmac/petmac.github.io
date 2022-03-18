---
title: "Strong and weak object references"
date: 2022-03-17T23:46:18Z
---

# Introduction

An object maintains a reference to another object so it can call a method or access a property.

In languages like Swift, Objective-C, and C++, it’s required that we don’t create cycles of strong references, or we get memory leaks.

Bugs aside, creating cycles also suggests that the design is somewhat convoluted. We know that architecting a perfect arrangement of objects is not a goal, but we are often drawn into this conundrum by the use of OOP.

**Stop using OOP, stop solving OOP problems.**

# Clarity of purpose

We tend to find that references to objects fall into 3 categories of purpose:

* I’m telling you to do something (e.g., calling a method)
* I’m asking you for something (e.g., accessing a property)
* I’m telling you something happened (e.g., notifying an observer)

Is there an odd one out?

In the first two categories, if the objects being referenced aren’t there, the code cannot work. In other words, if I depend on you to get my work done, and I can’t communicate with you, then I cannot do my work.

The latter category is different though, in that the code *can still succeed*, even when it is not observed.

> If a tree falls in a forest and no one is around to hear it, does it make a sound?

Given that maintaining a reference to an observer is essentially *optional*, we should strive to make all references in first two categories **strong**, and references that fall into the latter category **weak**.

# Summary

References to objects that *do stuff* should be **strong**.

References to objects that *observe stuff* should be **weak**.
