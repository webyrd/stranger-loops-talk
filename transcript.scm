Chez Scheme Version 9.5.5
Copyright 1984-2020 Cisco Systems, Inc.

> (load "simple.scm")
> appendo

Exception: variable appendo is not bound
Type (debug) to enter the debugger.
> (define appendo
    (lambda (l s out)
      (conde
        ((== '() l) (== s out))
        ((fresh (a d res)
           (== (cons a d) l)
           (== (cons a res) out)
           (appendo d s res))))))
> (append '(I love) '(Strange Loop))
(I love Strange Loop)
> (define appendo
    (lambda (l s out)
      (conde
        ((== '() l) (== s out))
        ((fresh (a d res)
           (== (cons a d) l)
           (== (cons a res) out)
           (appendo d s res))))))
> (run 1 (q)
    (appendo '(I love) '(Strange Loop) q))
((I love Strange Loop))
> (run 1 (q)
    (appendo '(I love)
             q
             '(I love Strange Loop)))
((Strange Loop))
> (run 1 (x y)
    (appendo x
             y
             '(I love Strange Loop)))
((() (I love Strange Loop)))
> (run* (x y)
    (appendo x
             y
             '(I love Strange Loop)))
((() (I love Strange Loop))
 ((I) (love Strange Loop))
 ((I love) (Strange Loop))
 ((I love Strange) (Loop))
 ((I love Strange Loop) ()))
> (run 1 (x y z)
    (appendo x
             y
             z))
((() _.0 _.0))
> (+ 3 4)
7
> '(+ 3 4)
(+ 3 4)
> (eval '(+ 3 4))
7
> evalo
#<procedure evalo at q.scm:16>
> (run 1 (q)
    (evalo '(list 'I 'love 'Strange 'Loop)
           q))
((I love Strange Loop))
> (list 'I 'love 'Strange 'Loop)
(I love Strange Loop)
> (run 1 (expr)
    (evalo expr
           '(I love Strange Loop)))
('(I love Strange Loop))
> (run 99 (expr)
    (evalo expr
           '(I love Strange Loop)))
('(I love Strange Loop)
 (((lambda (_.0) '(I love Strange Loop)) '_.1)
   (=/= ((_.0 quote)))
   (sym _.0)
   (absento (closure _.1)))
 (((lambda (_.0) _.0) '(I love Strange Loop)) (sym _.0))
 (((lambda (_.0) '(I love Strange Loop)) (list))
   (=/= ((_.0 quote)))
   (sym _.0))
 (list 'I 'love 'Strange 'Loop)
 (((lambda (_.0) '(I love Strange Loop)) (lambda (_.1) _.2))
   (=/= ((_.0 quote)))
   (sym _.0 _.1))
 ((list ((lambda (_.0) 'I) '_.1) 'love 'Strange 'Loop)
   (=/= ((_.0 closure)) ((_.0 quote)))
   (sym _.0)
   (absento (closure _.1)))
 (((lambda (_.0)
     ((lambda (_.1) '(I love Strange Loop)) '_.2))
    '_.3)
   (=/= ((_.0 lambda)) ((_.0 quote)) ((_.1 quote)))
   (sym _.0 _.1)
   (absento (closure _.2) (closure _.3)))
 (((lambda (_.0) ((lambda (_.1) _.1) '(I love Strange Loop)))
    '_.2)
   (=/= ((_.0 lambda)) ((_.0 quote)))
   (sym _.0 _.1)
   (absento (closure _.2)))
 (((lambda (_.0) '(I love Strange Loop)) (list '_.1))
   (=/= ((_.0 quote)))
   (sym _.0)
   (absento (closure _.1)))
 ((list 'I ((lambda (_.0) 'love) '_.1) 'Strange 'Loop)
   (=/= ((_.0 closure)) ((_.0 quote)))
   (sym _.0)
   (absento (closure _.1)))
 (((lambda (_.0) ((lambda (_.1) _.0) '_.2))
    '(I love Strange Loop))
   (=/= ((_.0 _.1)) ((_.0 lambda)) ((_.0 quote)))
   (sym _.0 _.1)
   (absento (closure _.2)))
 (((lambda (_.0) ((lambda (_.1) '(I love Strange Loop)) _.0))
    '_.2)
   (=/= ((_.0 lambda)) ((_.0 quote)) ((_.1 quote)))
   (sym _.0 _.1)
   (absento (closure _.2)))
 (((lambda (_.0) ((lambda (_.1) _.1) _.0))
    '(I love Strange Loop))
   (=/= ((_.0 lambda)))
   (sym _.0 _.1))
 ((list 'I 'love 'Strange ((lambda (_.0) 'Loop) '_.1))
   (=/= ((_.0 closure)) ((_.0 quote)))
   (sym _.0)
   (absento (closure _.1)))
 ((list ((lambda (_.0) _.0) 'I) 'love 'Strange 'Loop)
   (=/= ((_.0 closure)))
   (sym _.0))
 ((list 'I 'love ((lambda (_.0) 'Strange) '_.1) 'Loop)
   (=/= ((_.0 closure)) ((_.0 quote)))
   (sym _.0)
   (absento (closure _.1)))
 ((list 'I 'love 'Strange ((lambda (_.0) _.0) 'Loop))
   (=/= ((_.0 closure)))
   (sym _.0))
 ((list 'I ((lambda (_.0) _.0) 'love) 'Strange 'Loop)
   (=/= ((_.0 closure)))
   (sym _.0))
 (((lambda (_.0)
     ((lambda (_.1) '(I love Strange Loop)) '_.2))
    (list))
   (=/= ((_.0 lambda)) ((_.0 quote)) ((_.1 quote)))
   (sym _.0 _.1)
   (absento (closure _.2)))
 (((lambda (_.0) ((lambda (_.1) _.0) _.0))
    '(I love Strange Loop))
   (=/= ((_.0 _.1)) ((_.0 lambda)))
   (sym _.0 _.1))
 (((lambda (_.0) ((lambda (_.1) _.1) '(I love Strange Loop)))
    (list))
   (=/= ((_.0 lambda)) ((_.0 quote)))
   (sym _.0 _.1))
 (((lambda (_.0) (list 'I 'love 'Strange 'Loop)) '_.1)
   (=/= ((_.0 list)) ((_.0 quote)))
   (sym _.0)
   (absento (closure _.1)))
 (((lambda (_.0)
     ((lambda (_.1) '(I love Strange Loop)) (list)))
    '_.2)
   (=/= ((_.0 lambda))
        ((_.0 list))
        ((_.0 quote))
        ((_.1 quote)))
   (sym _.0 _.1)
   (absento (closure _.2)))
 ((list 'I 'love 'Strange ((lambda (_.0) 'Loop) (list)))
   (=/= ((_.0 closure)) ((_.0 quote)))
   (sym _.0))
 ((list 'I 'love ((lambda (_.0) _.0) 'Strange) 'Loop)
   (=/= ((_.0 closure)))
   (sym _.0))
 (((lambda (_.0) (list 'I 'love 'Strange _.0)) 'Loop)
   (=/= ((_.0 closure)) ((_.0 list)) ((_.0 quote)))
   (sym _.0))
 ((list
    ((lambda (_.0) 'I) '_.1)
    ((lambda (_.2) 'love) '_.3)
    'Strange
    'Loop)
   (=/= ((_.0 closure))
        ((_.0 quote))
        ((_.2 closure))
        ((_.2 quote)))
   (sym _.0 _.2)
   (absento (closure _.1) (closure _.3)))
 (((lambda (_.0) ((lambda (_.1) '(I love Strange Loop)) _.0))
    (list))
   (=/= ((_.0 lambda)) ((_.0 quote)) ((_.1 quote)))
   (sym _.0 _.1))
 (((lambda (_.0) (_.0 '_.1))
    (lambda (_.2) '(I love Strange Loop)))
   (=/= ((_.0 quote)) ((_.2 quote)))
   (sym _.0 _.2)
   (absento (closure _.1)))
 (((lambda (_.0) ((lambda (_.1) _.0) (list)))
    '(I love Strange Loop))
   (=/= ((_.0 _.1)) ((_.0 lambda)) ((_.0 list)))
   (sym _.0 _.1))
 (((lambda (_.0) (_.0 '(I love Strange Loop)))
    (lambda (_.1) _.1))
   (=/= ((_.0 quote)))
   (sym _.0 _.1))
 ((list
    ((lambda (_.0) 'I) '_.1)
    'love
    'Strange
    ((lambda (_.2) 'Loop) '_.3))
   (=/= ((_.0 closure))
        ((_.0 quote))
        ((_.2 closure))
        ((_.2 quote)))
   (sym _.0 _.2)
   (absento (closure _.1) (closure _.3)))
 (((lambda (_.0) '(I love Strange Loop)) (list (list)))
   (=/= ((_.0 quote)))
   (sym _.0))
 (((lambda (_.0) (list 'I 'love _.0 'Loop)) 'Strange)
   (=/= ((_.0 closure)) ((_.0 list)) ((_.0 quote)))
   (sym _.0))
 ((list ((lambda (_.0) 'I) (list)) 'love 'Strange 'Loop)
   (=/= ((_.0 closure)) ((_.0 quote)))
   (sym _.0))
 ((list
    'I
    ((lambda (_.0) 'love) '_.1)
    'Strange
    ((lambda (_.2) 'Loop) '_.3))
   (=/= ((_.0 closure))
        ((_.0 quote))
        ((_.2 closure))
        ((_.2 quote)))
   (sym _.0 _.2)
   (absento (closure _.1) (closure _.3)))
 ((list
    ((lambda (_.0) 'I) '_.1)
    'love
    ((lambda (_.2) 'Strange) '_.3)
    'Loop)
   (=/= ((_.0 closure))
        ((_.0 quote))
        ((_.2 closure))
        ((_.2 quote)))
   (sym _.0 _.2)
   (absento (closure _.1) (closure _.3)))
 (((lambda (_.0) (list 'I _.0 'Strange 'Loop)) 'love)
   (=/= ((_.0 closure)) ((_.0 list)) ((_.0 quote)))
   (sym _.0))
 ((list
    ((lambda (_.0) 'I) '_.1)
    'love
    'Strange
    ((lambda (_.2) _.2) 'Loop))
   (=/= ((_.0 closure)) ((_.0 quote)) ((_.2 closure)))
   (sym _.0 _.2)
   (absento (closure _.1)))
 ((list
    'I
    ((lambda (_.0) 'love) '_.1)
    ((lambda (_.2) 'Strange) '_.3)
    'Loop)
   (=/= ((_.0 closure))
        ((_.0 quote))
        ((_.2 closure))
        ((_.2 quote)))
   (sym _.0 _.2)
   (absento (closure _.1) (closure _.3)))
 (((lambda (_.0) (list _.0 'love 'Strange 'Loop)) 'I)
   (=/= ((_.0 closure)) ((_.0 list)) ((_.0 quote)))
   (sym _.0))
 ((list
    'I
    ((lambda (_.0) 'love) '_.1)
    'Strange
    ((lambda (_.2) _.2) 'Loop))
   (=/= ((_.0 closure)) ((_.0 quote)) ((_.2 closure)))
   (sym _.0 _.2)
   (absento (closure _.1)))
 (((lambda (_.0) (list 'I 'love 'Strange 'Loop)) (list))
   (=/= ((_.0 list)) ((_.0 quote)))
   (sym _.0))
 ((list
    'I
    'love
    ((lambda (_.0) 'Strange) '_.1)
    ((lambda (_.2) 'Loop) '_.3))
   (=/= ((_.0 closure))
        ((_.0 quote))
        ((_.2 closure))
        ((_.2 quote)))
   (sym _.0 _.2)
   (absento (closure _.1) (closure _.3)))
 ((list
    ((lambda (_.0) 'I) '_.1)
    ((lambda (_.2) _.2) 'love)
    'Strange
    'Loop)
   (=/= ((_.0 closure)) ((_.0 quote)) ((_.2 closure)))
   (sym _.0 _.2)
   (absento (closure _.1)))
 ((list 'I ((lambda (_.0) 'love) (list)) 'Strange 'Loop)
   (=/= ((_.0 closure)) ((_.0 quote)))
   (sym _.0))
 (((lambda (_.0)
     ((lambda (_.1) '(I love Strange Loop)) (list)))
    (list))
   (=/= ((_.0 lambda))
        ((_.0 list))
        ((_.0 quote))
        ((_.1 quote)))
   (sym _.0 _.1))
 (((lambda (_.0) (_.0 _.0))
    (lambda (_.1) '(I love Strange Loop)))
   (=/= ((_.1 quote)))
   (sym _.0 _.1))
 ((list
    'I
    'love
    'Strange
    ((lambda (_.0) 'Loop) (lambda (_.1) _.2)))
   (=/= ((_.0 closure)) ((_.0 quote)) ((_.1 closure)))
   (sym _.0 _.1)
   (absento (closure _.2)))
 ((list
    'I
    'love
    ((lambda (_.0) 'Strange) '_.1)
    ((lambda (_.2) _.2) 'Loop))
   (=/= ((_.0 closure)) ((_.0 quote)) ((_.2 closure)))
   (sym _.0 _.2)
   (absento (closure _.1)))
 ((list
    ((lambda (_.0) _.0) 'I)
    ((lambda (_.1) 'love) '_.2)
    'Strange
    'Loop)
   (=/= ((_.0 closure)) ((_.1 closure)) ((_.1 quote)))
   (sym _.0 _.1)
   (absento (closure _.2)))
 ((list
    ((lambda (_.0) 'I) '_.1)
    'love
    'Strange
    ((lambda (_.2) 'Loop) (list)))
   (=/= ((_.0 closure))
        ((_.0 quote))
        ((_.2 closure))
        ((_.2 quote)))
   (sym _.0 _.2)
   (absento (closure _.1)))
 ((list
    ((lambda (_.0) 'I) '_.1)
    'love
    ((lambda (_.2) _.2) 'Strange)
    'Loop)
   (=/= ((_.0 closure)) ((_.0 quote)) ((_.2 closure)))
   (sym _.0 _.2)
   (absento (closure _.1)))
 ((list
    'I
    'love
    'Strange
    ((lambda (_.0) ((lambda (_.1) 'Loop) '_.2)) '_.3))
   (=/= ((_.0 closure)) ((_.0 lambda)) ((_.0 quote))
        ((_.1 closure)) ((_.1 quote)))
   (sym _.0 _.1)
   (absento (closure _.2) (closure _.3)))
 ((list
    'I
    ((lambda (_.0) 'love) '_.1)
    'Strange
    ((lambda (_.2) 'Loop) (list)))
   (=/= ((_.0 closure))
        ((_.0 quote))
        ((_.2 closure))
        ((_.2 quote)))
   (sym _.0 _.2)
   (absento (closure _.1)))
 ((list
    'I
    ((lambda (_.0) 'love) '_.1)
    ((lambda (_.2) _.2) 'Strange)
    'Loop)
   (=/= ((_.0 closure)) ((_.0 quote)) ((_.2 closure)))
   (sym _.0 _.2)
   (absento (closure _.1)))
 ((list
    'I
    'love
    'Strange
    ((lambda (_.0) ((lambda (_.1) _.1) 'Loop)) '_.2))
   (=/= ((_.0 closure))
        ((_.0 lambda))
        ((_.0 quote))
        ((_.1 closure)))
   (sym _.0 _.1)
   (absento (closure _.2)))
 (((lambda (_.0)
     ((lambda (_.1) ((lambda (_.2) '(I love Strange Loop)) '_.3))
       '_.4))
    '_.5)
   (=/= ((_.0 lambda)) ((_.0 quote)) ((_.1 lambda))
        ((_.1 quote)) ((_.2 quote)))
   (sym _.0 _.1 _.2)
   (absento (closure _.3) (closure _.4) (closure _.5)))
 ((list 'I 'love ((lambda (_.0) 'Strange) (list)) 'Loop)
   (=/= ((_.0 closure)) ((_.0 quote)))
   (sym _.0))
 (((lambda (_.0)
     ((lambda (_.1) ((lambda (_.2) _.2) '(I love Strange Loop)))
       '_.3))
    '_.4)
   (=/= ((_.0 lambda))
        ((_.0 quote))
        ((_.1 lambda))
        ((_.1 quote)))
   (sym _.0 _.1 _.2)
   (absento (closure _.3) (closure _.4)))
 ((list
    'I
    'love
    ((lambda (_.0) 'Strange) '_.1)
    ((lambda (_.2) 'Loop) (list)))
   (=/= ((_.0 closure))
        ((_.0 quote))
        ((_.2 closure))
        ((_.2 quote)))
   (sym _.0 _.2)
   (absento (closure _.1)))
 (((lambda (_.0)
     ((lambda (_.1) '(I love Strange Loop)) (lambda (_.2) _.3)))
    '_.4)
   (=/= ((_.0 lambda)) ((_.0 quote)) ((_.1 quote)))
   (sym _.0 _.1 _.2)
   (absento (closure _.4)))
 ((list
    'I
    'love
    'Strange
    ((lambda (_.0) ((lambda (_.1) _.0) '_.2)) 'Loop))
   (=/= ((_.0 _.1)) ((_.0 closure)) ((_.0 lambda))
        ((_.0 quote)) ((_.1 closure)))
   (sym _.0 _.1)
   (absento (closure _.2)))
 ((list
    ((lambda (_.0) _.0) 'I)
    'love
    'Strange
    ((lambda (_.1) 'Loop) '_.2))
   (=/= ((_.0 closure)) ((_.1 closure)) ((_.1 quote)))
   (sym _.0 _.1)
   (absento (closure _.2)))
 (((lambda (_.0)
     ((lambda (_.1) ((lambda (_.2) _.1) '_.3))
       '(I love Strange Loop)))
    '_.4)
   (=/= ((_.0 lambda)) ((_.0 quote)) ((_.1 _.2)) ((_.1 lambda))
        ((_.1 quote)))
   (sym _.0 _.1 _.2)
   (absento (closure _.3) (closure _.4)))
 (((lambda (_.0) (_.0 (list)))
    (lambda (_.1) '(I love Strange Loop)))
   (=/= ((_.0 list)) ((_.1 quote)))
   (sym _.0 _.1))
 (((lambda (_.0) '(I love Strange Loop)) (list '_.1 '_.2))
   (=/= ((_.0 quote)))
   (sym _.0)
   (absento (closure _.1) (closure _.2)))
 ((list
    'I
    ((lambda (_.0) _.0) 'love)
    'Strange
    ((lambda (_.1) 'Loop) '_.2))
   (=/= ((_.0 closure)) ((_.1 closure)) ((_.1 quote)))
   (sym _.0 _.1)
   (absento (closure _.2)))
 ((list
    ((lambda (_.0) _.0) 'I)
    'love
    ((lambda (_.1) 'Strange) '_.2)
    'Loop)
   (=/= ((_.0 closure)) ((_.1 closure)) ((_.1 quote)))
   (sym _.0 _.1)
   (absento (closure _.2)))
 ((list
    'I
    'love
    'Strange
    ((lambda (_.0) ((lambda (_.1) 'Loop) _.0)) '_.2))
   (=/= ((_.0 closure)) ((_.0 lambda)) ((_.0 quote))
        ((_.1 closure)) ((_.1 quote)))
   (sym _.0 _.1)
   (absento (closure _.2)))
 ((list
    'I
    'love
    ((lambda (_.0) _.0) 'Strange)
    ((lambda (_.1) 'Loop) '_.2))
   (=/= ((_.0 closure)) ((_.1 closure)) ((_.1 quote)))
   (sym _.0 _.1)
   (absento (closure _.2)))
 ((list
    ((lambda (_.0) _.0) 'I)
    'love
    'Strange
    ((lambda (_.1) _.1) 'Loop))
   (=/= ((_.0 closure)) ((_.1 closure)))
   (sym _.0 _.1))
 ((list
    'I
    ((lambda (_.0) _.0) 'love)
    ((lambda (_.1) 'Strange) '_.2)
    'Loop)
   (=/= ((_.0 closure)) ((_.1 closure)) ((_.1 quote)))
   (sym _.0 _.1)
   (absento (closure _.2)))
 (((lambda (_.0)
     ((lambda (_.1) ((lambda (_.2) '(I love Strange Loop)) _.1))
       '_.3))
    '_.4)
   (=/= ((_.0 lambda)) ((_.0 quote)) ((_.1 lambda))
        ((_.1 quote)) ((_.2 quote)))
   (sym _.0 _.1 _.2)
   (absento (closure _.3) (closure _.4)))
 (((lambda (_.0)
     ((lambda (_.1) ((lambda (_.2) _.0) '_.3)) '_.4))
    '(I love Strange Loop))
   (=/= ((_.0 _.1)) ((_.0 _.2)) ((_.0 lambda)) ((_.0 quote))
        ((_.1 lambda)) ((_.1 quote)))
   (sym _.0 _.1 _.2)
   (absento (closure _.3) (closure _.4)))
 ((list
    ((lambda (_.0) 'I) '_.1)
    ((lambda (_.2) 'love) '_.3)
    'Strange
    ((lambda (_.4) 'Loop) '_.5))
   (=/= ((_.0 closure)) ((_.0 quote)) ((_.2 closure))
        ((_.2 quote)) ((_.4 closure)) ((_.4 quote)))
   (sym _.0 _.2 _.4)
   (absento (closure _.1) (closure _.3) (closure _.5)))
 (((lambda (_.0) ((lambda (_.1) _.0) (lambda (_.2) _.3)))
    '(I love Strange Loop))
   (=/= ((_.0 _.1)) ((_.0 lambda)))
   (sym _.0 _.1 _.2))
 (((lambda (_.0)
     ((lambda (_.1) ((lambda (_.2) _.2) _.1))
       '(I love Strange Loop)))
    '_.3)
   (=/= ((_.0 lambda)) ((_.0 quote)) ((_.1 lambda)))
   (sym _.0 _.1 _.2)
   (absento (closure _.3)))
 ((list
    'I
    ((lambda (_.0) _.0) 'love)
    'Strange
    ((lambda (_.1) _.1) 'Loop))
   (=/= ((_.0 closure)) ((_.1 closure)))
   (sym _.0 _.1))
 ((list
    'I
    'love
    'Strange
    ((lambda (_.0) ((lambda (_.1) _.1) _.0)) 'Loop))
   (=/= ((_.0 closure)) ((_.0 lambda)) ((_.1 closure)))
   (sym _.0 _.1))
 (((lambda (_.0)
     ((lambda (_.1) '(I love Strange Loop)) '_.2))
    (list '_.3))
   (=/= ((_.0 lambda)) ((_.0 quote)) ((_.1 quote)))
   (sym _.0 _.1)
   (absento (closure _.2) (closure _.3)))
 ((list
    ((lambda (_.0) _.0) 'I)
    ((lambda (_.1) _.1) 'love)
    'Strange
    'Loop)
   (=/= ((_.0 closure)) ((_.1 closure)))
   (sym _.0 _.1))
 ((list
    ((lambda (_.0) 'I) '_.1)
    ((lambda (_.2) 'love) '_.3)
    ((lambda (_.4) 'Strange) '_.5)
    'Loop)
   (=/= ((_.0 closure)) ((_.0 quote)) ((_.2 closure))
        ((_.2 quote)) ((_.4 closure)) ((_.4 quote)))
   (sym _.0 _.2 _.4)
   (absento (closure _.1) (closure _.3) (closure _.5)))
 ((list
    'I
    'love
    ((lambda (_.0) _.0) 'Strange)
    ((lambda (_.1) _.1) 'Loop))
   (=/= ((_.0 closure)) ((_.1 closure)))
   (sym _.0 _.1))
 (((lambda (_.0) (list 'I 'love 'Strange 'Loop))
    (lambda (_.1) _.2))
   (=/= ((_.0 list)) ((_.0 quote)))
   (sym _.0 _.1))
 ((list
    ((lambda (_.0) 'I) '_.1)
    ((lambda (_.2) 'love) '_.3)
    'Strange
    ((lambda (_.4) _.4) 'Loop))
   (=/= ((_.0 closure)) ((_.0 quote)) ((_.2 closure))
        ((_.2 quote)) ((_.4 closure)))
   (sym _.0 _.2 _.4)
   (absento (closure _.1) (closure _.3)))
 (((lambda (_.0) ((lambda (_.1) _.1) '(I love Strange Loop)))
    (list '_.2))
   (=/= ((_.0 lambda)) ((_.0 quote)))
   (sym _.0 _.1)
   (absento (closure _.2)))
 ((list
    ((lambda (_.0) 'I) '_.1)
    'love
    ((lambda (_.2) 'Strange) '_.3)
    ((lambda (_.4) 'Loop) '_.5))
   (=/= ((_.0 closure)) ((_.0 quote)) ((_.2 closure))
        ((_.2 quote)) ((_.4 closure)) ((_.4 quote)))
   (sym _.0 _.2 _.4)
   (absento (closure _.1) (closure _.3) (closure _.5)))
 ((list
    'I
    ((lambda (_.0) 'love) '_.1)
    ((lambda (_.2) 'Strange) '_.3)
    ((lambda (_.4) 'Loop) '_.5))
   (=/= ((_.0 closure)) ((_.0 quote)) ((_.2 closure))
        ((_.2 quote)) ((_.4 closure)) ((_.4 quote)))
   (sym _.0 _.2 _.4)
   (absento (closure _.1) (closure _.3) (closure _.5)))
 ((list
    ((lambda (_.0) 'I) '_.1)
    ((lambda (_.2) 'love) (list))
    'Strange
    'Loop)
   (=/= ((_.0 closure))
        ((_.0 quote))
        ((_.2 closure))
        ((_.2 quote)))
   (sym _.0 _.2)
   (absento (closure _.1)))
 ((list
    'I
    'love
    'Strange
    ((lambda (_.0) ((lambda (_.1) _.0) _.0)) 'Loop))
   (=/= ((_.0 _.1))
        ((_.0 closure))
        ((_.0 lambda))
        ((_.1 closure)))
   (sym _.0 _.1))
 (((lambda (_.0)
     ((lambda (_.1) ((lambda (_.2) _.1) _.1))
       '(I love Strange Loop)))
    '_.3)
   (=/= ((_.0 lambda))
        ((_.0 quote))
        ((_.1 _.2))
        ((_.1 lambda)))
   (sym _.0 _.1 _.2)
   (absento (closure _.3)))
 ((list
    ((lambda (_.0) 'I) '_.1)
    'love
    'Strange
    ((lambda (_.2) 'Loop) (lambda (_.3) _.4)))
   (=/= ((_.0 closure)) ((_.0 quote)) ((_.2 closure))
        ((_.2 quote)) ((_.3 closure)))
   (sym _.0 _.2 _.3)
   (absento (closure _.1) (closure _.4)))
 ((list
    ((lambda (_.0) 'I) '_.1)
    'love
    ((lambda (_.2) 'Strange) '_.3)
    ((lambda (_.4) _.4) 'Loop))
   (=/= ((_.0 closure)) ((_.0 quote)) ((_.2 closure))
        ((_.2 quote)) ((_.4 closure)))
   (sym _.0 _.2 _.4)
   (absento (closure _.1) (closure _.3)))
 (((lambda (_.0)
     (list 'I 'love 'Strange ((lambda (_.1) 'Loop) '_.2)))
    '_.3)
   (=/= ((_.0 lambda)) ((_.0 list)) ((_.0 quote))
        ((_.1 closure)) ((_.1 quote)))
   (sym _.0 _.1)
   (absento (closure _.2) (closure _.3)))
 ((list
    'I
    ((lambda (_.0) 'love) '_.1)
    'Strange
    ((lambda (_.2) 'Loop) (lambda (_.3) _.4)))
   (=/= ((_.0 closure)) ((_.0 quote)) ((_.2 closure))
        ((_.2 quote)) ((_.3 closure)))
   (sym _.0 _.2 _.3)
   (absento (closure _.1) (closure _.4)))
 ((list
    'I
    ((lambda (_.0) 'love) '_.1)
    ((lambda (_.2) 'Strange) '_.3)
    ((lambda (_.4) _.4) 'Loop))
   (=/= ((_.0 closure)) ((_.0 quote)) ((_.2 closure))
        ((_.2 quote)) ((_.4 closure)))
   (sym _.0 _.2 _.4)
   (absento (closure _.1) (closure _.3)))
 ((list
    'I
    'love
    'Strange
    ((lambda (_.0) ((lambda (_.1) 'Loop) '_.2)) (list)))
   (=/= ((_.0 closure)) ((_.0 lambda)) ((_.0 quote))
        ((_.1 closure)) ((_.1 quote)))
   (sym _.0 _.1)
   (absento (closure _.2))))
> (list
    'I
    'love
    'Strange
    ((lambda (_.0)
       ((lambda (_.1) 'Loop) '_.2)) (list)))
(I love Strange Loop)
> (run 1 (e)
    (evalo e e))
((((lambda (_.0) (list _.0 (list 'quote _.0)))
    '(lambda (_.0) (list _.0 (list 'quote _.0))))
   (=/= ((_.0 closure)) ((_.0 list)) ((_.0 quote)))
   (sym _.0)))
> ((lambda (_.0) (list _.0 (list 'quote _.0)))
    '(lambda (_.0) (list _.0 (list 'quote _.0))))
((lambda (_.0) (list _.0 (list 'quote _.0)))
  '(lambda (_.0) (list _.0 (list 'quote _.0))))
> ((lambda (x) (list x (list 'quote x)))
    '(lambda (x) (list x (list 'quote x))))
((lambda (x) (list x (list 'quote x)))
  '(lambda (x) (list x (list 'quote x))))
> (run 1 (p q)
    (=/= p q)
    (evalo p q)
    (evalo q p))
((('((lambda (_.0)
       (list 'quote (list _.0 (list 'quote _.0))))
      '(lambda (_.0) (list 'quote (list _.0 (list 'quote _.0)))))
    ((lambda (_.0) (list 'quote (list _.0 (list 'quote _.0))))
      '(lambda (_.0) (list 'quote (list _.0 (list 'quote _.0))))))
   (=/= ((_.0 closure)) ((_.0 list)) ((_.0 quote)))
   (sym _.0)))
> '((lambda (_.0)
       (list 'quote (list _.0 (list 'quote _.0))))
      '(lambda (_.0) (list 'quote (list _.0 (list 'quote _.0)))))'(lambda (_.0) (list 'quote (list _.0 (list 'quote _.0))))
(lambda (_.0) (list 'quote (list _.0 (list 'quote _.0))))
> '((lambda (_.0)
       (list 'quote (list _.0 (list 'quote _.0))))
      '(lambda (_.0) (list 'quote (list _.0 (list 'quote _.0)))))
((lambda (_.0) (list 'quote (list _.0 (list 'quote _.0))))
  '(lambda (_.0) (list 'quote (list _.0 (list 'quote _.0)))))
> ((lambda (_.0) (list 'quote (list _.0 (list 'quote _.0))))
  '(lambda (_.0) (list 'quote (list _.0 (list 'quote _.0)))))
'((lambda (_.0) (list 'quote (list _.0 (list 'quote _.0))))
   '(lambda (_.0) (list 'quote (list _.0 (list 'quote _.0)))))
> (run 1 (p q)
    (absento p q)
    (absento q p)
    (evalo p q)
    (evalo q p))
((((list
     '(lambda (_.0)
        (list 'list _.0 (list 'quote (list 'quote _.0))))
     '''(lambda (_.0)
          (list 'list _.0 (list 'quote (list 'quote _.0)))))
    ((lambda (_.0)
       (list 'list _.0 (list 'quote (list 'quote _.0))))
      ''(lambda (_.0)
          (list 'list _.0 (list 'quote (list 'quote _.0))))))
   (=/= ((_.0 closure)) ((_.0 list)) ((_.0 quote)))
   (sym _.0)))
> (list
     '(lambda (_.0)
        (list 'list _.0 (list 'quote (list 'quote _.0))))
     '''(lambda (_.0)
          (list 'list _.0 (list 'quote (list 'quote _.0)))))
((lambda (_.0)
   (list 'list _.0 (list 'quote (list 'quote _.0))))
  ''(lambda (_.0)
      (list 'list _.0 (list 'quote (list 'quote _.0)))))
> ((lambda (_.0)
   (list 'list _.0 (list 'quote (list 'quote _.0))))
  ''(lambda (_.0)
      (list 'list _.0 (list 'quote (list 'quote _.0)))))
(list
  '(lambda (_.0)
     (list 'list _.0 (list 'quote (list 'quote _.0))))
  '''(lambda (_.0)
       (list 'list _.0 (list 'quote (list 'quote _.0)))))
> 

Process scheme finished
Chez Scheme Version 9.5.5
Copyright 1984-2020 Cisco Systems, Inc.

> (load "quine-relay.scm")
  C-c C-c
break> r
> (run 1 (qe ce le)
    (absento qe (list le ce))
    (absento le (list qe ce))
    (absento ce (list qe le))
    (eval-quasi qe ce)
    (eval-conso ce le)
    (eval-listo le qe))
(((`(cons
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
   (sym _.0)))
> `(cons
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
> (cons
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
            (list _.0 (list 'quote (list (list 'quote _.0)))))))))
> ((lambda (_.0)
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
            (list _.0 (list 'quote (list (list 'quote _.0)))))))))
`(cons
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
                   (list _.0 (list 'quote (list (list 'quote _.0)))))))))))
> 