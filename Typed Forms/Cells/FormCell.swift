import UIKit

class FormCell<Model>: UITableViewCell {

    var update: ((inout Model) -> Void) -> Void = { _ in }

    var visibilityKeyPath: KeyPath<Model, Bool>?
    var highlightingKeyPath: KeyPath<Model, Bool>?

    var shouldHighlight = false
    var didSelect = {}

    init(_ initializer: (FormCell<Model>) -> Void = { _ in }) {
        super.init(style: .default, reuseIdentifier: nil)
        initializer(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func render(_ model: Model) {
        if let visibilityKeyPath = visibilityKeyPath {
            isHidden = !model[keyPath: visibilityKeyPath]
        }
        if let highlightingKeyPath = highlightingKeyPath {
            shouldHighlight = model[keyPath: highlightingKeyPath]
        }
    }
}
