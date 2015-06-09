;;;
;;; Test picohttpparser
;;;

(use gauche.test)
(use gauche.uvector :only (string->u8vector))

(test-start "picohttpparser")
(use picohttpparser)
(test-module 'picohttpparser)

(define *request* (undefined))
(define *response* (undefined))

(test-section "phr-parse-request")
(test* "phr-parse-request" #t
  (begin
    (set! *request*
      ($ phr-parse-request $ string->u8vector
       "GET / HTTP/1.1\r\n\
        Host: localhost:4567\r\n\
        Connection: keep-alive\r\n\
        Cache-Control: max-age=0\r\n\
        Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8\r\n\
        User-Agent: Mozilla/5.0 (X11; Linux i686) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.81 Safari/537.36\r\n\
        Accept-Encoding: gzip, deflate, sdch\r\n\
        Accept-Language: en-US,en;q=0.8,ja;q=0.6\r\n\r\n"))
    (is-a? *request* <phr-request>)))
(test* "phr-parse-request (method)" "GET" (~ *request*'method))
(test* "phr-parse-request (path)" "/" (~ *request*'path))
(test* "phr-parse-request (minor-version)" 1 (~ *request*'minor-version))
(test* "phr-parse-request (incomplete)" #f (phr-parse-request (string->u8vector "GET")))
(test* "phr-parse-request (error)" "parse error"
  (guard (e (else (~ e'message)))
    (phr-parse-response (string->u8vector "Host"))
    #f))

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
