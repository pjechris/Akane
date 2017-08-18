import Foundation

// TODO: Add support for componentControllerClass()

public protocol ControllerDisplayable {
    func display()
}

public protocol Content {
    associatedtype ContentType

    var content: ContentType { get }

    init(content: ContentType)
}

public typealias ContentComponentDisplayable = Content & ComponentDisplayable
public typealias ContentDisplayable = Content & Displayable

extension ComponentDisplayable where Self : Content {
    public func _tryBindings(_ observer: ViewObserver, viewModel: Any) {
        guard let viewModel = viewModel as? ViewModelType else {
            return
        }

        self.bindings(observer, viewModel: viewModel)
    }
}
