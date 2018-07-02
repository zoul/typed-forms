import UIKit

public class FormLabelCell<Model>: FormCell<Model> {

    public var primaryText: String? {
        get { return textLabel?.text }
        set { textLabel?.text = newValue }
    }

    public var secondaryText: String? {
        get { return detailTextLabel?.text }
        set { detailTextLabel?.text = newValue }
    }

    public init(
        style: UITableViewCellStyle = .default,
        primaryText: String? = nil,
        secondaryText: String? = nil,
        _ initializer: (FormLabelCell<Model>) -> Void = { _ in }) {
        super.init(style: style)
        textLabel?.text = primaryText
        detailTextLabel?.text = secondaryText
        initializer(self)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/// Bind title directly to a key path in the initializer
public extension FormLabelCell {

    public convenience init(
        style: UITableViewCellStyle = .default,
        primaryText primaryTextPath: KeyPath<Model, String?>,
        _ initializer: (FormLabelCell<Model>) -> Void = { _ in }) {
        self.init(style: style)
        bind(\.primaryText, to: primaryTextPath)
        initializer(self)
    }

    public convenience init(
        style: UITableViewCellStyle = .default,
        primaryText primaryTextPath: KeyPath<Model, String>,
        _ initializer: (FormLabelCell<Model>) -> Void = { _ in }) {
        self.init(style: style)
        bind(\.primaryText, to: primaryTextPath)
        initializer(self)
    }
}
