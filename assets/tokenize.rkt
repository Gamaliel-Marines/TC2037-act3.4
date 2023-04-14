#lang racket

(require "./lists.rkt")
(require "./styles.rkt")

;; Le da un token a una linea
(define (tokenize-line line open-block-comentario)
    (define word '())
    (define list-line '())
    (define tokenized-line '())
    (define open-quotes #f)

    (define possible-line-comentario #f)
    (define open-line-comentario #f)

    ; Split the line into characters
    (define chars (regexp-split #px"" line))

     (for/last ([char chars])
      ; If no match is found in the last character, add the word to the list
      (when (and (eq? char (last chars)) (or open-line-comentario open-block-comentario))
        (set! list-line (append list-line (list word))))

      ; Match the character with the regular expressions
      (cond 
        [open-block-comentario (set! word (append word (list char)))]

        [(regexp-match #rx"#" char) (set! word (append word (list char)))]

        [(regexp-match? #rx"[a-zA-Z0-9_]" char)
         (set! word (append word (list char)))]

        ; Match for line comentarios
        [(regexp-match #px"/" char) 
          (cond 
            [possible-line-comentario 
              ((lambda () 
                (set! possible-line-comentario #f)
                (set! open-line-comentario #t)
                (set! word (append word (list char)))))]
            [else 
              ((lambda () 
                (set! possible-line-comentario #t)
                (set! word (append word (list char)))))])]

        [open-line-comentario (set! word (append word (list char)))]

        ; Match for strings
        [(regexp-match? #px"\"" char)
         (cond
           [open-quotes 
            ((lambda ()
               (set! open-quotes #f)
               (set! word (append word (list char)))
               (set! list-line (append list-line (list word)))
               (set! word '())))]
            [else ((lambda () 
              (set! open-quotes #t)
              (set! word (append word (list char)))))])]

        [open-quotes (set! word (append word (list char)))]

        ; Match for operadores
        [(regexp-match? #px"[\\.\\,\\;\\(\\)\\{\\}\\[\\]\\=\\+\\-\\*\\/\\%\\>\\<\\:]" char)
         ((lambda ()
            (set! list-line (append list-line (list word)))
            (set! word '())
            (set! word (append word (list char)))
            (set! list-line (append list-line (list word)))
            (set! word '())))]

        ; Match for any other character
        [else
         ((lambda ()
            (set! list-line (append list-line (list word)))
            (set! word '())))])
    )

    (define tokens (map (lambda (x) (string-join x "")) list-line))

    (for ([token tokens])
        (define token-type (classify-token token))
        (when open-block-comentario (set! token-type "comentario"))
        (if token-type
            (set! tokenized-line (append tokenized-line 
                                 (list (highlight-token token token-type))))
            (set! tokenized-line (append tokenized-line (list token)))
        )
    )

    tokenized-line
)

(provide tokenize-line)
