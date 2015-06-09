;;;
;;; Test picohttpparser
;;;

(use file.util)
(use gauche.test)
(use gauche.uvector)

(test-start "picohttpparser")
(use picohttpparser)
(test-module 'picohttpparser)

(define *response* #f)

(test-section "phr-parse-request")
(test* "phr-parse-request" #t
  (let1 request (phr-parse-request (string->u8vector (file->string "request.txt")))
    ;(set! (ref request'method) "POST")
    ;(print (ref request'method))
    (and (is-a? request <phr-request>) (equal? (ref request'method) "GET") (equal? (ref request'path) "/") (equal? (ref request'minor-version) 1))
    ))
(test* "phr-parse-request" #f (phr-parse-request (string->u8vector "")))

(test-section "phr-parse-response")
(test* "phr-parse-response" #t
  (let* ((gmt (sys-gmtime 0))
         (date (sys-strftime "%a, %d %b %Y %H:%M:%S" gmt))
         (body "phr-parse-response"))
    (set! *response*
      ($ phr-parse-response $ string->u8vector
       #`"HTTP/1.1 200 OK\r\n\
          Connection: close\r\n\
          Date: ,date GMT\r\n\
          Content-Type: text/html\r\n\
          Content-Length: ,(string-size body)\r\n\r\n,body"))
    (is-a? *response* <phr-response>)))
(test* "phr-parse-response (minor-version)" 1 (~ *response*'minor-version))
(test* "phr-parse-response (status)" 200 (~ *response*'status))
(test* "phr-parse-response (msg)" "OK" (~ *response*'msg))
(test* "phr-parse-response (headers)"
  '(("Connection" . "close") ("Date" . "Thu, 01 Jan 1970 00:00:00 GMT") ("Content-Type" . "text/html") ("Content-Length" . "18"))
  (~ *response*'headers))
(test* "phr-parse-response (incomplete)" #f (phr-parse-response (string->u8vector "HTTP/1.1 200")))
(test* "phr-parse-response (error)" "parse error"
  (guard (e (else (~ e'message)))
    (phr-parse-response (string->u8vector "HTTP/1.1 OK"))
    #f))

;; If you don't want `gosh' to exit with nonzero status even if
;; the test fails, pass #f to :exit-on-failure.
(test-end :exit-on-failure #t)
