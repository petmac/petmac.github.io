---
date: 2022-04-01T15:26:29Z
description: ""
draft: false
featured_image: ""
tags: []
title: "Object Equality"
toc: true
type: "post"
---

## Introduction

One of the first code smells we encounter when working with an object-oriented language where everything is an *object*, or everything subclasses a common base class, or there are no static methods, is how OOP typically handles equality of objects.

For value types such as integers and floating point numbers, it's not controversial that we should be able to compare them and decide if they're equal or not. Integers can be compared by bits, and data structures can be compared by descending into the structure and comparing elements.

For types passed by reference, such as classes in Java, C#, Swift, Objective-C and so on, it's extremely complicated. Sometimes we care about equality (two reference point to different objects, but those objects contain the same values) and sometimes we care about identity (two references point to the same object.)

## Properties of equatability

There are a few properties of equatability that we can consider to help us recognise whether a language has a good quality equality solution, or not.

### Equals expressions should be *commutative*

That is, "is A equal to B?" should always evaluate to the same boolean value as "is B equal to A?" How does that square with a typical OO solution to equality, where you have to compare values like the following snippet?

```swift
a.equals(b)
```

By giving the left-hand value in the comparison a special role -- i.e., the calculator of the result -- if we were to reverse the order of `a` and `b`, we could then be calling the equals method of a completely different type! In that case, there is no guarantee of commutativity.

For this reason, the equals function or operator *should not be an instance method*. The equality function should be a *static method* or even a *free function*.

### Values can only be equal if they are of the same type

For example, with basic types:

* Integers of the same width can be compared trivially
* Integers of different widths can be compared, if they can be promoted to a larger width
* Floating point numbers of the same width can be compared trivially
* Single-precision floating point numbers can be compared with double-precision numbers
* Integers and floating point numbers can be compared, if the integer can be promoted to a floating point number without loss of precision

For more complex types, such as data structures:

* Two data structures of the same type can be compared fairly trivially by comparing the contents
* Two data structures of unrelated types *can never* be equal
* Two data structures of related types can also *never* be equal, because one type will have data or some other attribute that is missing from the other

For this reason, a language should (at compile time) forbid comparisons of incompatible types.

### Null references

For languages which burden programmers with null references, they have a few properties when compared:

* Nulls are always equal
* A null is never equal to a non-null
* Two non-nulls may be equal in terms of reference equality or value equality

While these properties are fairly easy to check, requiring the programmer to do it manually results in lots of error-prone boilerplate that will likely be glossed over in code reviews.

Languages should not allow comparisons involving nulls, because the result is always known.

Additionally, languages should automatically generate equality code, in order to reduce boilerplate.

## Deep dive into C#

Microsoft has documented [how to define value equality for a class or struct](https://docs.microsoft.com/en-us/dotnet/csharp/programming-guide/statements-expressions-operators/how-to-define-value-equality-for-a-type). It's a bit of a wild ride.

I believe Microsoft has somewhat addressed the deficiencies of their initial approach to value equality, with [Record](https://docs.microsoft.com/en-us/dotnet/csharp/language-reference/builtin-types/record), but I haven't used C# since `Record` was introduced.

Long story short, it took Microsoft a long time to identify C# equality as a disaster, and when they did, they had to introduce a completely new type of type to fix it. Ouch!

Anyway, here is the example Microsoft provides for class equality:

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

To override `System.Object.Equals`, it appears to be best practice to do a run-time cast of `obj` to our class type, which will result in either a reference to our class, or reference to a subclass, or a null pointer, and then we pass that into a different, more specific, `Equals` method to do the work.

As opposed to the call being clear and unambiguous, we rely on language-lawyer knowledge to know which `Equals` method we're calling into. We're not recursing into the same method again, we're calling a *different* `Equals` method.

To paraphrase [Dr. Venkat Subramaniam](https://twitter.com/venkat_s):

Strive to write code which has *obviously no problems*, rather than code which has *no obvious problems.*

### `IEquatable<T>.Equals` implementation

Acknowledging that `System.Object.Equals` is terrible, Microsoft provided *another* equality mechanism: The interface `IEquatable<T>`. This improves on the previous approach by allowing the programmer to constrain the types of object that we can compare equality to. Sounds good, right?

```csharp
public bool Equals(TwoDPoint p)
```

We're off to a good start, the function signature has the class we're interested in.

Each implementation has to check that the object passed in is not null. That's not great:

```csharp
if (p is null)
{
    return false;
}
```

Not strictly required, but each implementation *should* check that the two objects aren't in fact the same object:

```csharp
// Optimization for a common success case.
if (Object.ReferenceEquals(this, p))
{
    return true;
}
```

Based on the method signature, we thought we were already talking about two objects of the same type, but that was a trick to keep us on our toes. We need to double-check that neither object has been subclassed:

```csharp
// If run-time types are not exactly the same, return false.
if (this.GetType() != p.GetType())
{
    return false;
}
```

Finally, after a dozen lines of boilerplate, we reach the actual comparison:

```csharp
// Return true if the fields match.
// Note that the base class is not invoked because it is
// System.Object, which defines Equals as reference equality.
return (X == p.X) && (Y == p.Y);
```

The programmer has to check the individual fields and not make any copy and paste errors. If new fields are added, this code *must* be updated. That's not ideal, but fairly standard when the compiler cannot generate the comparison code for us.

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

## Swift and `Equatable`

Swift has an elegant solution to equality. The [Equatable](https://developer.apple.com/documentation/swift/equatable) protocol contains the following declaration:

```swift
static func == (lhs: Self, rhs: Self) -> Bool
```

To make your type *equatable*, you declare that it conforms to the `Equatable` protocol:

```swift
struct TwoDPoint: Equatable {
    let x: Int
    let y: Int
}
```

The protocol has a default implementation of `!=` that just calls `==` and negates the result, so you don't need to provide an implementation of both functions.

For value types, the compiler ([since 2018](https://www.swiftbysundell.com/wwdc2018/synthesized-conditional-conformances-in-swift-42/)) automatically generates the actual `==` function for you too, so typically all you need to to is declare that your type is `Equatable` and you're done.

For classes, you have to write the `==` function yourself:

```swift
class TwoDPoint {
    let x: Int
    let y: Int

    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
}

extension TwoDPoint: Equatable {
    static func == (lhs: TwoDPoint, rhs: TwoDPoint) -> Bool {
        return
            lhs.x == rhs.x &&
            lhs.y == rhs.y
    }
}
```

It normally doesn't make sense to compare variables that are not *values*, and for values you should use a value type such as `struct` or `enum`, so if you find yourself hand-implementing `==` it's time to think about how you got there.

Note there are no null checks in `==` above. Swift separates the concerns of nullability and references. So by the time your class' `==` function is called, the null check has already been done.

## Conclusion

I hope I've demonstrated that a typical object-oriented approach to value comparisons quickly gives rise to a whole lot of unnecessary issues. Partly due to being object-oriented, but also due to being overly generic. For example, the C# solution requires that the programmer implement an equality comparison against *any other* type of object, including nulls, when the 99% *actual, concrete use case* is that we want to compare *non-null values of the same type*.

Swift absolutely nails the 99% use case:

* No boilerplate
* `Equatable` only applies to the specific type that's declared conformant
* Neither side of the `==` sign is special
* No need to check nulls
* Tedious code is automatically generated

What wasn't immediately obvious though as we got into the specifics of equality, is that equality is only one basic data transform, and our findings can be extrapolated to cover all kinds of data transforms.

A data transform is when you take more than one source of data, do some work with them, and output some result.

If you want to transform data, and if you're reading this then that is what your job is, then:

1. You should avoid an object-oriented approach, and
2. you should avoid an overly generic approach, as it will definitely make you solve problems you don't have.
