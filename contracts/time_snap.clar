;; TimeSnap NFT Contract
(define-non-fungible-token time-snap uint)

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-token-expired (err u101))
(define-constant err-token-not-found (err u102))
(define-constant err-unauthorized (err u103))

;; Data Variables
(define-map token-metadata uint {
  name: (string-ascii 256),
  owner: principal,
  created-at: uint,
  expires-at: uint
})

(define-data-var token-id-nonce uint u0)

;; Internal Functions
(define-private (is-owner (token-id uint))
  (let ((token-data (unwrap! (map-get? token-metadata token-id) false)))
    (is-eq (get owner token-data) tx-sender)
  )
)

;; Public Functions
(define-public (mint-nft (name (string-ascii 256)) (duration uint) (recipient principal))
  (let (
    (new-id (+ (var-get token-id-nonce) u1))
    (block-height block-height)
  )
    (if (is-eq tx-sender contract-owner)
      (begin
        (try! (nft-mint? time-snap new-id recipient))
        (map-set token-metadata new-id {
          name: name,
          owner: recipient,
          created-at: block-height,
          expires-at: (+ block-height duration)
        })
        (var-set token-id-nonce new-id)
        (ok new-id)
      )
      err-owner-only
    )
  )
)

(define-public (transfer-nft (token-id uint) (sender principal) (recipient principal))
  (let ((token-data (unwrap! (map-get? token-metadata token-id) err-token-not-found)))
    (if (and
      (is-eq tx-sender sender)
      (< block-height (get expires-at token-data))
    )
      (begin
        (try! (nft-transfer? time-snap token-id sender recipient))
        (map-set token-metadata token-id
          (merge token-data { owner: recipient })
        )
        (ok true)
      )
      err-unauthorized
    )
  )
)

(define-public (burn-nft (token-id uint))
  (let ((token-data (unwrap! (map-get? token-metadata token-id) err-token-not-found)))
    (if (or
      (is-eq tx-sender contract-owner)
      (and (is-owner token-id) (>= block-height (get expires-at token-data)))
    )
      (begin
        (try! (nft-burn? time-snap token-id tx-sender))
        (map-delete token-metadata token-id)
        (ok true)
      )
      err-unauthorized
    )
  )
)

;; Read Only Functions
(define-read-only (get-token-data (token-id uint))
  (ok (map-get? token-metadata token-id))
)

(define-read-only (is-expired? (token-id uint))
  (let ((token-data (unwrap! (map-get? token-metadata token-id) err-token-not-found)))
    (ok (>= block-height (get expires-at token-data)))
  )
)
