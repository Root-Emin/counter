;; On-chain counter with multiple enhanced features

(define-map counters principal uint)

(define-read-only (get-count (who principal))
  (default-to u0 (map-get? counters who))
)

(define-public (count-up)
  (ok (map-set counters tx-sender (+ (get-count tx-sender) u1)))
)

(define-public (count-down)
  (let ((current (get-count tx-sender)))
    (if (>= current u1)
        (ok (map-set counters tx-sender (- current u1)))
        (err u100) ;; Sayaç 0'dan küçük olamaz
    )
  )
)

(define-public (reset-count)
  (ok (map-set counters tx-sender u0))
)

(define-public (set-count (new-count uint))
  (ok (map-set counters tx-sender new-count))
)

(define-read-only (get-count-for (user principal))
  (default-to u0 (map-get? counters user))
)

(define-public (transfer-count (to principal) (amount uint))
  (let ((sender-count (get-count tx-sender)))
    (if (>= sender-count amount)
        (begin
          (map-set counters tx-sender (- sender-count amount))
          (map-set counters to (+ (get-count to) amount))
          (ok true))
        (err u101) ;; Yetersiz bakiye
    )
  )
)
