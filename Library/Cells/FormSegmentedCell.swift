import UIKit

public class FormSegmentedCell<Model, ItemType>: FormCell<Model> where ItemType: Equatable {

    public let itemsKeyPath: KeyPath<Model, [ItemType]>
    public let selectedItemKeyPath: WritableKeyPath<Model, ItemType>
    public let segmentedControl = UISegmentedControl()

    private var displayedItems: [ItemType] = []
    private let descriptor: (ItemType) -> String

    public init(items: KeyPath<Model, [ItemType]>, selectedItem: WritableKeyPath<Model, ItemType>,
        descriptor: @escaping (ItemType) -> String) {

        itemsKeyPath = items
        selectedItemKeyPath = selectedItem
        self.descriptor = descriptor

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

    public required init?(coder aDecoder: NSCoder) {
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
                segmentedControl.insertSegment(withTitle: descriptor($0),
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

extension FormSegmentedCell where ItemType: CustomStringConvertible {

    public convenience init(items: KeyPath<Model, [ItemType]>, selectedItem: WritableKeyPath<Model, ItemType>) {
        self.init(items: items, selectedItem: selectedItem, descriptor: { $0.description })
    }
}
