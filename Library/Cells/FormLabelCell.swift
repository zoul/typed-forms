import UIKit

public class FormLabelCell<Model>: FormCell<Model> {

    public init(title: String, _ initializer: (FormCell<Model>) -> Void = { _ in }) {
        super.init(initializer)
        textLabel?.text = title
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
