;;;
;;; picohttpparser
;;;

(define-module picohttpparser
  (use gauche.uvector)
  (export EV_READ EV_WRITE
          <ev-loop>
          <ev-io-watcher>
          ev-default-loop
          ev-loop-new
          ev-io-new
          ev-io-init
          ev-io-start
          ev-io-stop
          ev-run
          <phr-request>
          phr-parse-request
          )
  )
(select-module picohttpparser)

;; Loads extension
(dynamic-load "picohttpparser")

;;
;; Put your Scheme definitions here
;;



