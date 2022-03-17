---
title: "What is Programming?"
date: 2022-03-17T16:22:11Z
draft: true
---
# Introduction

This page borrows heavily from [Mike Acton](https://twitter.com/mike_acton).

# Transformation of data

Writing code is a means to solving a problem, and primarily the problem is that some data (input) needs to be transformed into something else (output).

Examples of inputs:

- Button taps
- Incoming HTTP responses
- Events coming from the OS
- Events coming from 3rd party SDKs

Examples of outputs:

- The view hierarchy
- Audio
- HTTP requests
- Requests sent to 3rd party SDKs

Frequently the output is not only dependent on any particular input, but on some stored state that is maintained as the app runs. Examples of stores:

- In-memory representation of the app state
- Database or some other persistent store
- Caches (low persistence store)

# Programming

Your job as a programmer is:

- To transform the data, primarily by writing code to do it
- To prevent a build-up of complexity that will slow future work or frustrate your colleagues
- To develop a sense of taste in order to do the above things better

Your job as a programmer is not:

- To build a perfect architecture of code – the data is the important part
- To write lots of code – every new line of code is a liability
- To solve problems you don’t have
