import UIKit

open class FormViewController<Model>: UITableViewController {

    public var form: Form<Model>
    public var model: Model {
        didSet {
            tableView.beginUpdates()
            form.render(model)
            tableView.endUpdates()
        }
    }

    public init(model: Model, form: Form<Model>) {

        self.model = model
        self.form = form

        super.init(style: .grouped)

        form.update = { [weak self] change in
            guard let `self` = self else { return }
            change(&self.model)
            print("New model: \(self.model)")
        }

        form.insertRows = { [weak self] paths in
            self?.tableView.insertRows(at: paths, with: .automatic)
        }

        form.deleteRows = { [weak self] paths in
            self?.tableView.deleteRows(at: paths, with: .automatic)
        }

        form.render(model)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func cell(for indexPath: IndexPath) -> FormCell<Model> {
        return form.sections[indexPath.section].visibleCells[indexPath.row]
    }

    open override func numberOfSections(in tableView: UITableView) -> Int {
        return form.sections.count
    }

    open override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return form.sections[section].visibleCells.count
    }

    open override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cell(for: indexPath)
    }

    open override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return form.sections[section].header
    }

    open override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return cell(for: indexPath).shouldHighlight
    }

    open override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        cell(for: indexPath).didSelect()
    }
}
