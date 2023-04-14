;; Gamaliel Marines Olvera
;; Rodrigo Terán Hernánde
;; Diego Perdomo Salcedo

#lang racket

;; Librerías
(require racket/string)
(require racket/match)
(require racket/file)
(require "assets/html.rkt")
(require "assets/lines.rkt")
(require "assets/tokenize.rkt")

;; Definir la funcion main con sus parametros
;; Los parametros input-file y output-file
;; Son para los archivos que se van a abrir y crear
(define (main input-file output-file)
    (define input-lines (file->lines input-file))

    ;; Flag #:exists reemplaza el archivo si ya existe
    (define output-port (open-output-file output-file #:exists 'replace))
    (write-string html-header output-port)

    (define open-block-comentario #f)

    (run-lines input-lines open-block-comentario output-port tokenize-line)

    (write-string html-footer output-port)
    (close-output-port output-port))


;; se manda a llamar la Funcion main
;; los parametros son los nombres de los archivos
;; que se va a abriri y leer y del que se va a crear
(main "TestFile.cs" "TestFileHTML.html")