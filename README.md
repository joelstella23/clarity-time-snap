# TimeSnap NFT
A Clarity smart contract for creating time-limited digital collectibles on the Stacks blockchain.

## Features
- Mint time-limited NFTs with expiration dates
- Transfer NFTs between accounts
- Check NFT validity/expiration status
- View NFT metadata and ownership information
- Burn expired NFTs

## Setup and Installation
1. Clone the repository
2. Install Clarinet
3. Run `clarinet check` to verify contracts
4. Run `clarinet test` to execute test suite

## Usage Examples
```clarity
;; Mint a new TimeSnap NFT (expires in 30 days)
(contract-call? .time-snap mint-nft "My TimeSnap" u2592000 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM)

;; Transfer an NFT
(contract-call? .time-snap transfer-nft u1 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM 'ST2CY5V39NHDPWSXMW9QDT3HC3GD6Q6XX4CFRK9AG)

;; Check if NFT is expired
(contract-call? .time-snap is-expired? u1)
```

## Dependencies
- Clarity language
- Clarinet for testing and deployment
