//
//  KeychainService.swift
//  VexereClone
//
//  Created by Đỗ Trung Hoài on 12/04/2022.
//

class KeychainService {
    static func save(_ password: String, for account: String) {
            let password = password.data(using: String.Encoding.utf8)!
            let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                        kSecAttrAccount as String: account,
                                        kSecValueData as String: password]
            let status = SecItemAdd(query as CFDictionary, nil)
            guard status == errSecSuccess else { return print("save error")
        }
    }
    
    static func retrivePassword(for account: String) -> String? {
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrAccount as String: account,
                                    kSecMatchLimit as String: kSecMatchLimitOne,
                                    kSecReturnData as String: kCFBooleanTrue]
        var retrivedData: AnyObject? = nil
        let _ = SecItemCopyMatching(query as CFDictionary, &retrivedData)
        
        guard let data = retrivedData as? Data else {return nil}
        return String(data: data, encoding: String.Encoding.utf8)
    }
}
