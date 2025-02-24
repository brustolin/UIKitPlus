import UIKit

public class DateCell: UITableViewCell, FormCellUsable {
    public static let reuseIdentifier: String = "FORM_DATE_CELL"
    
    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .compact
        return picker
    }()
    
    public let onChange = Event<DateCell, Date>()
    
    /**
     * Context in which this cell is being used.
     */
    public var context: Any?

    public var value: Date {
        get { datePicker.date }
        set { datePicker.date = newValue }
    }
    
    public init() {
        super.init(style: .default, reuseIdentifier: Self.reuseIdentifier)
        setup()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        accessoryView = datePicker
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
    }
    
    @objc
    private func dateChanged(_ sender: UIDatePicker) {
        onChange(self, sender.date)
    }
}
