//===----------------------------------------------------------------------===//
//
// This source file is part of the WebAuthn Swift open source project
//
// Copyright (c) 2022 the WebAuthn Swift project authors
// Licensed under Apache License v2.0
//
// See LICENSE.txt for license information
// See CONTRIBUTORS.txt for the list of WebAuthn Swift project authors
//
// SPDX-License-Identifier: Apache-2.0
//
//===----------------------------------------------------------------------===//

import Foundation

/// The unprocessed response received from `navigator.credentials.get()`.
///
/// When decoding using `Decodable`, the `rawID` is decoded from base64url to bytes.
public struct AuthenticationCredential: Sendable {
    /// The credential ID of the newly created credential.
    public let id: URLEncodedBase64

    /// The raw credential ID of the newly created credential.
    public let rawID: [UInt8]

    /// The attestation response from the authenticator.
    public let response: AuthenticatorAssertionResponse

    /// Reports the authenticator attachment modality in effect at the time the navigator.credentials.create() or
    /// navigator.credentials.get() methods successfully complete
    public let authenticatorAttachment: AuthenticatorAttachment?

    /// Value will always be ``CredentialType/publicKey`` (for now)
    public let type: CredentialType

    public init(
        id: URLEncodedBase64,
        rawID: [UInt8],
        response: AuthenticatorAssertionResponse,
        authenticatorAttachment: AuthenticatorAttachment?,
        type: CredentialType
    ) {
        self.id = id
        self.rawID = rawID
        self.response = response
        self.authenticatorAttachment = authenticatorAttachment
        self.type = type
    }
}

extension AuthenticationCredential: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(URLEncodedBase64.self, forKey: .id)
        rawID = try container.decodeBytesFromURLEncodedBase64(forKey: .rawID)
        response = try container.decode(AuthenticatorAssertionResponse.self, forKey: .response)
        authenticatorAttachment = try container.decodeIfPresent(AuthenticatorAttachment.self, forKey: .authenticatorAttachment)
        type = try container.decode(CredentialType.self, forKey: .type)
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case rawID = "rawId"
        case response
        case authenticatorAttachment
        case type
    }
}
