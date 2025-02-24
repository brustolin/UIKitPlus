import UIKit

/// A custom `UITableViewCell` containing a `UISwitch`, used in forms or settings screens.
///
/// This cell provides a simple switch component inside a table cell, allowing users to toggle a boolean value.
/// It notifies listeners through the `onChange` event when the switch value changes.
///
/// ## Example Usage
/// ```swift
/// let switchCell = SwitchCell()
/// switchCell.value = true
/// switchCell.onChange += { [weak self] cell, isOn in
///     guard let self = self else { return false }
///     print("Switch toggled: \(isOn)")
///     return true // Keep listening for changes
/// }
/// ```
///
/// ## Important
/// - **Always use `[weak self]` in closures** when capturing `self` inside `onChange` to prevent retain cycles.
/// - The `onChange` event returns `false` to remove the listener after execution.
///
/// ## Features:
/// - Provides a simple way to integrate a switch in `UITableViewCell`.
/// - Uses `Event<SwitchCell, Bool>` to notify listeners when the switch state changes.
/// - Can be reused with `reuseIdentifier`.
public class SwitchCell : UITableViewCell, FormCellUsable {
    
    
    /// A static reuse identifier for dequeuing cells.
    public static let reuseIdentifier: String = "FORM_SWITCH_CELL"
    
    /// The switch component displayed in the cell.
    private let switchView: UISwitch = UISwitch()
    
    /// An event that triggers when the switch value changes.
    ///
    /// This allows external listeners to react when the switch is toggled.
    /// - The closure receives `self` (the `SwitchCell` instance) and a `Bool` indicating the new switch state.
    /// - If the closure returns `false`, it will be automatically removed.
    ///
    /// ## Usage:
    /// ```swift
    /// switchCell.onChange += { [weak self] cell, isOn in
    ///     self?.handleToggle(isOn)
    ///     return true // Keep listening for changes
    /// }
    /// ```
    public let onChange = Event<SwitchCell, Bool>()
    
    /// Context in which this cell is being used.
    ///
    /// This property is optional and allows storing additional metadata
    /// relevant to the cell’s use case.
    var context: Any?
    
    /// The current value of the switch.
    ///
    /// - Setting this property updates the `UISwitch` state.
    /// - Getting this property returns the current switch state.
    public var value: Bool {
        get { switchView.isOn }
        set { switchView.isOn = newValue }
    }
    
    /// Initializes a new `SwitchCell` instance.
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
    
    /// Sets up the cell by adding the `UISwitch` and configuring event listeners.
    private func setup() {
        self.accessoryView = switchView
        switchView.addTarget(self, action: #selector(switchIsOnChanged(_:)), for: .valueChanged)
    }
    
    /// Handles switch toggle events and notifies listeners via `onChange`.
    /// - Parameter sender: The switch that triggered the event.
    @objc
    private func switchIsOnChanged(_ sender: Any?) {
        onChange(self, value)
    }
    
}
