---
date: 2022-03-23T14:19:29Z
description: ""
draft: true
featured_image: ""
tags: []
title: "Object Equality"
toc: true
type: "post"
---

## Introduction

One of the first code smells we encounter when working with object-oriented languages where everything is an *object*, or everything subclasses an `Object` base class, is how OOP typically handles equality of objects.

For value types such as integers and floating point numbers, it's not controversial that we should be able to compare them and decide if they're equal or not. Integers can be compared by bits, and data structures can be compared by descending into the structure and comparing elements.

For types passed by reference, such as classes in Java, C#, Swift, Objective-C and so on, it's extremely complicated. Are two objects equal if they are in fact two references to the same object? Are two objects equal if each field is equal? What about if the objects share a common base class but are not exactly the same class themselves?

## Deep dive into C#

Microsoft have documented [how to define value equality for a class or struct](https://docs.microsoft.com/en-us/dotnet/csharp/programming-guide/statements-expressions-operators/how-to-define-value-equality-for-a-type). It's a bit of a wild ride.

This is the example they provide:

```csharp
class TwoDPoint : IEquatable<TwoDPoint>
{
    public int X { get; private set; }
    public int Y { get; private set; }

    public TwoDPoint(int x, int y)
    {
        // Removed for brevity
    }

    public override bool Equals(object obj) => this.Equals(obj as TwoDPoint);

    public bool Equals(TwoDPoint p)
    {
        if (p is null)
        {
            return false;
        }

        // Optimization for a common success case.
        if (Object.ReferenceEquals(this, p))
        {
            return true;
        }

        // If run-time types are not exactly the same, return false.
        if (this.GetType() != p.GetType())
        {
            return false;
        }

        // Return true if the fields match.
        // Note that the base class is not invoked because it is
        // System.Object, which defines Equals as reference equality.
        return (X == p.X) && (Y == p.Y);
    }

    public override int GetHashCode() => (X, Y).GetHashCode();

    public static bool operator ==(TwoDPoint lhs, TwoDPoint rhs)
    {
        if (lhs is null)
        {
            if (rhs is null)
            {
                return true;
            }

            // Only the left side is null.
            return false;
        }
        // Equals handles case of null on right side.
        return lhs.Equals(rhs);
    }

    public static bool operator !=(TwoDPoint lhs, TwoDPoint rhs) => !(lhs == rhs);
}
```

This class is a container for 8 bytes. We're going to do a *lot* of work to compare these 8 bytes against another 8 bytes. Let's dig in.

### `System.Object.Equals` override

```csharp
public override bool Equals(object obj) => this.Equals(obj as TwoDPoint);
```

To override `System.Object.Equals`, it appears to be best practice to do a run-time cast of `obj` to our class type, which will result in either a reference to our class, or reference to a subclass, or a null pointer, and pass that into a different, more specific, `Equals` method.

As opposed to the call being clear and unambiguous, we rely on language-lawyer knowledge to know which `Equals` method we're calling into. It's not recursing into the same method again, it's calling a different `Equals` method.

To paraphrase [Dr. Venkat Subramaniam](https://twitter.com/venkat_s):

Strive to write code which has obviously no problems, rather than code which has no obvious problems.

### `IEquatable<T>.Equals` implementation

Acknowledging that `System.Object.Equals` is terrible, Microsoft provided *another* equality mechanism: The interface `IEquatable<T>`. This improves on the previous approach by allowing the programmer to constrain the types of object that we can compare equality to. Sounds good, right?

```csharp
public bool Equals(TwoDPoint p)
```

We're off to a good start, the function signature has the class we're interested in.

```csharp
if (p is null)
{
    return false;
}
```

Each implementation has to check that the object passed in is not null. That's not great.

```csharp
// Optimization for a common success case.
if (Object.ReferenceEquals(this, p))
{
    return true;
}
```

Not strictly required, but each implementation *should* check that the two objects aren't in fact the same object.

```csharp
// If run-time types are not exactly the same, return false.
if (this.GetType() != p.GetType())
{
    return false;
}
```

Even though we thought we were talking about the same types of object, we need to check that neither have been subclassed.

```csharp
// Return true if the fields match.
// Note that the base class is not invoked because it is
// System.Object, which defines Equals as reference equality.
return (X == p.X) && (Y == p.Y);
```

Finally, after a dozen lines of boilerplate, we reach the actual comparison. The programmer has to check the individual fields and not make any copy and paste errors. If new fields are added, this code *must* be updated. That's not ideal, but fairly standard.

There is another lurking footgun, where we must be absolutely sure not to call into a base class, or risk infinite recursion, or inadvertently performing reference equality.

### `System.Object.GetHashCode` override

```csharp
public override int GetHashCode() => (X, Y).GetHashCode();
```

There's a rule that if two objects are *equal*, they must also have the same hash code. This is required for correct operation of dictionaries and other collections that use hash codes to optimise lookup. Because we override `Equals`, we must also override `GetHashCode`.

It's been a while since I used C#. I wonder does the compiler enforce this requirement?

Again, we access the `X` and `Y` fields here, so if any more fields are added, this code should be updated. I say *should* rather than *must*, as I understand it's sometimes OK for a hash code to not always use every field. I'm not an expert in hashing. I would probably use all fields just to be safe.

### `==` operator

Microsoft also advises that we implement yet another equality mechanism, the `==` and `!=` operators.

```csharp
public static bool operator ==(TwoDPoint lhs, TwoDPoint rhs)
{
    if (lhs is null)
    {
        if (rhs is null)
        {
            return true;
        }

        // Only the left side is null.
        return false;
    }
    // Equals handles case of null on right side.
    return lhs.Equals(rhs);
}
```

We have to write a few lines of easy-to-get-wrong boilerplate, then we call into one of the previous `Equals` methods to do the tedious work of doing the null checks, the subclassing checks, and finally, comparing the two integers.

What a lot of work, to compare such a small number of bytes.

### `!=` operator

And finally, the language is not clever enough to implement `!=` for us when we implement `==`, so it is added manually:

```csharp
public static bool operator !=(TwoDPoint lhs, TwoDPoint rhs) => !(lhs == rhs);
```

### Records

Microsoft added a new type in C# 9, called a [Record](https://docs.microsoft.com/en-us/dotnet/csharp/language-reference/builtin-types/record), which automatically implements equality for you.

As is suggested by their name, Records are for storing data rather than for communicating with other objects.
