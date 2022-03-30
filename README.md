This library was created out of nessecity due to a few key factors: 

1. There was a need to continue to use an already implemented authentication mechanism (e.g. OKTA) and to keep control over that experience.
2. Generate a Solana wallet for every user that signs up for our app to preform on-chain actions.

Use the adapter outright, or learn from the source code, either way the hope is that this can alleviate some of the pain of generating Solana wallets that are tied to users accounts and whose private key can be retrieved through the use of the custom auth library. 

# Installation

## Xcode Projects

_Select File -> Swift Packages -> Add Package Dependency_ and enter https://github.com/TOKR-labs/custom-auth-solana-adapter/.

### Swift Package Manager Projects
You can add CustomAuthSolanaAdapter as a package dependency in your Package.swift file:

```
let package = Package(
    //...
    dependencies: [
        .package(
            name: "CustomAuthSolanaAdapter",
            url: "https://github.com/TOKR-labs/custom-auth-solana-adapter",
            branch: "main"
        ),
    ],
    //...
)
```

From there, refer to the CustomAuthSolanaAdapter "product" delivered by the CustomAuthSolanaAdapter "package" inside of any of your project's target dependencies:

```
targets: [
    .target(
        name: "YourLibrary",
        dependencies: [
            .product(name: "CustomAuthSolanaAdapter", package: "custom-auth-solana-adapter")
        ],
        ...
    ),
    ...
]
```

Then simply import CustomAuthSolanaAdapter wherever you’d like to use it.

# Usage

1. Generate custom verifier config through Web3Auth dev console.
2. Install this package via SPM.
3. Use the `getTorusKeyAndGenerateSolanaKeyPair` method rather than the `getTorusKey` method when using a custom verifier.

## Code Example:

```
import Solana
import CustomAuthSolanaAdapter

// you can use any JWT lib or if you know the userId without having to decode you can do that 
let JWT = try? JWTDecode.decode(jwt: accessToken)
let claim = JWT?.claim(name: "userId")

// pull the user id off of the JWT token
guard let userId = claim?.string else {
    promise(.failure(.jwtDecodeIssue))
    return
}

let tdsdk = CustomAuth(
    aggregateVerifierType: .singleLogin,
    aggregateVerifierName:  "<CUSTOM_AUTH_VERIFIER_NAME>",
    subVerifierDetails: [],
    network: .TESTNET,
    loglevel: .debug
)

tdsdk.getTorusKeyAndGenerateSolanaKeyPair(
    verifier:  "<CUSTOM_AUTH_VERIFIER_NAME>",
    verifierId: userId,
    idToken: accessToken
)
    .done { data in
    
        guard let account = data["account"] as? Account else {
            // generation of solana account failed
            return
        }
    
        print("solana public key = \(account.publicKey)")
        print("solana private key = \(account.secretKey)")
        
        self.solana.auth.save(account)
            .onFailure { error in
                // something went wrong saving account to account storage
            }.onSuccess { _ in
                // account was saved successfully
            }
    
    }
    .catch { error in
    
        self.log.error("erorr: \(error.localizedDescription)")
        promise(.failure(.getTorusKeyFailure))
    
    }
```

## Referenced Libraries

1. [CustomAuth Swift SDK](https://github.com/torusresearch/customauth-swift-sdk)
1. [Solana Swift RPC Wrapper](https://github.com/ajamaica/Solana.Swift)
2. [ED25519 Swift Encryption Library](https://github.com/pebble8888/ed25519swift)
