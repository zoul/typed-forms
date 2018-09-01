import UIKit

public class FormPickerCell<Model, ItemType: Equatable>: FormCell<Model>, UIPickerViewDataSource, UIPickerViewDelegate {

    public let itemsKeyPath: KeyPath<Model, [ItemType]>
    public let selectedItemKeyPath: WritableKeyPath<Model, ItemType>

    private let descriptor: (ItemType) -> String
    private var items: [ItemType] = []

    private let labelView = PickerLabel()
    private let picker = UIPickerView()

    public init(
        items: KeyPath<Model, [ItemType]>,
        selectedItem: WritableKeyPath<Model, ItemType>,
        descriptor: @escaping (ItemType) -> String = String.init(describing:),
        _ initializer: (FormPickerCell<Model, ItemType>) -> Void = { _ in }) {

        itemsKeyPath = items
        selectedItemKeyPath = selectedItem
        self.descriptor = descriptor

        super.init()

        picker.dataSource = self
        picker.delegate = self

        labelView.picker = picker

        contentView.addSubview(labelView)
        labelView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            labelView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15),
            labelView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -15),
            labelView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            labelView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -14),
        ])

        initializer(self)
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func render(_ model: Model) {

        let selectedItem = model[keyPath: selectedItemKeyPath]
        labelView.text = descriptor(selectedItem)

        let newItems = model[keyPath: itemsKeyPath]
        if newItems != items {
            items = newItems
            picker.reloadAllComponents()
        }

        if let row = items.index(of: selectedItem) {
            picker.selectRow(row, inComponent: 0, animated: true)
        }
    }

    // MARK: UIPickerViewDataSource

    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return items.count
    }

    // MARK: UIPickerViewDelegate

    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return descriptor(items[row])
    }

    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        update { model in
            model[keyPath: selectedItemKeyPath] = items[row]
        }
    }
}

private class PickerLabel: UILabel {

    var picker: UIPickerView?

    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = true
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(becomeFirstResponder)))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var canBecomeFirstResponder: Bool {
        return true
    }

    override var inputView: UIView? {
        return picker
    }

    override var inputAccessoryView: UIView? {
        let toolbar = UIToolbar()
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        toolbar.items = [
            .init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            .init(barButtonSystemItem: .done, target: self, action: #selector(resignFirstResponder)),
        ]
        return toolbar
    }
}
