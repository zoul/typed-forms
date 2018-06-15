import UIKit

class Form<Model> {

    var update: ((inout Model) -> Void) -> Void = { _ in }

    private(set) var sections: [Section<Model>] = []

    init(sections: [Section<Model>] = []) {
        sections.forEach(addSection)
    }

    func addSection(_ section: Section<Model>) {
        sections.append(section)
        section.update = { [weak self] change in
            self?.update(change)
        }
    }

    func render(_ model: Model) {
        sections.forEach {
            $0.render(model)
        }
    }
}
