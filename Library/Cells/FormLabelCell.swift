import UIKit

public class FormLabelCell<Model>: FormCell<Model> {

    public init(title: String, _ initializer: (FormLabelCell<Model>) -> Void = { _ in }) {
        super.init()
        textLabel?.text = title
        initializer(self)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
