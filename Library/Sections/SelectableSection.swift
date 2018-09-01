import UIKit

public class SelectableSection<Model, ItemType>: Section<Model> where ItemType: Equatable {

    public let itemsKeyPath: KeyPath<Model, [ItemType]>
    public let selectedItemKeyPath: WritableKeyPath<Model, ItemType>

    private let descriptor: (ItemType) -> String
    private var displayedItems: [ItemType] = []

    public init(
        _ header: String? = nil,
        items: KeyPath<Model, [ItemType]>,
        selectedItem: WritableKeyPath<Model, ItemType>,
        descriptor: @escaping (ItemType) -> String = String.init(describing:)) {
        itemsKeyPath = items
        selectedItemKeyPath = selectedItem
        self.descriptor = descriptor
        super.init(header, cells: [])
    }

    override func render(_ model: Model) -> TableUpdates {

        let delta = super.render(model)

        let items = model[keyPath: itemsKeyPath]
        let selectedItem = model[keyPath: selectedItemKeyPath]

        // Reload cells if needed
        if items != displayedItems {
            cells = items.map(cellForItem) // TODO: This doesn’t hook update, though?
            displayedItems = items
        }

        // Update selection
        cells.forEach { $0.accessoryType = .none }
        if let selectedIndex = items.index(of: selectedItem) {
            cells[selectedIndex].accessoryType = .checkmark
        }

        return delta
    }

    private func cellForItem(_ item: ItemType) -> FormCell<Model> {
        let cell = FormLabelCell<Model>(primaryText: descriptor(item))
        cell.shouldHighlight = true
        cell.didSelect = { [weak self] in
            self?.didSelectCell(cell)
        }
        return cell
    }

    private func didSelectCell(_ cell: FormCell<Model>) {
        guard let itemIndex = cells.index(of: cell) else { return }
        update { model in
            let items = model[keyPath: itemsKeyPath]
            model[keyPath: selectedItemKeyPath] = items[itemIndex]
        }
    }
}
