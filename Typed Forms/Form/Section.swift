import UIKit

class Section<Model> {

    var header: String?

    var update: ((inout Model) -> Void) -> Void = { _ in }
    var insertRows: ([Int]) -> Void = { _ in }
    var deleteRows: ([Int]) -> Void = { _ in }

    var cells: [FormCell<Model>]
    var visibleCells: [FormCell<Model>] {
        return cells.filter { !$0.isHidden }
    }

    init(_ header: String? = nil, cells: [FormCell<Model>] = []) {
        self.header = header
        self.cells = cells
        cells.forEach(addCell)
    }

    func addCell(_ cell: FormCell<Model>) {
        cells.append(cell)
        cell.update = { [weak self] change in
            self?.update(change)
        }
    }

    func render(_ model: Model) {

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

        if !insertedRows.isEmpty {
            insertRows(insertedRows)
        }

        if !deletedRows.isEmpty {
            deleteRows(deletedRows)
        }
    }
}
