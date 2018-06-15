import UIKit

class Section<Model> {

    var header: String?
    var update: ((inout Model) -> Void) -> Void = { _ in }

    var cells: [FormCell<Model>]

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
        cells.forEach {
            $0.render(model)
        }
    }
}
