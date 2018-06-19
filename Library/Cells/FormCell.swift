import UIKit

public class FormCell<Model>: UITableViewCell {

    public var shouldHighlight = false

    var update: ((inout Model) -> Void) -> Void = { _ in }
    var didSelect = {}

    private var bindings: [(Model) -> Void] = []

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

public extension FormCell {

    public func bind<T>(
        _ viewPath: WritableKeyPath<FormCell, T>,
        to modelPath: KeyPath<Model, T>) {
        bindings.append { [weak self] model in
            self?[keyPath: viewPath] = model[keyPath: modelPath]
        }
    }

    public func bind<T, U>(
        _ viewPath: WritableKeyPath<FormCell, T>,
        to modelPath: KeyPath<Model, U>,
        through map: @escaping (U) -> T) {
        bindings.append { [weak self] model in
            self?[keyPath: viewPath] = map(model[keyPath: modelPath])
        }
    }
}
