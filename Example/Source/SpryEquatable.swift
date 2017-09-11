//
//  SpryEquatable.swift
//  SpryExample
//
//  Created by Brian Radebaugh on 4/2/16.
//  Copyright © 2016 Brian Radebaugh. All rights reserved.
//

import Foundation

/**
 Used to compare any two arguments. Uses Equatable's `==(lhs:rhs:)` operator for comparision.

 - Important: Never manually conform to `SpryEquatable`.
 - Note: If a compiler error says you do NOT conform to `SpryEquatable` then conform to `Equatable`. This will remove the error.
 */
public protocol SpryEquatable {
    func isEqual(to actual: SpryEquatable?) -> Bool
}

public extension SpryEquatable {
    func isEqual(to actual: SpryEquatable?) -> Bool {
        Constant.FatalError.doesNotConformToEquatable(self)
    }
}

// MARK: - SpryEquatable where Self: Equatable

public extension SpryEquatable where Self: Equatable {
    func isEqual(to actual: SpryEquatable?) -> Bool {
        guard let castedActual = actual as? Self else {
            Constant.FatalError.wrongTypesBeingCompared(actual, self)
        }

        return self == castedActual
    }
}

// MARK: - SpryEquatable where Self: AnyObject

public extension SpryEquatable where Self: AnyObject {
    func isEqual(to actual: SpryEquatable?) -> Bool {
        guard let castedActual = actual as? Self else {
            Constant.FatalError.wrongTypesBeingCompared(actual, self)
        }

        return self === castedActual
    }
}

// MARK: - SpryEquatable where Self: AnyObject & Equatable

public extension SpryEquatable where Self: AnyObject & Equatable {
    func isEqual(to actual: SpryEquatable?) -> Bool {
        guard let castedActual = actual as? Self else {
            Constant.FatalError.wrongTypesBeingCompared(actual, self)
        }

        return self === castedActual
    }
}

// MARK: - SpryEquatable for Arrays

public extension Array {
    func isEqual(to actual: SpryEquatable?) -> Bool {
        guard let castedActual = actual as? Array<Element> else {
            Constant.FatalError.wrongTypesBeingCompared(actual, self)
        }

        if self.count != castedActual.count {
            return false
        }

        return zip(self, castedActual).reduce(true) { result, zippedElements in
            if !result {
                return false
            }

            if let selfElement = zippedElements.0 as? SpryEquatable, let actualElement = zippedElements.1 as? SpryEquatable {
                return selfElement.isEqual(to: actualElement)
            }

            Constant.FatalError.doesNotConformToSpryEquatable(zippedElements.0)
        }
    }
}

// MARK: - SpryEquatable for Dictionaries

public extension Dictionary {
    func isEqual(to actual: SpryEquatable?) -> Bool {
        guard let castedActual = actual as? Dictionary<Key, Value> else {
            Constant.FatalError.wrongTypesBeingCompared(actual, self)
        }

        if self.count != castedActual.count {
            return false
        }

        return zip(self, castedActual).reduce(true) { result, zippedElements in
            if !result {
                return false
            }

            guard let selfKey = zippedElements.0.key as? SpryEquatable, let actualKey = zippedElements.1.key as? SpryEquatable else {
                Constant.FatalError.doesNotConformToSpryEquatable(zippedElements.0.key)
            }

            guard let selfValue = zippedElements.0.value as? SpryEquatable, let actualValue = zippedElements.1.value as? SpryEquatable else {
                Constant.FatalError.doesNotConformToSpryEquatable(zippedElements.0.value)
            }

            return selfKey.isEqual(to: actualKey) && selfValue.isEqual(to: actualValue)
        }
    }
}

// MARK: - OptionalType

/**
 Used to specify an `Optional` constraint. This is needed until Swift supports extensions where Self can be constrained to a type.
 */
public protocol OptionalType {}
extension Optional: OptionalType {}

// MARK: - SpryEquatable where Self: OptionalType

public extension SpryEquatable where Self: OptionalType {
    public func isEqual(to actual: SpryEquatable?) -> Bool {
        let selfMirror = Mirror(reflecting: self)

        guard selfMirror.displayStyle == .optional else {
            Constant.FatalError.shouldNotConformToOptionalType(self)
        }

        guard type(of: self) == type(of: actual) else {
            Constant.FatalError.wrongTypesBeingCompared(actual, self)
        }

        let selfsWrappedValue = selfMirror.children.first?.value

        if isNil(selfsWrappedValue) && isNil(actual) {
            return true
        }
        guard let selfsWrappedValueAsNonOptional = selfsWrappedValue, let actual = actual else {
            return false
        }

        guard let selfsContainedValueAsSE = selfsWrappedValueAsNonOptional as? SpryEquatable else {
            Constant.FatalError.doesNotConformToSpryEquatable(selfsWrappedValue!)
        }

        return selfsContainedValueAsSE.isEqual(to: actual)
    }
}

// MARK: - Default Conformers
extension Optional: SpryEquatable {}
extension String: SpryEquatable {}
extension Int: SpryEquatable {}
extension Double: SpryEquatable {}
extension Bool: SpryEquatable {}
extension Array: SpryEquatable {}
extension Dictionary: SpryEquatable {}
extension NSObject: SpryEquatable {}
