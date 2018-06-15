import UIKit

class FormLabelCell<Model>: FormCell<Model> {

    init(title: String, _ initializer: (FormCell<Model>) -> Void = { _ in }) {
        super.init(initializer)
        textLabel?.text = title
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
