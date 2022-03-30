# CustomAuthSolanaAdapter



#Installation

##Xcode Projects

`Select File -> Swift Packages -> Add Package Dependency` and enter `https://github.com/CypherPoet/MyLibraryName`.

##Swift Package Manager Projects
You can add CustomAuthSolanaAdapter as a package dependency in your Package.swift file:

let package = Package(
    //...
    dependencies: [
        .package(
            name: "MyPackageName",
            url: "https://github.com/CypherPoet/MyLibraryName",
            .exact("0.0.1")
        ),
    ],
    //...
)
From there, refer to the MyLibraryName "product" delivered by the MyPackageName "package" inside of any of your project's target dependencies:

targets: [
    .target(
        name: "YourLibrary",
        dependencies: [
            .product(
                name: "MyLibraryName",
                package: "MyPackageName"
            ),
        ],
        ...
    ),
    ...
]
Then simply import MyLibraryName wherever you’d like to use it.



Implementation:

1. Generate custom verifier config through Web3Auth dev console.
2. Install this package via SPM.
3. Use the `getTorusKeyAndGenerateSolanaKeyPair` method rather than the `getTorusKey` method when using a custom verifier.

Code Example:


