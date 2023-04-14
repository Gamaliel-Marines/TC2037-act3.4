#lang racket

;; Definir funcion que asigna un color dependiendo del token
(define (highlight-token token token-type)
    (cond
        [(equal? token-type "palabraClave") (string-append "<span class='palabraClave'>" token "</span>")]
        [(equal? token-type "operador") (string-append "<span class='operador'>" token "</span>")]
        [(equal? token-type "delimitador") (string-append "<span class='delimitador'>" token "</span>")]
        [(equal? token-type "comentario") (string-append "<span class='comentario'>" token "</span>")]
        [(equal? token-type "string") (string-append "<span class='string'>" token "</span>")]
        [(equal? token-type "numero") (string-append "<span class='numero'>" token "</span>")]
        [(equal? token-type "identificador") (string-append "<span class='identificador'>" token "</span>")]
        [else token]
    )
)

(provide highlight-token)
