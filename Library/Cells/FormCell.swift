import UIKit

public class FormCell<Model>: UITableViewCell, Bindable {

    public var shouldHighlight = false

    var update: ((inout Model) -> Void) -> Void = { _ in }
    var didSelect = {}

    var bindings: [(Model) -> Void] = []

    public init() {
        super.init(style: .default, reuseIdentifier: nil)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func render(_ model: Model) {
        bindings.forEach { $0(model) }
    }
}
