import UIKit

open class FormViewController<Model>: UITableViewController {

    public lazy var form: Form<Model> = self.loadInitialForm()

    public var model: Model {
        didSet {
            tableView.beginUpdates()
            form.render(model)
            tableView.endUpdates()
        }
    }

    public init(model: Model) {
        self.model = model
        super.init(style: .grouped)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //
    // MARK: Form Loading
    //

    open func loadForm() -> Form<Model> {
        fatalError("loadForm() has not been implemented")
    }

    private func loadInitialForm() -> Form<Model> {

        let form = loadForm()

        form.render(model)

        form.update = { [weak self] change in
            guard let `self` = self else { return }
            change(&self.model)
        }

        form.insertRows = { [weak self] paths in
            self?.tableView.insertRows(at: paths, with: .automatic)
        }

        form.deleteRows = { [weak self] paths in
            self?.tableView.deleteRows(at: paths, with: .automatic)
        }

        form.insertSections = { [weak self] indices in
            self?.tableView.insertSections(IndexSet(indices), with: .automatic)
        }

        form.deleteSections = { [weak self] indices in
            self?.tableView.deleteSections(IndexSet(indices), with: .automatic)
        }

        return form
    }

    //
    // MARK: UITableViewDataSource
    //

    private func cell(for indexPath: IndexPath) -> FormCell<Model> {
        return form.visibleSections[indexPath.section].visibleCells[indexPath.row]
    }

    open override func numberOfSections(in tableView: UITableView) -> Int {
        return form.visibleSections.count
    }

    open override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return form.visibleSections[section].visibleCells.count
    }

    open override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cell(for: indexPath)
    }

    open override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return form.visibleSections[section].header
    }

    open override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return cell(for: indexPath).shouldHighlight
    }

    open override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        cell(for: indexPath).didSelect()
    }
}
