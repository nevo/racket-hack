#;
(
TR opt: unboxed-let-functions4.rkt 23:7 f -- fun -> unboxed fun
TR opt: unboxed-let-functions4.rkt 23:7 f -- unboxed function -> table
TR opt: unboxed-let-functions4.rkt 23:32 x -- unboxed var -> table
TR opt: unboxed-let-functions4.rkt 24:18 (+ x y) -- unboxed float complex
TR opt: unboxed-let-functions4.rkt 24:19 + -- unboxed binary float complex
TR opt: unboxed-let-functions4.rkt 24:21 x -- leave var unboxed
TR opt: unboxed-let-functions4.rkt 24:21 x -- unbox float-complex
TR opt: unboxed-let-functions4.rkt 24:23 y -- float-arg-expr in complex ops
TR opt: unboxed-let-functions4.rkt 25:3 f -- call to fun with unboxed args
TR opt: unboxed-let-functions4.rkt 25:3 f -- unboxed call site
TR opt: unboxed-let-functions4.rkt 26:6 + -- unboxed binary float complex
TR opt: unboxed-let-functions4.rkt 26:8 1.0+2.0i -- unboxed literal
TR opt: unboxed-let-functions4.rkt 26:17 2.0+4.0i -- unboxed literal
6.0+6.0i
)

#lang typed/scheme
#:optimize

;; function with a mix of complex and non-complex args, non-complex first
(let ((f (lambda: ((y : Float) (x : Float-Complex))
                  (+ x y))))
  (f 3.0
     (+ 1.0+2.0i 2.0+4.0i)))
