; extends

(string
  (string_content) @injection.content
    (#vim-match? @injection.content "^\w*# py:.*$")
    (#set! injection.language "python"))
;
; (call
;   function: (attribute attribute: (identifier) @id (#eq? @id "execute|read_sql"))
;   arguments: (argument_list
;     (string (string_content) @injection.content (#set! injection.language "sql"))))


(assignment
  left: ((identifier) @id)
  right: (string
           (string_content) @injection.content)
  (#vim-match? @id "^.*_def$")
  (#set! injection.language "python")
  )

