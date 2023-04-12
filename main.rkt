;; main.rkt
;; Gamaliel Marines Olvera A01708746
;; Rodrigo Teran
;; Diego Perdomo

#lang racket

;; Librerias del programa
(require racket/string)
(require racket/match)
(require racket/file)
(require racket/hash)

;; Lee un archivo y devuelve una lista de lineas
;; resive como parametro el nombre del archivo que lee
(define (read-file file-name)
    (open-input-file file-name)
)


;; Definir palabras clave (en orden alfabetico)
(define keywords
  (list 
    "abstract" "as" "base" "bool" "break" "byte" "case" "catch" "char" "checked" "class" "const" "continue" "decimal" "default" "delegate" "do" "double" "else" "endif" "enum" "event" "explicit" "extern" "false" "finally" "fixed" "float" "for" "foreach" "goto" "if" "implicit" "in" "int" "interface" "internal" "is" "lock" "long" "namespace" "new" "null" "object" "operator" "out" "override" "params" "private" "protected" "public" "readonly" "ref" "return" "sbyte" "sealed" "short" "sizeof" "stackalloc" "static" "string" "struct" "switch" "this" "throw" "true" "try" "typeof" "uint" "ulong" "unchecked" "unsafe" "ushort" "using" "virtual" "void" "volatile" "while" "#if" "#endif" "#else"
   )
)


;; Definir los operadores
(define operators
    (list
        "+" "-" "*" "/" "%" "^" "&" "|" "~" "!" "=" "<" ">" "?" ":" ";" "," "." "++" "--" "&&" "||" "==" "!=" "<=" ">=" "+=" "-=" "*=" "/=" "%=" "^=" "&=" "|=" "<<=" ">>=" "=>" "??"
    )
)

;; Definir los delimitadores
(define delimiters
    (list
        "(" ")" "{" "}" "[" "]"
    )
)

;; Definir la funcion main con los parametros "input-file" y "output-file" 
;;  input-file es el archivo que va a leer y output-file el que va a escribir
(define (main input-file output-file)
  (define input-lines (file->lines input-file))
  (define output-port (open-output-file output-file))
  (define html-header "<html><head><title>Resaltador de sintaxis</title> <link rel='stylesheet' href='./style.css' type='text/css' /></head><body>")
  (define html-footer "</body></html>")
  (write-string html-header output-port)

  (define open-block-comment #f)

  (for-each (lambda (line)
              (write-string (string-append "<pre>") output-port)

              (when (not open-block-comment) 
                  (set! open-block-comment (regexp-match? #px"/\\*" line)))
                  
              (define tokens (tokenize-line line open-block-comment))
              (define formatted-line (string-join tokens " "))

              (when open-block-comment
                  (set! open-block-comment (not (regexp-match? #px"\\*/" line))))

              (write-string (string-append formatted-line " ") output-port)
              (write-string (string-append "</pre>\n") output-port))
            input-lines)
  
  (write-string html-footer output-port)
  (close-output-port output-port))


;; se manda a llamar a la funcion main
;; en los parametros se ingresan los nombres de los archivos
(main "TestFile.cs" "TestFileHTML.html")