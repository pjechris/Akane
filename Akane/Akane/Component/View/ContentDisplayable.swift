import Foundation

public protocol ContentReferencer {
    associatedtype Content

    var content: Content { get }

    init(content: Content)
}

public typealias DisplayableContent = ContentReferencer

extension ComponentDisplayable where Self : ContentReferencer {
    public func _tryBindings(_ observer: ViewObserver, viewModel: Any) {
        guard let viewModel = viewModel as? Parameters else {
            return
        }

        self.bindings(observer, params: viewModel)
    }
}

