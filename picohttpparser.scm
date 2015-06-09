;;;
;;; picohttpparser
;;;

(define-module picohttpparser
  (use gauche.uvector)
  (use gauche.parameter)
  (export <phr-request>
          phr-parse-request
          <phr-response>
          phr-parse-response
          phr-max-num-headers
          )
  )
(select-module picohttpparser)

;; Loads extension
(dynamic-load "picohttpparser")

;;
;; Put your Scheme definitions here
;;

(define phr-max-num-headers (make-parameter 100))

(define (phr-parse-request buf :optional (len (u8vector-length buf)) (last-len 0) (max-num-headers (phr-max-num-headers)))
  (%phr-parse-request buf len last-len max-num-headers))

(define (phr-parse-response buf :optional (len (u8vector-length buf)) (last-len 0) (max-num-headers (phr-max-num-headers)))
  (%phr-parse-response buf len last-len max-num-headers))
