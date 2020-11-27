//
//  QMProtected.swift
//  QMRouter
//
//  Created by mumu on 2020/11/19.
//  Copyright © 2020 mumu. All rights reserved.
//

import Foundation

/// 扩展 locking 协议
extension NSLocking {
    
    /// 用 lock 包裹带返回值的执行任务
    /// - Parameter closure: 任务
    /// - Returns: 返回值
    func around<T>(_ closure: () -> T) -> T {
        lock(); defer { unlock() }
        return closure()
    }

    
    /// 用 lock 包裹执行任务
    /// - Parameter closure: 任务
    func around(_ closure: () -> Void) {
        lock(); defer { unlock() }
        closure()
    }
}

/// 线程安全的属性包装
@propertyWrapper
@dynamicMemberLookup
public final class QMProtected<T> {
    private let lock = NSLock()

    private var value: T

    public init(_ value: T) {
        self.value = value
    }

    /// 线程安全的读写
    public var wrappedValue: T {
        get { lock.around { value } }
        set { lock.around { value = newValue } }
    }

    public var projectedValue: QMProtected<T> { self }

    public init(wrappedValue: T) {
        value = wrappedValue
    }

    /// 同步读
    public func read<U>(_ closure: (T) -> U) -> U {
        lock.around { closure(self.value) }
    }

    /// 同步执行
    public func excute(_ closure: (inout T) -> Void)  {
        lock.around { closure(&self.value) }
    }
    
    /// 同步写
    @discardableResult
    public func write<U>(_ closure: (inout T) -> U) -> U {
        lock.around { closure(&self.value) }
    }
    
    /// 下标
    public subscript<Property>(dynamicMember keyPath: WritableKeyPath<T, Property>) -> Property {
        get { lock.around { value[keyPath: keyPath] } }
        set { lock.around { value[keyPath: keyPath] = newValue } }
    }
}

/// 集合的扩展
extension QMProtected where T: RangeReplaceableCollection {
    /// 添加元素
    public func append(_ newElement: T.Element) {
        write { (ward: inout T) in
            ward.append(newElement)
        }
    }

    /// 添加集合
    public func append<S: Sequence>(contentsOf newElements: S) where S.Element == T.Element {
        write { (ward: inout T) in
            ward.append(contentsOf: newElements)
        }
    }

    /// 添加集合
    public func append<C: Collection>(contentsOf newElements: C) where C.Element == T.Element {
        write { (ward: inout T) in
            ward.append(contentsOf: newElements)
        }
    }
}

/// Data 的扩展
extension QMProtected where T == Data? {

    public func append(_ data: Data) {
        write { (ward: inout T) in
            ward?.append(data)
        }
    }
}

