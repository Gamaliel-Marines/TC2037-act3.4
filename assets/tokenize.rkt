#lang racket

(require "./lists.rkt")
(require "./styles.rkt")

;; Le da un token a una linea
(define (tokenize-line line open-block-comentario)
    ;; Primero definimos estas variables
    (define word 
      '()
    )
    (define list-line
      '()
    )
    (define tokenized-line
      '()
    )

    ;; Las ponemos como falso
    (define open-quotes #f)
    (define possible-line-comentario #f)
    (define open-line-comentario #f)

    ; Split the line into characters
    (define chars
      (regexp-split #px"" line)
    )

     (for/last ([char chars])
      ;; Si no hay ningún match en el último caracter entoncer simplemente se añade
      ;; la palabra a la lista
      (when
        (and
          (eq? char (last chars))
          (or open-line-comentario open-block-comentario)
        )
        (set! list-line 
          (append list-line
            (list word)
          )
        )
      )

      ;; Aquí se hace match con la expresión regular
      (cond 
        [open-block-comentario
          (set! word
            (append word (list char))
          )
        ]

        [
          ;; Se añade la palabra a la lista
          (regexp-match #rx"#" char)
          (set! word (append word (list char)))
        ]

        [
          ;; Se añade la palabra a la lista
          (regexp-match? #rx"[a-zA-Z0-9_]" char)
          (set! word (append word (list char)))
        ]

        ;; Este es el match para los comentarios
        [
          (regexp-match #px"/" char) 
          (cond 
            ;; Si es un posible comentario las variables se establecen en falso,
            ;; Y se añade la palabra a la lista
            [possible-line-comentario 
              ((lambda () 
                (set! possible-line-comentario #f)
                (set! open-line-comentario #t)
                (set! word (append word (list char))))
              )
            ]
            [else
              ;; Se pone la variable de posible comentario como verdadera
              ;; Y se añade la palabra a la lista
              ((lambda () 
                (set! possible-line-comentario #t)
                (set! word (append word (list char))))
              )
            ]
          )
        ]

        [open-line-comentario
          (set! word
            (append word (list char))
          )
        ]

        ;; Este es el match para los strings
        [
          (regexp-match? #px"\"" char)
          (cond
            [open-quotes 
              ((lambda ()
                ;; Se añade la palabra a la lista
                (set! open-quotes #f)
                (set! word (append word (list char)))
                (set! list-line (append list-line (list word)))
                (set! word '())))
            ]
            [else
              ((lambda () 
                ;; Se añade la palabra a la lista
                (set! open-quotes #t)
                (set! word (append word (list char)))))
            ]
          )
        ]

        [open-quotes
          (set! word
            (append word (list char))
          )
        ]

        ;; Este es el match para los operadores
        [
          (regexp-match? #px"[\\.\\,\\;\\(\\)\\{\\}\\[\\]\\=\\+\\-\\*\\/\\%\\>\\<\\:]" char)
          ((lambda ()
            (set! list-line (append list-line (list word)))
            (set! word '())
            (set! word (append word (list char)))
            (set! list-line (append list-line (list word)))
            (set! word '()))
          )
        ]

        ;; Este es el match para cualquier otro caracter
        [else
          ((lambda ()
            (set! list-line (append list-line (list word)))
            (set! word '()))
          )
        ]
      )
    )

    ;; Aqui definimos los tokens
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

