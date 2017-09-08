import Foundation

public protocol ContentAccessible {
    associatedtype Content

    var content: Content { get }

    init(content: Content)
}

public protocol Displayable : class {
    associatedtype Props

    func bindings(_ observer: ViewObserver, props: Props)
}
