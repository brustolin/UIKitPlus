import UIKit

/// Represents different form field types
public enum FormEntityProperty<T: FormEntity> {
    case string(label: String, keyPath: WritableKeyPath<T, String>)
    case int(label: String, keyPath: WritableKeyPath<T, Int>, range: ClosedRange<Int>? = nil)
    case bool(label: String, keyPath: WritableKeyPath<T, Bool>)
    case date(label: String, keyPath: WritableKeyPath<T, Date>)
}

/// Protocol for entities that can be used in the form
public protocol FormEntity {
    static var formFields: [FormEntityProperty<Self>] { get } // Static form definition
}

/// Example model implementing FormEntity
public struct User: FormEntity {
    var name: String = ""
    var age: Int = 18
    var isActive: Bool = true
    
    public static var formFields: [FormEntityProperty<Self>] {
        return [
            .string(label: "Name", keyPath: \.name),
            .int(label: "Age", keyPath: \.age),
            .bool(label: "Active", keyPath: \.isActive)
        ]
    }
}

/// UITableViewController that generates form cells dynamically
public class FormController<T: FormEntity>: UITableViewController {
    
    var entity: T
    let fields: [FormEntityProperty<T>]
    
    public init(entity: T) {
        self.entity = entity
        self.fields = T.formFields
        super.init(style: .grouped)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fields.count
    }
    
    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let field = fields[indexPath.row]
        
        switch field {
        case .string(let label, let keyPath):
            let cell = TextCell()
            cell.setLabelText(label)
            cell.textField.text = entity[keyPath: keyPath]
            cell.onChange += { [weak self] _, newValue in
                guard let self else { return false }
                self.entity[keyPath: keyPath] = newValue
                return true
            }
            return cell
        case .bool(let label, let keyPath):
            let cell = SwitchCell()
            cell.setLabelText(label)
            cell.value = entity[keyPath: keyPath]
            cell.onChange += { [weak self] _, newValue in
                guard let self else { return false }
                self.entity[keyPath: keyPath] = newValue
                return true
            }
            return cell
        case .int(let label, let keyPath, let range):
            let cell = IntegerCell()
            cell.setLabelText(label)
            cell.value = entity[keyPath: keyPath]
            cell.range = range ?? 0...100 // Default range
            cell.onChange += { [weak self] _, newValue in
                guard let self else { return false }
                self.entity[keyPath: keyPath] = newValue
                return true
            }
            return cell
        case .date(let label, let keyPath):
            let cell = DateCell()
            cell.setLabelText(label)
            cell.value = entity[keyPath: keyPath]
            cell.onChange += { [weak self] _, newValue in
                guard let self else { return false }
                self.entity[keyPath: keyPath] = newValue
                return true
            }
            
            return cell
        }
    }
}
