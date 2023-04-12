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

;; Definir header HTML
(define headerHTML(list "<!DOCTYPE html>"
        "<html>"
        "<head>"
            "<meta charset=\"UTF-8\">"
            "<style>"
                   "body{ white-space: pre; font-family: Courier New; font-size: 14px }"
                   "h3{ text-align: center }"
                   ".center { display: block; margin-left: auto; margin-right: auto; width: 75px; height: 75px ;}"
                   ".numero{ color: orange; }"
                   ".booleano{ color: red; }"
                   ".condicional{ color: magenta; }"
                   ".extra{ color: hotpink; }"
                   ".operador{ color: blue; }"
                   ".header{ color: YellowGreen; }"
            "</style>"
            "<title>Resaltador de sintaxis</title>"
        "</head>"
        "<body>"
            "<img src=https://m.media-amazon.com/images/I/91-Db4L6xjL.png alt=boom class=center>"
            "<h3> Resaltador de Sintaxis</h3>"
            "<br>"))

; Lista del Cierre HTML del archivo de Salida
(define finalHTML(list "</body>"
        "</html>"))
