import UIKit

public class Form<Model> {

    var update: ((inout Model) -> Void) -> Void = { _ in }

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
    }

    func render(_ model: Model) -> TableUpdates {

        var changedSections: [Section<Model>] = []
        let previouslyVisible = visibleSections
        var updates = TableUpdates()

        for (index, section) in sections.enumerated() {
            let wasHidden = section.isHidden
            let sectionUpdates = section.render(model)
            updates.appendSectionUpdates(sectionUpdates, withSectionIndex: index)
            if wasHidden != section.isHidden {
                changedSections.append(section)
            }
        }

        let nowVisible = visibleSections

        for section in changedSections {
            if section.isHidden, let index = previouslyVisible.index(where: { $0 === section }) {
                updates.deletedSections.insert(index)
            }
            if !section.isHidden, let index = nowVisible.index(where: { $0 === section }) {
                updates.insertedSections.insert(index)
            }
        }

        return updates
    }
}

public extension Form {

    public struct TableUpdates: Equatable {

        public var insertedRows: [IndexPath]
        public var deletedRows: [IndexPath]
        public var insertedSections: IndexSet
        public var deletedSections: IndexSet

        public init() {
            insertedRows = []
            deletedRows = []
            insertedSections = IndexSet()
            deletedSections = IndexSet()
        }

        public mutating func appendSectionUpdates(_ updates: Section<Model>.TableUpdates, withSectionIndex index: Int) {
            deletedRows.append(contentsOf: updates.deletedRows.map { IndexPath(row: $0, section: index) })
            insertedRows.append(contentsOf: updates.insertedRows.map { IndexPath(row: $0, section: index) })
        }

        public func apply(to tableView: UITableView) {
            tableView.beginUpdates()
            tableView.insertRows(at: insertedRows, with: .automatic)
            tableView.deleteRows(at: deletedRows, with: .automatic)
            tableView.insertSections(insertedSections, with: .automatic)
            tableView.deleteSections(deletedSections, with: .automatic)
            tableView.endUpdates()
        }
    }
}
