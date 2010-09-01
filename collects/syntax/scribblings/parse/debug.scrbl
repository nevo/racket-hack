#lang scribble/doc
@(require scribble/manual
          scribble/struct
          scribble/decode
          scribble/eval
          "parse-common.rkt")

@title{Debugging and inspection tools}

@defmodule[syntax/parse/debug]

The following special forms are for debugging syntax classes.

@defform[(syntax-class-attributes syntax-class-id)]{

Returns a list of the syntax class's attributes. Each attribute entry
consists of the attribute's name and ellipsis depth.
}

@deftogether[[
@defform[(syntax-class-arity syntax-class-id)]
@defform[(syntax-class-keywords syntax-class-id)]]]{

Returns the syntax class's arity and keywords, respectively. Compare
with @scheme[procedure-arity] and @scheme[procedure-keywords].
}

@defform[(syntax-class-parse syntax-class-id stx-expr arg ...)
         #:contracts ([stx-expr syntax?])]{

Runs the parser for the syntax class (parameterized by the
@scheme[arg-expr]s) on the syntax object produced by
@scheme[stx-expr]. On success, the result is a list of vectors
representing the attribute bindings of the syntax class. Each vector
contains the attribute name, depth, and associated value. On failure,
the result is some internal representation of the failure.
}

@defform[(debug-parse stx-expr S-pattern ...+)
         #:contracts ([stx-expr syntax?])]{

Tries to match @scheme[stx-expr] against the @scheme[S-pattern]s. If
matching succeeds, the the symbol @scheme['success] is
returned. Otherwise, an S-expression describing the failure is returned.

The failure S-expression shows both the raw set of failures (unsorted)
and the failures with maximal progress. The maximal failures are
divided into equivalence classes based on their progress (progress is
a partial order); that is, failures within an equivalence class have
the same progress and, in principle, pinpoint the same term as the
problematic term. Multiple equivalence classes only arise from
@scheme[~parse] patterns (or equivalently, @scheme[#:with] clauses)
that match computed terms or @scheme[~fail] (@scheme[#:fail-when],
etc) clauses that allow a computed term to be pinpointed.

}