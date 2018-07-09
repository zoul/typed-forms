import UIKit

public class FormTextFieldCell<Model>: FormCell<Model>, UITextFieldDelegate {

    public let keyPath: WritableKeyPath<Model, String?>
    public let textField = UITextField()

    public init(
        keyPath: WritableKeyPath<Model, String?>,
        _ initializer: (FormTextFieldCell<Model>) -> Void = { _ in }) {

        self.keyPath = keyPath

        super.init()

        contentView.addSubview(textField)

        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.returnKeyType = .done

        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)

        NSLayoutConstraint.activate([
            textField.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15),
            textField.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -15),
            textField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -14),
        ])

        initializer(self)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func render(_ model: Model) {
        super.render(model)
        textField.text = model[keyPath: keyPath]
    }

    @objc private func textFieldDidChange() {
        update { model in
            model[keyPath: keyPath] = textField.text
        }
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
