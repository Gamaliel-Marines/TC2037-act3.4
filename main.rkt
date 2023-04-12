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
