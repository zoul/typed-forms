import UIKit

public class FormButton<Model>: FormCell<Model> {

    public init(title: String, _ initializer: (FormCell<Model>) -> Void = { _ in }) {
        super.init(initializer)
        textLabel?.text = title
        textLabel?.textColor = tintColor
        textLabel?.textAlignment = .center
        shouldHighlight = true
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func render(_ model: Model) {
        super.render(model)
        textLabel?.textColor = shouldHighlight ? tintColor : .lightGray
    }
}
