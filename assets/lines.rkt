#lang racket

(define (run-lines input-lines open-block-comentario output-port tokenize-line)
    (for-each (lambda (line)
        (write-string (string-append "<pre>") output-port)

        (when (not open-block-comentario) 
            (set! open-block-comentario (regexp-match? #px"/\\*" line)))
            
        (define tokens (tokenize-line line open-block-comentario))
        (define formatted-line (string-join tokens " "))

        (when open-block-comentario
            (set! open-block-comentario (not (regexp-match? #px"\\*/" line))))

        (write-string (string-append formatted-line " ") output-port)
        (write-string (string-append "</pre>\n") output-port))
    input-lines)
)

(provide run-lines)
