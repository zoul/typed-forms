import UIKit

class FormSegmentedCell<Model, ItemType>: FormCell<Model> where ItemType: Equatable & CustomStringConvertible {

    private let itemsKeyPath: KeyPath<Model, [ItemType]>
    private let selectedItemKeyPath: WritableKeyPath<Model, ItemType>

    private let segmentedControl = UISegmentedControl()
    private var displayedItems: [ItemType] = []

    init(items: KeyPath<Model, [ItemType]>, selectedItem: WritableKeyPath<Model, ItemType>) {

        itemsKeyPath = items
        selectedItemKeyPath = selectedItem

        super.init()

        segmentedControl.addTarget(self, action: #selector(valueChanged), for: .valueChanged)

        contentView.addSubview(segmentedControl)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            segmentedControl.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 12),
            segmentedControl.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -12),
            segmentedControl.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            segmentedControl.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func render(_ model: Model) {

        super.render(model)

        let items = model[keyPath: itemsKeyPath]
        let selectedItem = model[keyPath: selectedItemKeyPath]

        // Reload cells if needed
        if items != displayedItems {
            segmentedControl.removeAllSegments()
            items.forEach {
                segmentedControl.insertSegment(withTitle: $0.description,
                    at: segmentedControl.numberOfSegments, animated: false)
            }
            displayedItems = items
        }

        // Update selection
        if let selectedIndex = items.index(of: selectedItem) {
            segmentedControl.selectedSegmentIndex = selectedIndex
        }
    }

    @objc private func valueChanged() {
        let selectedItem = displayedItems[segmentedControl.selectedSegmentIndex]
        update { model in
            model[keyPath: selectedItemKeyPath] = selectedItem
        }
    }
}
