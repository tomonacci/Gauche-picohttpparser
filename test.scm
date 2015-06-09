;;;
;;; Test picohttpparser
;;;

(use file.util)
(use gauche.test)
(use gauche.uvector)

(test-start "picohttpparser")
(use picohttpparser)
(test-module 'picohttpparser)

(test* "phr-parse-request" #t
  (let1 request (phr-parse-request (string->u8vector (file->string "request.txt")))
    ;(set! (ref request'method) "POST")
    ;(print (ref request'method))
    (and (is-a? request <phr-request>) (equal? (ref request'method) "GET") (equal? (ref request'path) "/") (equal? (ref request'minor-version) 1))
    ))
(test* "phr-parse-request" #f (phr-parse-request (string->u8vector "")))

;; If you don't want `gosh' to exit with nonzero status even if
;; the test fails, pass #f to :exit-on-failure.
(test-end :exit-on-failure #t)
