import UIKit

public class Form<Model> {

    var update: ((inout Model) -> Void) -> Void = { _ in }

    var insertRows: ([IndexPath]) -> Void = { _ in }
    var deleteRows: ([IndexPath]) -> Void = { _ in }

    var insertSections: ([Int]) -> Void = { _ in }
    var deleteSections: ([Int]) -> Void = { _ in }

    public private(set) var sections: [Section<Model>] = []
    public var visibleSections: [Section<Model>] {
        return sections.filter { $0.isVisible }
    }

    public init(sections: [Section<Model>] = []) {
        sections.forEach(addSection)
    }

    public func addSection(_ section: Section<Model>) {
        sections.append(section)
        section.update = { [weak self] change in
            self?.update(change)
        }
        section.insertRows = { [weak self] rows in
            guard let index = self?.visibleSections.index(where: { $0 === section }) else { return }
            let paths = rows.map { IndexPath(row: $0, section: index) }
            self?.insertRows(paths)
        }
        section.deleteRows = { [weak self] rows in
            guard let index = self?.visibleSections.index(where: { $0 === section }) else { return }
            let paths = rows.map { IndexPath(row: $0, section: index) }
            self?.deleteRows(paths)
        }
    }

    func render(_ model: Model) {

        var changedSections: [Section<Model>] = []
        let previouslyVisible = visibleSections

        for section in sections {
            let wasHidden = section.isHidden
            section.render(model)
            if wasHidden != section.isHidden {
                changedSections.append(section)
            }
        }

        var insertedSections: [Int] = []
        var deletedSections: [Int] = []
        let nowVisible = visibleSections

        for section in changedSections {
            if section.isHidden, let index = previouslyVisible.index(where: { $0 === section }) {
                deletedSections.append(index)
            }
            if !section.isHidden, let index = nowVisible.index(where: { $0 === section }) {
                insertedSections.append(index)
            }
        }

        if !insertedSections.isEmpty {
            insertSections(insertedSections)
        }

        if !deletedSections.isEmpty {
            deleteSections(deletedSections)
        }
    }
}
