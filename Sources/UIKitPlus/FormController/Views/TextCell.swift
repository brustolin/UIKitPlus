import UIKit

/// This cell is useful for forms where users need to enter text.
/// The `onChange` event notifies listeners whenever the text field value changes.
///
/// ## Example Usage:
/// ```swift
/// let cell = TextCell()
/// cell.label.text = "Name"
/// cell.textField.placeholder = "Enter your name"
/// cell.onChange += { [weak self] cell, text in
///     print("Text changed: \(text)")
///     return true // Keep listening for changes
/// }
/// ```
public class TextCell: UITableViewCell, FormCellUsable {
    
    /// A static reuse identifier for dequeuing cells.
    public static let reuseIdentifier: String = "FORM_TEXT_CELL"
    
    public var value: String = ""
    
    /// The text field displayed on the right side of the cell.
    public let textField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .right
        textField.clearButtonMode = .whileEditing
        return textField
    }()
    
    /// An event that triggers when the text field value changes.
    ///
    /// The closure receives `self` (the `TextCell` instance) and the updated text.
    /// Returning `false` removes the listener.
    ///
    /// ## Example:
    /// ```swift
    /// cell.onChange += { [weak self] cell, text in
    ///     print("New text: \(text)")
    ///     return true // Keep listening
    /// }
    /// ```
    public let onChange = Event<TextCell, String>()
    
    /// Context in which this cell is being used.
    ///
    /// This property is optional and allows storing additional metadata
    /// relevant to the cell’s use case.
    var context: Any?
    
    /// Initializes a new `TextCell` instance.
    public init() {
        super.init(style: .default, reuseIdentifier: Self.reuseIdentifier)
        setup()
    }
    
    /// Initializes the cell from a storyboard or nib.
    /// - Parameter coder: The decoder to load from.
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    /// Sets up the layout and behavior of the cell.
    private func setup() {
        contentView.addSubview(textField)
        textField.addTarget(self, action: #selector(textDidChange(_:)), for: .editingChanged)
    }
    
    /// Handles text field changes and notifies listeners via `onChange`.
    /// - Parameter sender: The text field that triggered the event.
    @objc private func textDidChange(_ sender: UITextField) {
        onChange(self, sender.text ?? "")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        let labelWidth = self.textLabel?.frame.width ?? 0
        textField.frame = CGRect(x: labelWidth, y: 0, width: contentView.frame.width - labelWidth, height: contentView.frame.height)
    }
}
