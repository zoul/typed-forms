import UIKit

public class Section<Model>: _Bindable {

    public var header: String?

    public var isHidden = false
    public var isVisible: Bool {
        get { return !isHidden }
        set { isHidden = !newValue }
    }

    /// This should really be private, see https://github.com/zoul/typed-forms/issues/1.
    public var bindings: [(Model) -> Void] = []

    var update: ((inout Model) -> Void) -> Void = { _ in }
    var insertRows: ([Int]) -> Void = { _ in }
    var deleteRows: ([Int]) -> Void = { _ in }

    var cells: [FormCell<Model>]
    var visibleCells: [FormCell<Model>] {
        return cells.filter { $0.isVisible }
    }

    public init(_ header: String? = nil, cells: [FormCell<Model>] = []) {
        self.header = header
        self.cells = cells
        cells.forEach(addCell)
    }

    public func addCell(_ cell: FormCell<Model>) {
        cells.append(cell)
        cell.update = { [weak self] change in
            self?.update(change)
        }
    }

    func render(_ model: Model) {

        bindings.forEach { $0(model) }

        var changedCells: [FormCell<Model>] = []
        let previouslyVisible = visibleCells

        for cell in cells {
            let wasHidden = cell.isHidden
            cell.render(model)
            if wasHidden != cell.isHidden {
                changedCells.append(cell)
            }
        }

        var insertedRows: [Int] = []
        var deletedRows: [Int] = []
        let nowVisible = visibleCells

        for cell in changedCells {
            if cell.isHidden, let row = previouslyVisible.index(of: cell) {
                deletedRows.append(row)
            }
            if !cell.isHidden, let row = nowVisible.index(of: cell) {
                insertedRows.append(row)
            }
        }

        if !deletedRows.isEmpty {
            deleteRows(deletedRows)
        }

        if !insertedRows.isEmpty {
            insertRows(insertedRows)
        }
    }
}
