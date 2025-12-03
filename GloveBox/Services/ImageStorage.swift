import UIKit

actor ImageStorage {
    
    static let instance = ImageStorage()
    
    private let cache = NSCache<NSString, UIImage>()
    private let fileManager = FileManager.default
    private let directoryURL: URL
    
    private init() {
        let root = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        directoryURL = root.appendingPathComponent("VaultImages", isDirectory: true)
        createDirectoryIfNeeded()
    }
    
    private func createDirectoryIfNeeded() {
        guard !fileManager.fileExists(atPath: directoryURL.path) else { return }
        
        do {
            try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true)
            debugPrint("📁 Created ImageVault at:", directoryURL.path)
        } catch {
            debugPrint("🚫 Failed to create ImageVault:", error.localizedDescription)
        }
    }
    
    private func fileURL(for id: UUID) -> URL {
        directoryURL.appendingPathComponent("\(id.uuidString).png")
    }
    
    @discardableResult
    func save(_ image: UIImage, id: UUID) -> String? {
        guard let data = image.pngData() else {
            debugPrint("⚠️ Failed to convert UIImage → PNG")
            return nil
        }
        
        let url = fileURL(for: id)
        
        do {
            try data.write(to: url, options: .atomic)
            cache.setObject(image, forKey: id.uuidString as NSString)
            debugPrint("💾 Stored image:", url.lastPathComponent)
            return url.lastPathComponent
        } catch {
            debugPrint("🚫 Save failed:", error.localizedDescription)
            return nil
        }
    }
    
    func image(for id: UUID) -> UIImage? {
        if let cached = cache.object(forKey: id.uuidString as NSString) {
            return cached
        }
        
        let url = fileURL(for: id)
        guard fileManager.fileExists(atPath: url.path) else {
            debugPrint("🔍 No file for:", id)
            return nil
        }
        
        guard let image = UIImage(contentsOfFile: url.path) else {
            debugPrint("🚫 Failed to decode:", url.lastPathComponent)
            return nil
        }
        
        cache.setObject(image, forKey: id.uuidString as NSString)
        return image
    }
    
    func delete(_ id: UUID) {
        cache.removeObject(forKey: id.uuidString as NSString)
        
        let url = fileURL(for: id)
        guard fileManager.fileExists(atPath: url.path) else {
            debugPrint("⚠️ Nothing to delete:", url.lastPathComponent)
            return
        }
        
        do {
            try fileManager.removeItem(at: url)
            debugPrint("🗑️ Removed:", url.lastPathComponent)
        } catch {
            debugPrint("🚫 Delete failed:", error.localizedDescription)
        }
    }
    
    func contains(_ id: UUID) -> Bool {
        fileManager.fileExists(atPath: fileURL(for: id).path)
    }
    
    func clearCache() {
        cache.removeAllObjects()
        debugPrint("🧹 Cache cleared")
    }
    
    func clearDisk() {
        do {
            try fileManager.removeItem(at: directoryURL)
            try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true)
            cache.removeAllObjects()
            debugPrint("🧨 Vault fully reset")
        } catch {
            debugPrint("🚫 Clear failed:", error.localizedDescription)
        }
    }
}
