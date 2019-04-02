import RealmSwift
import KeychainAccess

class DBManager {
  
  private var database: Realm?
  static let sharedInstance = DBManager()
  
  private init() {
    
    let keychain = Keychain(service: "Ada Lovelace Code.es.speedrun.realm-key")
    
    var config = Realm.Configuration()
    
    if keychain[data:"key"] != nil {
      let key = keychain[data:"key"]
      config = self.migrateRealm(key: key!)
    } else {
      // Generate a random encryption key
      var keyData = Data(count: 64)
      _ = keyData.withUnsafeMutableBytes {
        SecRandomCopyBytes(kSecRandomDefault, 64, $0)
      }
      
      let key = keyData
      keychain[data:"key"] = key
      config = self.migrateRealm(key: key)
    }
    
    // Open the encrypted Realm file
    do {
      database = try Realm(configuration: config)
    } catch let error as NSError {
      fatalError("Error opening realm: \(error)")
    }
  }
  
  func migrateRealm(key: Data) -> Realm.Configuration {
    let schemaVersion = Constants.kSchemaVersion
    let config = Realm.Configuration(
      
      encryptionKey: key, schemaVersion: schemaVersion,
      
      migrationBlock: { migration, oldSchemaVersion in
        if (oldSchemaVersion < schemaVersion) {
          
        }
    })
    
    Realm.Configuration.defaultConfiguration = config
    
    return config
  }
  
  //MARK: - ADD
  
  func addData(object: Object) {
    
    do {
      try database?.write {
        database?.add(object, update: true)
      }
    } catch {
      #if DEBUG
        print("Could not write to database: ", error)
      #endif
    }
  }
  
  //MARK: - DELETE
  
  func deleteAllDatabase()  {
    try! database?.write {
      database?.deleteAll()
    }
  }
  
  func deleteFromDb(object: Object) {
    try! database?.write {
      database?.delete(object)
    }
  }
  
  //MARK: - TRANSACTIONS
  
  func beginWriteTransaction() {
    database?.beginWrite()
  }
  
  func commitWriteTransaction() {
    try? database?.commitWrite()
  }
}
