import Foundation
import TSCUtility

extension Item {
    // Main function to parse JSON from a string
    public static func fromJSON(from jsonString: String, name: String = "root", priority: UInt = 4) -> Item? {
        guard let data = jsonString.data(using: .utf8) else {
            print("Invalid JSON string encoding.")
            return nil
        }
        
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            return Self.fromJSON(name: name, json: jsonObject, priority: priority)
        } catch {
            print("Failed to parse JSON: \(error)")
            return nil
        }
    }
    
    // Recursive function to convert parsed JSON into `Item` instances
    public static func fromJSON(name: String, json: Any, priority: UInt = 4) -> Item {
        if let dictionary = json as? [String: Any] {
                // JSON is a dictionary, treat keys as subItems
            let subItems = dictionary.map { key, value in
                fromJSON(name: key, json: value, priority: priority)
            }
            return Item(name, priority: priority, subItems: subItems)
        } else if let array = json as? [Any] {
                // JSON is an array, create subItems for each element in the array
            let subItems = array.enumerated().map { index, value in
                Self.fromJSON(name: "\(name)[\(index)]", json: value, priority: priority)
            }
            return Item(name, priority: priority, subItems: subItems)
        } else {
                // JSON is a literal, store its value in documentation
            return Item(name, priority: priority, documentation: "\(json)")
        }
    }
}
