import UIKit

class SelectableSection<Model, ItemType>: Section<Model> where ItemType: Equatable & CustomStringConvertible {

    let itemsKeyPath: KeyPath<Model, [ItemType]>
    let selectedItemKeyPath: WritableKeyPath<Model, ItemType>

    private var displayedItems: [ItemType] = []

    init(_ header: String? = nil, items: KeyPath<Model, [ItemType]>, selectedItem: WritableKeyPath<Model, ItemType>) {
        itemsKeyPath = items
        selectedItemKeyPath = selectedItem
        super.init(header, cells: [])
    }

    override func render(_ model: Model) {

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
    }

    private func cellForItem(_ item: ItemType) -> FormCell<Model> {
        let cell = FormLabelCell<Model>(title: item.description)
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
