
(define type-p-name-alist
  `((,boolean? . "boolean")
    (,char? . "character")
    (,number? . "number")
    (,pair? . "pair")
    (,port? . "port")
    (,procedure? . "procedure")
    (,string? . "string")
    (,symbol? . "symbol")
    (,vector? . "vector")))
(define (_ x) x)

(define (ly:error msg . rest)
  (display (apply format (cons #f (cons msg rest))))
  (exit)
  )

(use-modules (ice-9 optargs))


(define-public (type-name predicate)
  (let ((entry (assoc predicate type-p-name-alist)))
    (if (pair? entry) (cdr entry)
        (string-trim-right
         (symbol->string (procedure-name predicate))
         #\?))))

(define (markup-argument-list-error signature arguments number)
  "return (ARG-NR TYPE-EXPECTED ARG-FOUND) if an error is detected, or
#f is no error found.
"
  (if (and (pair? signature) (pair? arguments))
      (if (not ((car signature) (car arguments)))
          (list number (type-name (car signature)) (car arguments))
          (markup-argument-list-error (cdr signature) (cdr arguments) (+ 1 number)))
      #f))

(define-public markup-command-signature (make-object-property))

(define-public markup-function-category (make-object-property))
;; markup function -> used properties
(define-public markup-function-properties (make-object-property))


(define (make-markup markup-function make-name args)
  " Construct a markup object from MARKUP-FUNCTION and ARGS. Typecheck
against signature, reporting MAKE-NAME as the user-invoked function.
"
  (let* ((arglen (length args))
         (signature (or (markup-command-signature markup-function)
                        (ly:error (_ "~A: Not a markup (list) function: ~S")
                                  make-name markup-function)))
         (siglen (length signature))
         (error-msg (if (and (> siglen 0) (> arglen 0))
                        (markup-argument-list-error signature args 1)
                        #f)))
    (if (or (not (= arglen siglen)) (< siglen 0) (< arglen 0))
        (ly:error (_ "~A: Wrong number of arguments.  Expect: ~A, found ~A: ~S")
                  make-name siglen arglen args))
    (if error-msg
        (ly:error
         (_ "~A: Invalid argument in position ~A.  Expect: ~A, found: ~S.")
         make-name (car error-msg) (cadr error-msg)(caddr error-msg))
        (cons markup-function args))))

(defmacro*-public markup-lambda
  (args signature
        #:key (category '()) (properties '())
        #:rest body)
  "Defines and returns an anonymous markup command.  Other than
not registering the markup command, this is identical to
`define-markup-command`"
  (while (and (pair? body) (keyword? (car body)))
         (set! body (cddr body)))
     ;; define the COMMAND-markup function
  (let* ((documentation
          (format #f "~a\n~a" (cddr args)
                  (if (string? (car body)) (car body) "")))
         (real-body (if (or (not (string? (car body)))
                            (null? (cdr body)))
                        body (cdr body)))
         (result
          `(lambda ,args
             ,documentation
             (let ,(map (lambda (prop-spec)
                          (let ((prop (car prop-spec))
                                (default-value (and (pair? (cdr prop-spec))
                                                    (cadr prop-spec)))
                                (props (cadr args)))
                            `(,prop (chain-assoc-get ',prop ,props ,default-value))))
                        (filter pair? properties))
               ,@real-body))))
    (define (markup-lambda-worker command signature properties category)
      (set! (markup-command-signature command) signature)
      ;; Register the new function, for markup documentation
      (set! (markup-function-category command) category)
      ;; Used properties, for markup documentation
      (set! (markup-function-properties command) properties)
      command)
    `(,markup-lambda-worker
      ,result
      (list ,@signature)
      (list ,@(map (lambda (prop-spec)
                     (cond ((symbol? prop-spec)
                            prop-spec)
                           ((not (null? (cdr prop-spec)))
                            `(list ',(car prop-spec) ,(cadr prop-spec)))
                           (else
                            `(list ',(car prop-spec)))))
                   properties))
      ',category)))


(define (define-markup-command-internal-runtime command definition is-list)
  (let* ((suffix (if is-list "-list" ""))
         (command-name (string->symbol (format #f "~a-markup~a" command suffix)))
         (make-markup-name (string->symbol (format #f "make-~a-markup~a" command suffix))))
    (if (not (procedure-name definition))
        (set-procedure-property! definition 'name command-name))
    (module-define! (current-module) command-name definition)
    (module-define! (current-module) make-markup-name
                    (lambda args
                      (if is-list
                          (list (make-markup definition make-markup-name args))
                          (make-markup definition make-markup-name args))))
    (module-export! (current-module)
                    (list command-name make-markup-name ))))


(defmacro-public define-markup-command (command-and-args . definition)
  (let* ((command (car command-and-args))
         (args (cdr command-and-args)))
    (write (list command-and-args))
    (newline)
    (write (list definition))
    (newline)
    `(,define-markup-command-internal-runtime
           ',command (markup-lambda ,args ,@definition) #f)))

(define-markup-command (musicglyph layout props glyph-name)
  (string?)
  #:category music
  42
  glyph-name)

(quote (define-markup-command (noarg layout props)
  ()
  #:category music
  43
  "noarg"))


(write (make-musicglyph-markup "name"))
(newline)
;(write (make-noarg-markup))
;(newline)
