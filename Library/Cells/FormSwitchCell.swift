import UIKit

public class FormSwitchCell<Model>: FormCell<Model> {

    public let keyPath: WritableKeyPath<Model, Bool>

    private let switchControl = UISwitch()

    public init(keyPath: WritableKeyPath<Model, Bool>, title: String) {

        self.keyPath = keyPath

        super.init()

        selectionStyle = .none
        textLabel?.text = title
        accessoryView = switchControl
        switchControl.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func valueChanged() {
        update { model in
            model[keyPath: keyPath] = switchControl.isOn
        }
    }

    override func render(_ model: Model) {
        super.render(model)
        switchControl.setOn(model[keyPath: keyPath], animated: true)
    }
}
