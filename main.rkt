;;Gamaliel Marines Olvera

#lang racket

;; Librerias
(require racket/string)
(require racket/match)
(require racket/file)
(require racket/hash)

;; Lo que hace es abrir y leer un archivo
(define (read-file file-name)
    (open-input-file file-name)
)


;; Definir en una lista las palabras reservadas de C#
(define palabrasClave
  (list 
    "abstract" "as" "base" "bool" "break" "byte" "case" "catch" "char" "checked" "class" "const" "continue" "decimal" "default" "delegate" "do" "double" "else" "endif" "enum" "event" "explicit" "extern" "false" "finally" "fixed" "float" "for" "foreach" "goto" "if" "implicit" "in" "int" "interface" "internal" "is" "lock" "long" "namespace" "new" "null" "object" "operador" "out" "override" "params" "private" "protected" "public" "readonly" "ref" "return" "sbyte" "sealed" "short" "sizeof" "stackalloc" "static" "string" "struct" "switch" "this" "throw" "true" "try" "typeof" "uint" "ulong" "unchecked" "unsafe" "ushort" "using" "virtual" "void" "volatile" "while" "#if" "#endif" "#else"
   )
)

;; Definir en una lista los operadores de C#
(define operadores
    (list
        "+" "-" "*" "/" "%" "^" "&" "|" "~" "!" "=" "<" ">" "?" ":" ";" "," "." "++" "--" "&&" "||" "==" "!=" "<=" ">=" "+=" "-=" "*=" "/=" "%=" "^=" "&=" "|=" "<<=" ">>=" "=>" "??"
    )
)

;; Definir en una lista los delimitadores de C#
(define delimitadores
    (list
        "(" ")" "{" "}" "[" "]"
    )
)

;; Definir los colores para el resaltador
(define colores
    (hash 
    "palabraClave" "palabraClave"
    "operador" "operador"
    "delimitador" "delimitador"
    "comentario" "comentario"
    "string" "string"
    "numero" "numero"
    "identificador" "identificador"
    )
)

;; Definir la funcion que sirve para asignar tokens dependiendo el tipo
(define (classify-token token)
    (cond
        [(regexp-match #rx"//." token) "comentario"]
        [(regexp-match #rx"/*.*/" token) "comentario"]
        [(member token operadores) "operador"]
        [(member token palabrasClave) "palabraClave"]
        [(member token delimitadores) "delimitador"]
        [(regexp-match? #rx"^\".*\"$" token) "string"]
        [(regexp-match? #rx"^[0-9x]+$" token) "numero"]
        [(regexp-match? #rx"^[a-zA-Z_][a-zA-Z0-9_]*$" token) "identificador"]
        [else #f]
    )
)

;; Definir funcion que asigna un color dependiendo el tokrn
(define (highlight-token token token-type)
    (cond
        [(equal? token-type "palabraClave") 
            (string-append "<span class=\""
            (hash-ref colores "palabraClave") "\">" token "</span>")]

        [(equal? token-type "operador") 
            (string-append "<span class=\""
            (hash-ref colores "operador") "\">" token "</span>")]

        [(equal? token-type "delimitador") 
            (string-append "<span class=\""
            (hash-ref colores "delimitador") "\">" token "</span>")]

        [(equal? token-type "comentario") 
            (string-append "<span class=\""
            (hash-ref colores "comentario") "\">" token "</span>")]
            
        [(equal? token-type "string") 
            (string-append "<span class=\""
            (hash-ref colores "string") "\">" token "</span>")]

        [(equal? token-type "numero") 
            (string-append "<span class=\""
            (hash-ref colores "numero") "\">" token "</span>")]

        [(equal? token-type "identificador") 
            (string-append "<span class=\""
            (hash-ref colores "identificador") "\">" token "</span>")]

        [else token]
    )
)

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

;; Le da un token a un archivo
(define (tokenize-file file-name)
    (let ((in-port (read-file file-name)))
        (let loop ((tokens '()))

        (let ((line (read-line in-port)))
            (if (eof-object? line)
                (reverse tokens)
                (loop (append tokens (tokenize-line line))))
            )
        )
    )
)

;; Escribe las lineas en un archivo
(define (write-file file-name lines)
    (define out (open-output-file file-name))

    (for ([line lines])
        (displayln line out)
    )

    (close-output-port out)
)

;; Definir la funcion main con sus parametros
;; Los parametros input-file y output-file
;; Son para los archivos que se van a abrir y crear
(define (main input-file output-file)
  (define input-lines (file->lines input-file))
  (define output-port (open-output-file output-file))
  (define html-header "<html><head><title>Resaltador</title><link rel='stylesheet' href='./style.css' type='text/css' /></head><body>")
  (define html-footer "</body></html>")
  (write-string html-header output-port)

  (define open-block-comentario #f)

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
  
  (write-string html-footer output-port)
  (close-output-port output-port))


;; se manda a llamar la Funcion main
;; los parametros son los nombres de los archivos
;; que se va a abriri y leer y del que se va a crear
(main "TestFile.cs" "TestFileHTML.html")