// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract CredentialVerification {
    struct Credential {
        string credentialHash;
        address issuer;
        bool verified;
    }

    mapping(address => Credential[]) public credentials;

    event CredentialAdded(address indexed user, string credentialHash);
    event CredentialVerified(address indexed user, string credentialHash);

    function addCredential(string memory _credentialHash) public {
        credentials[msg.sender].push(Credential({
            credentialHash: _credentialHash,
            issuer: msg.sender,
            verified: false
        }));
        emit CredentialAdded(msg.sender, _credentialHash);
    }

    function verifyCredential(address _user, string memory _credentialHash) public {
        Credential[] storage userCredentials = credentials[_user];
        for (uint i = 0; i < userCredentials.length; i++) {
            if (keccak256(abi.encodePacked(userCredentials[i].credentialHash)) == keccak256(abi.encodePacked(_credentialHash))) {
                userCredentials[i].verified = true;
                emit CredentialVerified(_user, _credentialHash);
                break;
            }
        }
    }

    function isCredentialVerified(address _user, string memory _credentialHash) public view returns (bool) {
        Credential[] storage userCredentials = credentials[_user];
        for (uint i = 0; i < userCredentials.length; i++) {
            if (keccak256(abi.encodePacked(userCredentials[i].credentialHash)) == keccak256(abi.encodePacked(_credentialHash))) {
                return userCredentials[i].verified;
            }
        }
        return false;
    }
}
