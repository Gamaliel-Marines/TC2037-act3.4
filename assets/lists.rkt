#lang racket

;; Definir en una lista las palabras reservadas de C#
(define palabrasClave
  (list 
        "abstract"
        "as"
        "base"
        "bool"
        "break"
        "byte"
        "case"
        "catch"
        "char"
        "checked"
        "class"
        "const"
        "continue"
        "decimal"
        "default"
        "delegate"
        "do"
        "double"
        "else"
        "endif"
        "enum"
        "event"
        "explicit"
        "extern"
        "false"
        "finally"
        "fixed"
        "float"
        "for"
        "foreach"
        "goto"
        "if"
        "implicit"
        "in"
        "int"
        "interface"
        "internal"
        "is"
        "lock"
        "long"
        "namespace"
        "new"
        "null"
        "object"
        "operador"
        "out"
        "override"
        "params"
        "private"
        "protected"
        "public"
        "readonly"
        "ref"
        "return"
        "sbyte"
        "sealed"
        "short"
        "sizeof"
        "stackalloc"
        "static"
        "string"
        "struct"
        "switch"
        "this"
        "throw"
        "true"
        "try"
        "typeof"
        "uint"
        "ulong"
        "unchecked"
        "unsafe"
        "ushort"
        "using"
        "virtual"
        "void"
        "volatile"
        "while"
        "#if"
        "#endif"
        "#else"
   )
)

;; Definir en una lista los operadores de C#
(define operadores
    (list
        "+"
        "-"
        "*"
        "/"
        "%"
        "^"
        "&"
        "|"
        "~"
        "!"
        "="
        "<"
        ">"
        "?"
        ":"
        ";"
        ","
        "."
        "++"
        "--"
        "&&"
        "||"
        "=="
        "!="
        "<="
        ">="
        "+="
        "-="
        "*="
        "/="
        "%="
        "^="
        "&="
        "|="
        "<<="
        ">>="
        "=>"
        "??"
    )
)

;; Definir en una lista los delimitadores de C#
(define delimitadores
    (list
        "("
        ")"
        "{"
        "}"
        "["
        "]"
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

(provide palabrasClave)
(provide operadores)
(provide delimitadores)
(provide classify-token)
