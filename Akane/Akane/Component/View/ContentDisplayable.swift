import Foundation

public protocol ContentReferencer {
    associatedtype Content

    var content: Content { get }

    init(content: Content)
}

