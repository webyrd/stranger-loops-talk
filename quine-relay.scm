(load "faster-miniKanren/mk-vicare.scm")
(load "faster-miniKanren/mk.scm")
(load "faster-miniKanren/test-check.scm")

;;; WEB  15 Sept 02021
;;;
;;; May want the 'absento' equivalent of 'all-different'.  Could write
;;; this as a recursive relation in mk, but perhaps could be made more
;;; efficient by implementing directly in faster-miniKanren.

;;; Could have eval-expr-conso and eval-expr-listo share the same core
;;; interpreter, parameterized by the full eval-expr version to call
;;; recursively.


;; Ideas:

;; The staged (and unstaged) Scheme-in-mk interp, and the
;; Scheme-in-Scheme-in-mk interp, share the same underlying semantics.
;; Could I use this connection for synthesis?  For example, for
;; synthesizing parts of the Scheme-in-Scheme-in-mk interp?  Either
;; from examples, or using the Scheme-in-mk interp as an oracle?
;; Since the interpeters are written in different languages--one in
;; mk, one in Scheme--these are actually different synthesis problems.

;; Could I synthesize the Y or Z combinator using the big-step interp,
;; either by using (Y (Y x)) = (Y x), or by specifying a concrete 'x'
;; and input and output examples?

(define eval-conso
  (lambda (expr val)
    (eval-expr-conso expr '() val)))

(define eval-expr-conso
  (lambda (expr env val)
    (conde
      ((== `(quote ,val) expr)
       (absento 'closure val))
      ((symbolo expr) (lookupo expr env val))
      ((fresh (e1 e2 v1 v2)
         (== `(cons ,e1 ,e2) expr)
         (== `(,v1 . ,v2) val)
         (eval-expr-conso e1 env v1)
         (eval-expr-conso e2 env v2)))
      ((fresh (x body)
         (== `(lambda (,x) ,body) expr)
         (== `(closure ,x ,body ,env) val)
         (symbolo x)))
      ((fresh (e1 e2 x body env^ arg)
         (== `(,e1 ,e2) expr)
         (eval-expr-conso e1 env `(closure ,x ,body ,env^))
         (eval-expr-conso e2 env arg)
         (eval-expr-conso body `((,x . ,arg) . ,env^) val))))))


(define eval-listo
  (lambda (expr val)
    (eval-expr-listo expr '() val)))

(define eval-expr-listo
  (lambda (expr env val)
    (conde
      ((== `(quote ,val) expr)
       (absento 'closure val))
      ((symbolo expr) (lookupo expr env val))
      ((fresh (e*)
         (== `(list . ,e*) expr)
         (handle-listo e* env val)))
      ((fresh (x body)
         (== `(lambda (,x) ,body) expr)
         (== `(closure ,x ,body ,env) val)
         (symbolo x)))
      ((fresh (e1 e2 x body env^ arg)
         (== `(,e1 ,e2) expr)
         (eval-expr-listo e1 env `(closure ,x ,body ,env^))
         (eval-expr-listo e2 env arg)
         (eval-expr-listo body `((,x . ,arg) . ,env^) val))))))

(define handle-listo
  (lambda (e* env v*)
    (conde
      ((== '() e*) (== '() v*))
      ((fresh (e e-rest v v-rest)
         (== `(,e . ,e-rest) e*)
         (== `(,v . ,v-rest) v*)
         (eval-expr-listo e env v)
         (handle-listo e-rest env v-rest))))))


(define lookupo
  (lambda (x env val)
    (fresh (y v env^)
      (== `((,y . ,v) . ,env^) env)
      (conde
        ((== x y) (== v val))
        ((=/= x y) (lookupo x env^ val))))))


(define eval-quasi
  (lambda (expr val)
    (eval-expr-quasi expr '() val)))

(define eval-expr-quasi
  (lambda (expr env val)
    (conde
      ((== (list 'quote val) expr)
       (absento 'closure val))
      ((symbolo expr) (lookupo expr env val))
      ((fresh (qe)
         (== (list 'quasiquote qe) expr)
         (absento 'closure qe)
         (handle-quasiquote qe env val)))
      ((fresh (x body)
         (== `(lambda (,x) ,body) expr)
         (== `(closure ,x ,body ,env) val)
         (symbolo x)))
      ((fresh (e1 e2 x body env^ arg)
         (== (list e1 e2) expr)
         (eval-expr-quasi e1 env `(closure ,x ,body ,env^))
         (eval-expr-quasi e2 env arg)
         (eval-expr-quasi body `((,x . ,arg) . ,env^) val))))))

(define handle-quasiquote
  (lambda (qe env val)
    (conde
      ((symbolo qe) (== qe val))
      ((== '() qe) (== '() val))
      ((fresh (e)
         (== (list 'unquote e) qe)
         (eval-expr-quasi e env val)))
      ((fresh (a d v1 v2)
         (== (cons a d) qe)
         (=/= 'unquote a)
         (== (cons v1 v2) val)
         (handle-quasiquote a env v1)
         (handle-quasiquote d env v2))))))



(test "1"
  (run 1 (e) (eval-conso e e))
  '((((lambda (_.0)
        (cons _.0 (cons (cons 'quote (cons _.0 '())) '())))
      '(lambda (_.0)
         (cons _.0 (cons (cons 'quote (cons _.0 '())) '()))))
     (=/= ((_.0 closure)))
     (sym _.0))))

(test "2"
  (run 1 (e) (eval-listo e e))
  '((((lambda (_.0) (list _.0 (list 'quote _.0)))
      '(lambda (_.0) (list _.0 (list 'quote _.0))))
     (=/= ((_.0 closure)))
     (sym _.0))))

(test "3"
  (run 1 (e) (eval-quasi e e))
  '((((lambda (_.0) `(,_.0 ',_.0))
      '(lambda (_.0) `(,_.0 ',_.0)))
     (=/= ((_.0 closure)))
     (sym _.0))))



;; Boring twines with listo
(test "4"
  (run 1 (p q)
    (=/= p q)
    (eval-listo p q)
    (eval-listo q p))
  '((('((lambda (_.0)
          (list 'quote (list _.0 (list 'quote _.0))))
        '(lambda (_.0) (list 'quote (list _.0 (list 'quote _.0)))))
      ((lambda (_.0) (list 'quote (list _.0 (list 'quote _.0))))
       '(lambda (_.0) (list 'quote (list _.0 (list 'quote _.0))))))
     (=/= ((_.0 closure)))
     (sym _.0))))

;; Exciting twines, using absento trick!
(test "5"
  (run 1 (p q)
    (=/= p q)
    (absento p q)
    (absento q p)
    (eval-listo p q)
    (eval-listo q p))
  '((((list
       '(lambda (_.0)
          (list 'list _.0 (list 'quote (list 'quote _.0))))
       '''(lambda (_.0)
            (list 'list _.0 (list 'quote (list 'quote _.0)))))
      ((lambda (_.0)
         (list 'list _.0 (list 'quote (list 'quote _.0))))
       ''(lambda (_.0)
           (list 'list _.0 (list 'quote (list 'quote _.0))))))
     (=/= ((_.0 closure)))
     (sym _.0))))





;; We can simplify the exciting twines example.
;; Don't need the =/= if we use absento:
(test "6"
  (run 1 (p q)
    (absento p q)
    (absento q p)
    (eval-listo p q)
    (eval-listo q p))
  '((((list
       '(lambda (_.0)
          (list 'list _.0 (list 'quote (list 'quote _.0))))
       '''(lambda (_.0)
            (list 'list _.0 (list 'quote (list 'quote _.0)))))
      ((lambda (_.0)
         (list 'list _.0 (list 'quote (list 'quote _.0))))
       ''(lambda (_.0)
           (list 'list _.0 (list 'quote (list 'quote _.0))))))
     (=/= ((_.0 closure)))
     (sym _.0))))





;; Boring thrines with listo
(test "7"
  (run 1 (p q r)
    (=/= p q)
    (=/= p r)
    (=/= q r)
    (eval-listo p q)
    (eval-listo q r)
    (eval-listo r p))
  '(((''((lambda (_.0)
           (list 'quote (list 'quote (list _.0 (list 'quote _.0)))))
         '(lambda (_.0)
            (list 'quote (list 'quote (list _.0 (list 'quote _.0))))))
      '((lambda (_.0)
          (list 'quote (list 'quote (list _.0 (list 'quote _.0)))))
        '(lambda (_.0)
           (list 'quote (list 'quote (list _.0 (list 'quote _.0))))))
      ((lambda (_.0)
         (list 'quote (list 'quote (list _.0 (list 'quote _.0)))))
       '(lambda (_.0)
          (list 'quote (list 'quote (list _.0 (list 'quote _.0)))))))
     (=/= ((_.0 closure)))
     (sym _.0))))




;; Exciting thrines with listo
(test "8"
  (run 1 (p q r)
    (=/= p q)
    (=/= p r)
    (=/= q r)
    (absento p q)
    (absento q p)
    (absento p r)
    (absento r p)
    (absento q r)
    (absento r q)
    (eval-listo p q)
    (eval-listo q r)
    (eval-listo r p))
  '((((list
       'list
       ''(lambda (_.0)
           (list
            'list
            ''list
            _.0
            (list 'quote (list 'quote (list 'quote _.0)))))
       '''''(lambda (_.0)
              (list
               'list
               ''list
               _.0
               (list 'quote (list 'quote (list 'quote _.0))))))
      (list
       '(lambda (_.0)
          (list
           'list
           ''list
           _.0
           (list 'quote (list 'quote (list 'quote _.0)))))
       ''''(lambda (_.0)
             (list
              'list
              ''list
              _.0
              (list 'quote (list 'quote (list 'quote _.0))))))
      ((lambda (_.0)
         (list
          'list
          ''list
          _.0
          (list 'quote (list 'quote (list 'quote _.0)))))
       '''(lambda (_.0)
            (list
             'list
             ''list
             _.0
             (list 'quote (list 'quote (list 'quote _.0)))))))
     (=/= ((_.0 closure)))
     (sym _.0))))




;; Simplified exciting thrines, without the subsumed =/= constraints:
(test "9"
  (run 1 (p q r)
    (absento p q)
    (absento q p)
    (absento p r)
    (absento r p)
    (absento q r)
    (absento r q)
    (eval-listo p q)
    (eval-listo q r)
    (eval-listo r p))
  '((((list
       'list
       ''(lambda (_.0)
           (list
            'list
            ''list
            _.0
            (list 'quote (list 'quote (list 'quote _.0)))))
       '''''(lambda (_.0)
              (list
               'list
               ''list
               _.0
               (list 'quote (list 'quote (list 'quote _.0))))))
      (list
       '(lambda (_.0)
          (list
           'list
           ''list
           _.0
           (list 'quote (list 'quote (list 'quote _.0)))))
       ''''(lambda (_.0)
             (list
              'list
              ''list
              _.0
              (list 'quote (list 'quote (list 'quote _.0))))))
      ((lambda (_.0)
         (list
          'list
          ''list
          _.0
          (list 'quote (list 'quote (list 'quote _.0)))))
       '''(lambda (_.0)
            (list
             'list
             ''list
             _.0
             (list 'quote (list 'quote (list 'quote _.0)))))))
     (=/= ((_.0 closure)))
     (sym _.0))))





;; Further simplified exciting thrines
(test "10"
  (run 1 (p q r)
    (absento p (list q r))
    (absento q (list p r))
    (absento r (list p q))
    (eval-listo p q)
    (eval-listo q r)
    (eval-listo r p))
  '((((list
       'list
       ''(lambda (_.0)
           (list
            'list
            ''list
            _.0
            (list 'quote (list 'quote (list 'quote _.0)))))
       '''''(lambda (_.0)
              (list
               'list
               ''list
               _.0
               (list 'quote (list 'quote (list 'quote _.0))))))
      (list
       '(lambda (_.0)
          (list
           'list
           ''list
           _.0
           (list 'quote (list 'quote (list 'quote _.0)))))
       ''''(lambda (_.0)
             (list
              'list
              ''list
              _.0
              (list 'quote (list 'quote (list 'quote _.0))))))
      ((lambda (_.0)
         (list
          'list
          ''list
          _.0
          (list 'quote (list 'quote (list 'quote _.0)))))
       '''(lambda (_.0)
            (list
             'list
             ''list
             _.0
             (list 'quote (list 'quote (list 'quote _.0)))))))
     (=/= ((_.0 closure)))
     (sym _.0))))



;; This is what I was looking for!!
;; A proper (length 2) Quine relay!
;;
;; ce uses cons; all uses of list are quoted
;;
;; le uses list; all uses of cons are quoted
;;
;; absento is useful here
(test "11"
  (run 1 (ce le)
    (absento ce le)
    (absento le ce)
    (eval-conso ce le)
    (eval-listo le ce))
  '((((cons
       '(lambda (_.0)
          (list 'cons _.0 (list 'quote (list (list 'quote _.0)))))
       '(''(lambda (_.0)
             (list 'cons _.0 (list 'quote (list (list 'quote _.0)))))))
      ((lambda (_.0)
         (list 'cons _.0 (list 'quote (list (list 'quote _.0)))))
       ''(lambda (_.0)
           (list 'cons _.0 (list 'quote (list (list 'quote _.0)))))))
     (=/= ((_.0 closure)))
     (sym _.0))))

#|
;; The fourth answer to the run 4 version of the query is perhaps more interesting:

(((cons
      (cons
        'lambda
        '((_.0)
           (list
             'cons
             ((lambda (_.1) _.0) '_.2)
             (list 'quote (list (list 'quote _.0))))))
      '('(cons
           'lambda
           '((_.0)
              (list
                'cons
                ((lambda (_.1) _.0) '_.2)
                (list 'quote (list (list 'quote _.0))))))))
     ((lambda (_.0)
        (list
          'cons
          ((lambda (_.1) _.0) '_.2)
          (list 'quote (list (list 'quote _.0)))))
       '(cons
          'lambda
          '((_.0)
             (list
               'cons
               ((lambda (_.1) _.0) '_.2)
               (list 'quote (list (list 'quote _.0))))))))
    (=/= ((_.0 _.1)) ((_.0 closure)) ((_.1 closure)))
    (sym _.0 _.1)
    (absento (closure _.2)))
|#

;; Make it harder!
(test "12"
  (run 1 (ce1 ce2 le)
    (=/= ce1 ce2)
    (absento ce1 ce2)
    (absento ce1 le)
    (absento le ce1)
    (absento le ce2)
    (absento ce2 ce1)
    (absento ce2 le)
    (eval-conso ce1 le)
    (eval-listo le ce2)
    (eval-conso ce2 le))
  '((((cons
       'list
       '('(lambda (_.0)
            (cons
             'list
             (cons
              _.0
              (cons
               (cons 'quote (cons (cons 'quote (cons _.0 '())) '()))
               '()))))
         '''(lambda (_.0)
              (cons
               'list
               (cons
                _.0
                (cons
                 (cons 'quote (cons (cons 'quote (cons _.0 '())) '()))
                 '()))))))
      ((lambda (_.0)
         (cons
          'list
          (cons
           _.0
           (cons
            (cons 'quote (cons (cons 'quote (cons _.0 '())) '()))
            '()))))
       ''(lambda (_.0)
           (cons
            'list
            (cons
             _.0
             (cons
              (cons 'quote (cons (cons 'quote (cons _.0 '())) '()))
              '())))))
      (list
       '(lambda (_.0)
          (cons
           'list
           (cons
            _.0
            (cons
             (cons 'quote (cons (cons 'quote (cons _.0 '())) '()))
             '()))))
       '''(lambda (_.0)
            (cons
             'list
             (cons
              _.0
              (cons
               (cons 'quote (cons (cons 'quote (cons _.0 '())) '()))
               '()))))))
     (=/= ((_.0 closure)))
     (sym _.0))))





;; The 'make it harder' example, simplified
(test "13"
  (run 1 (ce1 ce2 le)
    (absento ce1 ce2)
    (absento ce1 le)
    (absento le ce1)
    (absento le ce2)
    (absento ce2 ce1)
    (absento ce2 le)
    (eval-conso ce1 le)
    (eval-listo le ce2)
    (eval-conso ce2 le))
  '((((cons
       'list
       '('(lambda (_.0)
            (cons
             'list
             (cons
              _.0
              (cons
               (cons 'quote (cons (cons 'quote (cons _.0 '())) '()))
               '()))))
         '''(lambda (_.0)
              (cons
               'list
               (cons
                _.0
                (cons
                 (cons 'quote (cons (cons 'quote (cons _.0 '())) '()))
                 '()))))))
      ((lambda (_.0)
         (cons
          'list
          (cons
           _.0
           (cons
            (cons 'quote (cons (cons 'quote (cons _.0 '())) '()))
            '()))))
       ''(lambda (_.0)
           (cons
            'list
            (cons
             _.0
             (cons
              (cons 'quote (cons (cons 'quote (cons _.0 '())) '()))
              '())))))
      (list
       '(lambda (_.0)
          (cons
           'list
           (cons
            _.0
            (cons
             (cons 'quote (cons (cons 'quote (cons _.0 '())) '()))
             '()))))
       '''(lambda (_.0)
            (cons
             'list
             (cons
              _.0
              (cons
               (cons 'quote (cons (cons 'quote (cons _.0 '())) '()))
               '()))))))
     (=/= ((_.0 closure)))
     (sym _.0))))

;; The 'make it harder' example, further simplified
(test "14"
  (run 1 (ce1 ce2 le)
    (absento ce1 (list ce2 le))
    (absento le (list ce1 ce2))
    (absento ce2 (list ce1 le))
    (eval-conso ce1 le)
    (eval-listo le ce2)
    (eval-conso ce2 le))
  '((((cons
       'list
       '('(lambda (_.0)
            (cons
             'list
             (cons
              _.0
              (cons
               (cons 'quote (cons (cons 'quote (cons _.0 '())) '()))
               '()))))
         '''(lambda (_.0)
              (cons
               'list
               (cons
                _.0
                (cons
                 (cons 'quote (cons (cons 'quote (cons _.0 '())) '()))
                 '()))))))
      ((lambda (_.0)
         (cons
          'list
          (cons
           _.0
           (cons
            (cons 'quote (cons (cons 'quote (cons _.0 '())) '()))
            '()))))
       ''(lambda (_.0)
           (cons
            'list
            (cons
             _.0
             (cons
              (cons 'quote (cons (cons 'quote (cons _.0 '())) '()))
              '())))))
      (list
       '(lambda (_.0)
          (cons
           'list
           (cons
            _.0
            (cons
             (cons 'quote (cons (cons 'quote (cons _.0 '())) '()))
             '()))))
       '''(lambda (_.0)
            (cons
             'list
             (cons
              _.0
              (cons
               (cons 'quote (cons (cons 'quote (cons _.0 '())) '()))
               '()))))))
     (=/= ((_.0 closure)))
     (sym _.0))))


;; Harder still!
;;; 99 seconds to run on Will's lappy
(test "15"
  (run 1 (ce1 ce2 le1 le2)
    (=/= ce1 ce2)
    (=/= le1 le2)
    (absento ce1 ce2)
    (absento ce1 le1)
    (absento ce1 le2)
    (absento le1 le2)
    (absento le1 ce1)
    (absento le1 ce2)
    (absento ce2 ce1)
    (absento ce2 le1)
    (absento ce2 le2)
    (absento le2 le1)
    (absento le2 ce1)
    (absento le2 ce2)
    (eval-conso ce1 le1)
    (eval-listo le1 ce2)
    (eval-conso ce2 le2)
    (eval-listo le2 ce1))
  '((((cons
       'list
       '('(lambda (_.0)
            (cons
             '(lambda (_.1)
                (list
                 'cons
                 ''list
                 (list
                  'quote
                  (list
                   _.1
                   (list
                    'quote
                    (list 'quote (list (list 'quote _.1))))))))
             _.0))
         ''(''(lambda (_.0)
                (cons
                 '(lambda (_.1)
                    (list
                     'cons
                     ''list
                     (list
                      'quote
                      (list
                       _.1
                       (list
                        'quote
                        (list 'quote (list (list 'quote _.1))))))))
                 _.0)))))
      ((lambda (_.0)
         (cons
          '(lambda (_.1)
             (list
              'cons
              ''list
              (list
               'quote
               (list
                _.1
                (list 'quote (list 'quote (list (list 'quote _.1))))))))
          _.0))
       '(''(lambda (_.0)
             (cons
              '(lambda (_.1)
                 (list
                  'cons
                  ''list
                  (list
                   'quote
                   (list
                    _.1
                    (list
                     'quote
                     (list 'quote (list (list 'quote _.1))))))))
              _.0))))
      (list
       '(lambda (_.0)
          (cons
           '(lambda (_.1)
              (list
               'cons
               ''list
               (list
                'quote
                (list
                 _.1
                 (list
                  'quote
                  (list 'quote (list (list 'quote _.1))))))))
           _.0))
       ''(''(lambda (_.0)
              (cons
               '(lambda (_.1)
                  (list
                   'cons
                   ''list
                   (list
                    'quote
                    (list
                     _.1
                     (list
                      'quote
                      (list 'quote (list (list 'quote _.1))))))))
               _.0))))
      ((lambda (_.1)
         (list
          'cons
          ''list
          (list
           'quote
           (list
            _.1
            (list 'quote (list 'quote (list (list 'quote _.1))))))))
       ''(lambda (_.0)
           (cons
            '(lambda (_.1)
               (list
                'cons
                ''list
                (list
                 'quote
                 (list
                  _.1
                  (list
                   'quote
                   (list 'quote (list (list 'quote _.1))))))))
            _.0))))
     (=/= ((_.0 closure)) ((_.1 closure)))
     (sym _.0 _.1))))





;; The 'harder still' example, simplified
(test "16"
  (run 1 (ce1 ce2 le1 le2)
    (absento ce1 ce2)
    (absento ce1 le1)
    (absento ce1 le2)
    (absento le1 le2)
    (absento le1 ce1)
    (absento le1 ce2)
    (absento ce2 ce1)
    (absento ce2 le1)
    (absento ce2 le2)
    (absento le2 le1)
    (absento le2 ce1)
    (absento le2 ce2)
    (eval-conso ce1 le1)
    (eval-listo le1 ce2)
    (eval-conso ce2 le2)
    (eval-listo le2 ce1))
  '((((cons
       'list
       '('(lambda (_.0)
            (cons
             '(lambda (_.1)
                (list
                 'cons
                 ''list
                 (list
                  'quote
                  (list
                   _.1
                   (list
                    'quote
                    (list 'quote (list (list 'quote _.1))))))))
             _.0))
         ''(''(lambda (_.0)
                (cons
                 '(lambda (_.1)
                    (list
                     'cons
                     ''list
                     (list
                      'quote
                      (list
                       _.1
                       (list
                        'quote
                        (list 'quote (list (list 'quote _.1))))))))
                 _.0)))))
      ((lambda (_.0)
         (cons
          '(lambda (_.1)
             (list
              'cons
              ''list
              (list
               'quote
               (list
                _.1
                (list 'quote (list 'quote (list (list 'quote _.1))))))))
          _.0))
       '(''(lambda (_.0)
             (cons
              '(lambda (_.1)
                 (list
                  'cons
                  ''list
                  (list
                   'quote
                   (list
                    _.1
                    (list
                     'quote
                     (list 'quote (list (list 'quote _.1))))))))
              _.0))))
      (list
       '(lambda (_.0)
          (cons
           '(lambda (_.1)
              (list
               'cons
               ''list
               (list
                'quote
                (list
                 _.1
                 (list
                  'quote
                  (list 'quote (list (list 'quote _.1))))))))
           _.0))
       ''(''(lambda (_.0)
              (cons
               '(lambda (_.1)
                  (list
                   'cons
                   ''list
                   (list
                    'quote
                    (list
                     _.1
                     (list
                      'quote
                      (list 'quote (list (list 'quote _.1))))))))
               _.0))))
      ((lambda (_.1)
         (list
          'cons
          ''list
          (list
           'quote
           (list
            _.1
            (list 'quote (list 'quote (list (list 'quote _.1))))))))
       ''(lambda (_.0)
           (cons
            '(lambda (_.1)
               (list
                'cons
                ''list
                (list
                 'quote
                 (list
                  _.1
                  (list
                   'quote
                   (list 'quote (list (list 'quote _.1))))))))
            _.0))))
     (=/= ((_.0 closure)) ((_.1 closure)))
     (sym _.0 _.1))))


;; The 'harder still' example, further simplified
(test "17"
  (run 1 (ce1 ce2 le1 le2)
    (absento ce1 (list ce2 le1 le2))
    (absento ce2 (list ce1 le1 le2))
    (absento le1 (list ce1 ce2 le2))
    (absento le2 (list ce1 ce2 le1))
    (eval-conso ce1 le1)
    (eval-listo le1 ce2)
    (eval-conso ce2 le2)
    (eval-listo le2 ce1))
  '((((cons
       'list
       '('(lambda (_.0)
            (cons
             '(lambda (_.1)
                (list
                 'cons
                 ''list
                 (list
                  'quote
                  (list
                   _.1
                   (list
                    'quote
                    (list 'quote (list (list 'quote _.1))))))))
             _.0))
         ''(''(lambda (_.0)
                (cons
                 '(lambda (_.1)
                    (list
                     'cons
                     ''list
                     (list
                      'quote
                      (list
                       _.1
                       (list
                        'quote
                        (list 'quote (list (list 'quote _.1))))))))
                 _.0)))))
      ((lambda (_.0)
         (cons
          '(lambda (_.1)
             (list
              'cons
              ''list
              (list
               'quote
               (list
                _.1
                (list 'quote (list 'quote (list (list 'quote _.1))))))))
          _.0))
       '(''(lambda (_.0)
             (cons
              '(lambda (_.1)
                 (list
                  'cons
                  ''list
                  (list
                   'quote
                   (list
                    _.1
                    (list
                     'quote
                     (list 'quote (list (list 'quote _.1))))))))
              _.0))))
      (list
       '(lambda (_.0)
          (cons
           '(lambda (_.1)
              (list
               'cons
               ''list
               (list
                'quote
                (list
                 _.1
                 (list
                  'quote
                  (list 'quote (list (list 'quote _.1))))))))
           _.0))
       ''(''(lambda (_.0)
              (cons
               '(lambda (_.1)
                  (list
                   'cons
                   ''list
                   (list
                    'quote
                    (list
                     _.1
                     (list
                      'quote
                      (list 'quote (list (list 'quote _.1))))))))
               _.0))))
      ((lambda (_.1)
         (list
          'cons
          ''list
          (list
           'quote
           (list
            _.1
            (list 'quote (list 'quote (list (list 'quote _.1))))))))
       ''(lambda (_.0)
           (cons
            '(lambda (_.1)
               (list
                'cons
                ''list
                (list
                 'quote
                 (list
                  _.1
                  (list
                   'quote
                   (list 'quote (list (list 'quote _.1))))))))
            _.0))))
     (=/= ((_.0 closure)) ((_.1 closure)))
     (sym _.0 _.1))))

(test "18"
  (run 1 (qe le)
    (absento qe le)
    (absento le qe)
    (eval-quasi qe le)
    (eval-listo le qe))
  '(((`(,'(lambda (_.0)
            (list
             'quasiquote
             (list _.0 'unquote (list 'quote (list (list 'quote _.0))))))
        .
        ,'(','(lambda (_.0)
                (list
                 'quasiquote
                 (list
                  _.0
                  'unquote
                  (list 'quote (list (list 'quote _.0))))))))
      ((lambda (_.0)
         (list
          'quasiquote
          (list _.0 'unquote (list 'quote (list (list 'quote _.0))))))
       ','(lambda (_.0)
            (list
             'quasiquote
             (list
              _.0
              'unquote
              (list 'quote (list (list 'quote _.0))))))))
     (=/= ((_.0 closure)))
     (sym _.0))))



(test "19"
  (run 1 (qe le)
    (absento qe le)
    (absento le qe)
    (eval-listo le qe)
    (eval-quasi qe le))
  '(((((lambda (_.0)
         `(list ,_.0 (quote (quote ,_.0 . ,'()) . ,'()) . ,'()))
       ''(lambda (_.0)
           `(list ,_.0 (quote (quote ,_.0 . ,'()) . ,'()) . ,'())))
      (list
       '(lambda (_.0)
          `(list ,_.0 (quote (quote ,_.0 . ,'()) . ,'()) . ,'()))
       '''(lambda (_.0)
            `(list ,_.0 (quote (quote ,_.0 . ,'()) . ,'()) . ,'()))))
     (=/= ((_.0 closure)))
     (sym _.0))))





;; A nice three-stage Quine relay
;;
;; Takes 36 seconds on Will's lappy
(test "20"
  (run 1 (qe ce le)
    (absento qe (list le ce))
    (absento le (list qe ce))
    (absento ce (list qe le))
    (eval-quasi qe ce)
    (eval-conso ce le)
    (eval-listo le qe))
  '(((`(cons
        .
        ,'('(lambda (_.0)
              (list
               'quasiquote
               (list
                'cons
                'unquote
                (list
                 'quote
                 (list _.0 (list 'quote (list (list 'quote _.0))))))))
           '(''(lambda (_.0)
                 (list
                  'quasiquote
                  (list
                   'cons
                   'unquote
                   (list
                    'quote
                    (list
                     _.0
                     (list 'quote (list (list 'quote _.0)))))))))))
      (cons
       '(lambda (_.0)
          (list
           'quasiquote
           (list
            'cons
            'unquote
            (list
             'quote
             (list _.0 (list 'quote (list (list 'quote _.0))))))))
       '(''(lambda (_.0)
             (list
              'quasiquote
              (list
               'cons
               'unquote
               (list
                'quote
                (list _.0 (list 'quote (list (list 'quote _.0))))))))))
      ((lambda (_.0)
         (list
          'quasiquote
          (list
           'cons
           'unquote
           (list
            'quote
            (list _.0 (list 'quote (list (list 'quote _.0))))))))
       ''(lambda (_.0)
           (list
            'quasiquote
            (list
             'cons
             'unquote
             (list
              'quote
              (list _.0 (list 'quote (list (list 'quote _.0))))))))))
     (=/= ((_.0 closure)))
     (sym _.0))))





#|
;; This ordering seems to take much longer (not sure how much longer).
;; I suspect qe is hardest to generate, and therefore should come
;; first.  Then ce, then finally le, which is the easiest to generate.
(run 1 (qe le ce)
  (absento qe (list le ce))
  (absento le (list qe ce))
  (absento ce (list qe le))
  (eval-quasi qe le)
  (eval-listo le ce)
  (eval-conso ce qe))
|#


(test "21"
  (run 1 (ce le)
    (eval-conso ce le)
    (eval-listo le ce))
  '((('((lambda (_.0)
          (list 'quote (list _.0 (list 'quote _.0))))
        '(lambda (_.0) (list 'quote (list _.0 (list 'quote _.0)))))
      ((lambda (_.0) (list 'quote (list _.0 (list 'quote _.0))))
       '(lambda (_.0) (list 'quote (list _.0 (list 'quote _.0))))))
     (=/= ((_.0 closure)))
     (sym _.0))))




(test "22"
  (run 1 (q1 q2 q3)
    (eval-conso q1 q2)
    (eval-listo q2 q3)
    (eval-conso q3 q1))
  '(((''((lambda (_.0)
           (cons
            'quote
            (cons
             (cons
              'quote
              (cons
               (cons _.0 (cons (cons 'quote (cons _.0 '())) '()))
               '()))
             '())))
         '(lambda (_.0)
            (cons
             'quote
             (cons
              (cons
               'quote
               (cons
                (cons _.0 (cons (cons 'quote (cons _.0 '())) '()))
                '()))
              '()))))
      '((lambda (_.0)
          (cons
           'quote
           (cons
            (cons
             'quote
             (cons
              (cons _.0 (cons (cons 'quote (cons _.0 '())) '()))
              '()))
            '())))
        '(lambda (_.0)
           (cons
            'quote
            (cons
             (cons
              'quote
              (cons
               (cons _.0 (cons (cons 'quote (cons _.0 '())) '()))
               '()))
             '()))))
      ((lambda (_.0)
         (cons
          'quote
          (cons
           (cons
            'quote
            (cons
             (cons _.0 (cons (cons 'quote (cons _.0 '())) '()))
             '()))
           '())))
       '(lambda (_.0)
          (cons
           'quote
           (cons
            (cons
             'quote
             (cons
              (cons _.0 (cons (cons 'quote (cons _.0 '())) '()))
              '()))
            '())))))
     (=/= ((_.0 closure)))
     (sym _.0))))




(test "23"
  (run 1 (q1 q2 q3)
    (=/= q1 q2)
    (=/= q1 q3)
    (=/= q2 q3)
    (eval-conso q1 q2)
    (eval-listo q2 q3)
    (eval-conso q3 q1))
  '(((''((lambda (_.0)
           (cons
            'quote
            (cons
             (cons
              'quote
              (cons
               (cons _.0 (cons (cons 'quote (cons _.0 '())) '()))
               '()))
             '())))
         '(lambda (_.0)
            (cons
             'quote
             (cons
              (cons
               'quote
               (cons
                (cons _.0 (cons (cons 'quote (cons _.0 '())) '()))
                '()))
              '()))))
      '((lambda (_.0)
          (cons
           'quote
           (cons
            (cons
             'quote
             (cons
              (cons _.0 (cons (cons 'quote (cons _.0 '())) '()))
              '()))
            '())))
        '(lambda (_.0)
           (cons
            'quote
            (cons
             (cons
              'quote
              (cons
               (cons _.0 (cons (cons 'quote (cons _.0 '())) '()))
               '()))
             '()))))
      ((lambda (_.0)
         (cons
          'quote
          (cons
           (cons
            'quote
            (cons
             (cons _.0 (cons (cons 'quote (cons _.0 '())) '()))
             '()))
           '())))
       '(lambda (_.0)
          (cons
           'quote
           (cons
            (cons
             'quote
             (cons
              (cons _.0 (cons (cons 'quote (cons _.0 '())) '()))
              '()))
            '())))))
     (=/= ((_.0 closure)))
     (sym _.0))))




(test "24"
  (run 1 (q1 q2 q3)
    (=/= q1 q2)
    (=/= q1 q3)
    (=/= q2 q3)
    (eval-listo q1 q2)
    (eval-conso q2 q3)
    (eval-listo q3 q1))
  '(((''((lambda (_.0)
           (list 'quote (list 'quote (list _.0 (list 'quote _.0)))))
         '(lambda (_.0)
            (list 'quote (list 'quote (list _.0 (list 'quote _.0))))))
      '((lambda (_.0)
          (list 'quote (list 'quote (list _.0 (list 'quote _.0)))))
        '(lambda (_.0)
           (list 'quote (list 'quote (list _.0 (list 'quote _.0))))))
      ((lambda (_.0)
         (list 'quote (list 'quote (list _.0 (list 'quote _.0)))))
       '(lambda (_.0)
          (list 'quote (list 'quote (list _.0 (list 'quote _.0)))))))
     (=/= ((_.0 closure)))
     (sym _.0))))




(test "25"
  (run 1 (q1 q2 q3)
    (absento 'list q1)
    (absento 'cons q2)
    (eval-conso q1 q2)
    (eval-listo q2 q3))
  '(((''_.0 '_.0 _.0)
     (absento (closure _.0) (cons _.0) (list _.0)))))




#|
;; doesn't come back anytime soon...
;; Which I think makes sense
(run 1 (q1 q2 q3 q4)
  (absento 'list q1)
  (absento 'cons q2)
  (absento 'list q3)
  (absento 'cons q4)
  (eval-conso q1 q2)
  (eval-listo q2 q3)
  (eval-conso q3 q4)
  (eval-listo q4 q1))
|#

(test "26"
  (run 1 (e1 e2)
    (eval-conso e1 e2)
    (eval-listo e2 e2))
  '((('((lambda (_.0) (list _.0 (list 'quote _.0)))
        '(lambda (_.0) (list _.0 (list 'quote _.0))))
      ((lambda (_.0) (list _.0 (list 'quote _.0)))
       '(lambda (_.0) (list _.0 (list 'quote _.0)))))
     (=/= ((_.0 closure)))
     (sym _.0))))



(test "27"
  (run 1 (e1 e2)
    (eval-listo e1 e2)
    (eval-conso e2 e2))
  '((('((lambda (_.0)
          (cons _.0 (cons (cons 'quote (cons _.0 '())) '())))
        '(lambda (_.0)
           (cons _.0 (cons (cons 'quote (cons _.0 '())) '()))))
      ((lambda (_.0)
         (cons _.0 (cons (cons 'quote (cons _.0 '())) '())))
       '(lambda (_.0)
          (cons _.0 (cons (cons 'quote (cons _.0 '())) '())))))
     (=/= ((_.0 closure)))
     (sym _.0))))


(test "28"
  (run 1 (e1 e2)
    (fresh (e^ e^^)
      ;; force e1 to be an application of a lambda, rather than a quote
      (== `((lambda . ,e^) ,e^^) e1))
    (eval-conso e1 e2)
    (eval-listo e2 e2))

  ;; mk cheats, as usual!
  '(((((lambda (_.0)
         '((lambda (_.1) (list _.1 (list 'quote _.1)))
           '(lambda (_.1) (list _.1 (list 'quote _.1)))))
       '_.2)
      ((lambda (_.1) (list _.1 (list 'quote _.1)))
       '(lambda (_.1) (list _.1 (list 'quote _.1)))))
     (=/= ((_.1 closure)))
     (sym _.0 _.1)
     (absento (closure _.2)))))


