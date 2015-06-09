;;;
;;; picohttpparser
;;;

(define-module picohttpparser
  (use gauche.uvector)
  (export <phr-request>
          phr-parse-request
          <phr-response>
          phr-parse-response
          )
  )
(select-module picohttpparser)

;; Loads extension
(dynamic-load "picohttpparser")

;;
;; Put your Scheme definitions here
;;



