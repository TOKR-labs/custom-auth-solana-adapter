import Foundation
import OSLog
import CustomAuth
import Solana
import ed25519swift
import FetchNodeDetails
import PromiseKit

public extension CustomAuth {
 
    /// Retrieve the Torus key from the nodes given an already known token. Useful if a custom login flow is required.
    /// - Parameters:
    ///   - verifier: A verifier is a unique identifier for your OAuth registration on the torus network. The public/private keys generated for a user are scoped to a verifier.
    ///   - verifierId: The unique identifier to publicly represent a user on a verifier. e.g: email, sub etc. other fields can be classified as verifierId,
    ///   - idToken: Access token received from the OAuth provider.
    ///   - userData: Custom data that will be returned with a solana `privateKey` and `publicAddress`.
    /// - Returns: A promise that resolve with a Dictionary that contain at least solana `privateKey` and `publicAddress` field..
    func getTorusKeyAndGenerateSolanaKeyPair(
        verifier: String,
        verifierId: String,
        idToken:String,
        userData: [String: Any] = [:]
    ) -> Promise<[String: Any]> {
        
        
        let (tempPromise, seal) = Promise<[String: Any]>.pending()
        
        self.getTorusKey(
            verifier: verifier,
            verifierId: verifierId,
            idToken: idToken,
            userData: userData
        ).done { data in
            
            var data = data
            
            guard let privateKey = data["privateKey"] as? String else {
                seal.reject(CASDKError.unknownError)
                return
            }
            
            var privateKeyBytes = Data(hex: privateKey).bytes
            let publicKeyBytes = Ed25519.calcPublicKey(secretKey: privateKeyBytes)
            
            privateKeyBytes.append(contentsOf: publicKeyBytes)

            
            
            guard let account = Account(secretKey: Data(bytes: privateKeyBytes, count: 64)) else {
                seal.reject(CASDKError.unknownError)
                return
            }
            
            data["solanaAccount"] = account
            
            seal.fulfill(data)
            
        }.catch { error in
            
            seal.reject(error)
            
        }
 
        return tempPromise
        
    }
    
}
