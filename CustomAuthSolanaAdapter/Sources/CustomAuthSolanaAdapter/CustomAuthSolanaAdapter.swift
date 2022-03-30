import Foundation
import OSLog
import CustomAuth
import Solana
import ed25519swift
import FetchNodeDetails
import PromiseKit

public extension CustomAuth {
    
//    /// Initiate an CustomAuth instance.
//    /// - Parameters:
//    ///   - aggregateVerifierType: Type of the verifier. Use `singleLogin` for single providers. Only `singleLogin` and `singleIdVerifier` is supported currently.
//    ///   - aggregateVerifierName: Name of the verifier to be used..
//    ///   - subVerifierDetails: Details of each subverifiers to be used.
//    ///   - factory: Providng mocking by implementing TDSDKFactoryProtocol.
//    ///   - ethereumNetwork: Etherum network to be used.
//    ///   - solanaNetwork: Solana network to be used.
//    ///   - loglevel: Indicates the log level of this instance. All logs lower than this level will be ignored.
//    convenience init(
//        aggregateVerifierType: verifierTypes,
//        aggregateVerifierName: String,
//        subVerifierDetails: [SubVerifierDetails],
//        factory: CASDKFactoryProtocol = CASDKFactory(),
//        ethereumNetwork: EthereumNetwork = .MAINNET,
//        solanaNetwork: Network = .mainnetBeta,
//        loglevel: OSLogType = .debug,
//        urlSession: URLSession = URLSession.shared
//    ) {
//
//        network = solanaNetwork
//
//        self.init(
//            aggregateVerifierType: aggregateVerifierType,
//            aggregateVerifierName: aggregateVerifierName,
//            subVerifierDetails: subVerifierDetails,
//            factory: factory,
//            network: ethereumNetwork,
//            loglevel: loglevel,
//            urlSession: urlSession
//        )
//
//    }
//
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
