import UIKit

class FormViewController<Model>: UITableViewController {

    var form: Form<Model>
    var model: Model {
        didSet {
            tableView.beginUpdates()
            form.render(model)
            tableView.endUpdates()
        }
    }

    init(model: Model, form: Form<Model>) {

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

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func cell(for indexPath: IndexPath) -> FormCell<Model> {
        return form.sections[indexPath.section].visibleCells[indexPath.row]
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return form.sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return form.sections[section].visibleCells.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cell(for: indexPath)
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return form.sections[section].header
    }

    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return cell(for: indexPath).shouldHighlight
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        cell(for: indexPath).didSelect()
    }
}
