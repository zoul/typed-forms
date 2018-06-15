import UIKit

class Form<Model> {

    var update: ((inout Model) -> Void) -> Void = { _ in }
    var insertRows: ([IndexPath]) -> Void = { _ in }
    var deleteRows: ([IndexPath]) -> Void = { _ in }

    private(set) var sections: [Section<Model>] = []

    init(sections: [Section<Model>] = []) {
        sections.forEach(addSection)
    }

    func addSection(_ section: Section<Model>) {
        let index = sections.count
        sections.append(section)
        section.update = { [weak self] change in
            self?.update(change)
        }
        section.insertRows = { [weak self] rows in
            let paths = rows.map { IndexPath(row: $0, section: index) }
            self?.insertRows(paths)
        }
        section.deleteRows = { [weak self] rows in
            let paths = rows.map { IndexPath(row: $0, section: index) }
            self?.deleteRows(paths)
        }
    }

    func render(_ model: Model) {
        sections.forEach {
            $0.render(model)
        }
    }
}
