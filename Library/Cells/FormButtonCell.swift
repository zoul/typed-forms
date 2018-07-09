import UIKit

public class FormButtonCell<Model>: FormCell<Model> {

    public var title: String? {
        get { return textLabel?.text }
        set { textLabel?.text = newValue }
    }

    public init(title: String? = nil, _ initializer: (FormButtonCell<Model>) -> Void = { _ in }) {
        super.init()
        textLabel?.text = title
        textLabel?.textColor = tintColor
        textLabel?.textAlignment = .center
        shouldHighlight = true
        initializer(self)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func render(_ model: Model) {
        super.render(model)
        textLabel?.textColor = shouldHighlight ? tintColor : .lightGray
    }
}
