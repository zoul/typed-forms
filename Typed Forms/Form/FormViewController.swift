import UIKit

class FormViewController<Model>: UITableViewController {

    var form: Form<Model>
    var model: Model {
        didSet {
            form.render(model)
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

        form.render(model)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func cell(for indexPath: IndexPath) -> FormCell<Model> {
        return form.sections[indexPath.section].cells[indexPath.row]
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return form.sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return form.sections[section].cells.count
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
