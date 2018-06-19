import UIKit

public class FormLabelCell<Model>: FormCell<Model> {

    public var title: String? {
        get { return textLabel?.text }
        set { textLabel?.text = newValue }
    }

    public init(title: String? = nil, _ initializer: (FormLabelCell<Model>) -> Void = { _ in }) {
        super.init()
        textLabel?.text = title
        initializer(self)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
