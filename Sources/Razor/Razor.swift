public struct RazorWrapper<Base> {
    public let base: Base
    public init(_ base: Base) {
        self.base = base
    }
}

public protocol RazorCompatible: AnyObject {}

public protocol RazorCompatibleValue {}

extension RazorCompatible {
    public var rz: RazorWrapper<Self> {
        get { return RazorWrapper(self) }
        set { }
    }
    
    public static var rz: RazorWrapper<Self>.Type {
        get { RazorWrapper<Self>.self }
        set { }
    }
}

extension RazorCompatibleValue {
    public var rz: RazorWrapper<Self> {
        get { return RazorWrapper(self) }
        set { }
    }
    
    public static var rz: RazorWrapper<Self>.Type {
        get { RazorWrapper<Self>.self }
        set { }
    }
}
