import UIKit

public class FormCell<Model>: UITableViewCell, _Bindable {

    public var shouldHighlight = false
    public var didSelect = {}

    var update: ((inout Model) -> Void) -> Void = { _ in }

    /// This should really be private, see https://github.com/zoul/typed-forms/issues/1.
    public var bindings: [(Model) -> Void] = []

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
