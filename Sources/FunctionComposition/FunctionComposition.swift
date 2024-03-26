import Foundation

/// Identity function.
///
/// Returns the input without changing it.
///
/// - Parameter a: A value.
/// - Returns: The value received as input, with no modifications.
public func id<A>(_ a : A) -> A {
    return a
}

/// cast function.
///
/// Returns the input casting to the output type.
///
/// - Parameter a: Any value.
/// - Returns: The value received as input, conditionaly casted to type A.
public func cast<A>(_ a : Any) -> A? {
    return a as? A
}


/// Compose two functions to one that receives the parameter of the first and apply both provided function to
/// - Parameters:
///   - f: first function to apply
///   - g: function to apply to the resukt of the first function
/// - Returns:a function that apply the compositon
public func compose<A, B, C>(_ f: @escaping (A) -> B, _ g: @escaping (B) -> C) -> (A) -> C {
    return { a in g(f(a)) }
}

precedencegroup FunctionApplicationGroup {
    associativity: left
}

infix operator |> : FunctionApplicationGroup

/// Apply the rhs function to the lhs value
/// - Parameters:
///   - x: a value of any kind
///   - f: function for A to B
/// - Returns: the result of applying the function f to the value x
public func |> <A, B> (x: A, f: (A) -> B) -> B {
    return f(x)
}

public func |> <A, B> (x: A, f: (A) -> B?) -> B? {
    return f(x)
}

public func |> <A, B> (x: A, f: ((A) -> B)?) -> B? {
    return f?(x)
}

public func |> <A, B> (x: A, f: ((A) -> B?)?) -> B? {
    return f?(x)
}

public func |> <A, B> (x: A?, f: (A) -> B) -> B? {
    return x.map(f)
}

public func |> <A, B> (x: A?, f: (A) -> B?) -> B? {
    return x.flatMap(f)
}

public func |> <A, B> (x: A?, f: ((A) -> B)?) -> B? {
    guard let f = f else {
        return nil
    }
    return x.map(f)
}

public func |> <A, B> (x: A?, f: ((A) -> B?)?) -> B? {
    guard let f = f else {
        return nil
    }
    return x.flatMap(f)
}



precedencegroup FunctionCompositionGroup {
    associativity: left
    higherThan: FunctionApplicationGroup
}

infix operator >>>: FunctionCompositionGroup

/// Compose functions operator
/// - Parameters:
///   - f: first function to apply
///   - g: function to apply to the resukt of the first function
/// - Returns:a function that apply the compositon
public func >>><A, B, C>(_ f: @escaping (A) -> B, _ g: @escaping (B) -> C) -> (A) -> C {
    return compose(f, g)
}
