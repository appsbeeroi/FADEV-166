import Foundation

final class Storage {
    
    static let instance = Storage()
    
    private let store = UserDefaults.standard
    private let jsonEncoder = JSONEncoder()
    private let jsonDecoder = JSONDecoder()
        
    func saveObject<T: Codable>(_ object: T, key: StorageKey) async {
        do {
            let encoded = try jsonEncoder.encode(object)
            store.set(encoded, forKey: key.rawValue)
        } catch {
            debugPrint("❌ Encoding error for \(T.self): \(error.localizedDescription)")
        }
    }
    
    func readObject<T: Codable>(as type: T.Type, key: StorageKey) async -> T? {
        guard let raw = store.data(forKey: key.rawValue) else { return nil }
        
        do {
            return try jsonDecoder.decode(type, from: raw)
        } catch {
            debugPrint("❌ Decoding error for \(T.self): \(error.localizedDescription)")
            return nil
        }
    }
    
    func clear(_ key: StorageKey) async {
        store.removeObject(forKey: key.rawValue)
    }
}

enum StorageKey: String {
    case service
    case document
    case history
}
