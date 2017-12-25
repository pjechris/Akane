import Foundation
import Akane

class NavbarItemDisplayer : Displayable, ContentReferencer {
    let content: UINavigationItem

    required init(content: UINavigationItem) {
        self.content = content
    }

    func bindings(_ observer: ViewObserver, params title: String) {
        self.content.title = title
    }
}
