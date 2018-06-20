import Foundation

public protocol Bindable: AnyObject {

    associatedtype Model

    var bindings: [(Model) -> Void] { get set }
}

extension Bindable {

    public func bind<T>(
        _ viewPath: WritableKeyPath<Self, T>,
        to modelPath: KeyPath<Model, T>) {
        bindings.append { [weak self] model in
            self?[keyPath: viewPath] = model[keyPath: modelPath]
        }
    }

    public func bind<T, U>(
        _ viewPath: WritableKeyPath<Self, T>,
        to modelPath: KeyPath<Model, U>,
        through map: @escaping (U) -> T) {
        bindings.append { [weak self] model in
            self?[keyPath: viewPath] = map(model[keyPath: modelPath])
        }
    }
}
