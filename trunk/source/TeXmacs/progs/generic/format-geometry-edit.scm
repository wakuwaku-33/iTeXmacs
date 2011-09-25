
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; MODULE      : format-geometry-edit.scm
;; DESCRIPTION : routines for resizing and repositioning
;; COPYRIGHT   : (C) 2010  Joris van der Hoeven
;;
;; This software falls under the GNU general public license version 3 or later.
;; It comes WITHOUT ANY WARRANTY WHATSOEVER. For details, see the file LICENSE
;; in the root directory or <http://www.gnu.org/licenses/gpl-3.0.html>.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(texmacs-module (generic format-geometry-edit)
  (:use (utils edit selections)
	(generic generic-edit)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Customizable step changes for length modifications
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define-preferences
  ("w increase" "0.05" noop)
  ("h increase" "0.05" noop)
  ("em increase" "0.1" noop)
  ("ex increase" "0.1" noop)
  ("spc increase" "0.2" noop)
  ("fn increase" "0.5" noop)
  ("mm increase" "0.5" noop)
  ("cm increase" "0.1" noop)
  ("inch increase" "0.05" noop)
  ("pt increase" "10" noop)
  ("msec increase" "50" noop)
  ("sec increase" "1" noop)
  ("min increase" "0.1" noop)
  ("% increase" "5" noop)
  ("default unit" "spc" noop))

(define step-table (make-ahash-table))
(define step-list
  '(0.005 0.01 0.02 0.05 0.1 0.2 0.5 1 2 5 10 20 50 100 200 500))
(define unit-list '("spc" "cm" "in" "em" "ex" "pt"))

(define (get-step unit)
  (when (not (ahash-ref step-table unit))
    (with pref (get-preference (string-append unit " increase"))
      (with step (if pref (string->number pref) 0.1)
	(ahash-set! step-table unit step))))
  (ahash-ref step-table unit))

(define (set-step unit step)
  (ahash-set! step-table unit step)
  (when (get-preference (string-append unit " increase"))
    (set-preference (string-append unit " increase") (number->string step))))

(define (change-step unit plus)
  (let* ((step (get-step unit))
	 (i (list-find-index step-list (lambda (x) (== x step))))
	 (j (and i (max 0 (min (+ i plus) (- (length step-list) 1)))))
	 (next (if j (list-ref step-list j) 0.1)))
    (set-step unit next)
    (set-message `(concat "Current step-size: " ,(number->string next) ,unit)
		 "Change step-size")))

(define (length-increase-step len inc)
  (with t (length-rightmost len)
    (when (tm-length? t)
      (change-step (tm-length-unit t) inc))))

(define (get-unit) (get-preference "default unit"))
(define (get-zero-unit) (string-append "0" (get-preference "default unit")))
(define (set-unit unit) (set-preference "default unit" unit))

(define (circulate-unit plus)
  (let* ((unit (get-unit))
	 (i (list-find-index unit-list (lambda (x) (== x unit))))
	 (j (and i (modulo (+ i plus) (length unit-list))))
	 (next (if j (list-ref unit-list j) "spc")))
    (set-unit next)
    (set-message `(concat "Default unit: " ,next)
		 "Change default unit")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Useful subroutines for length manipulations
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (length-increase t by)
  (cond ((tree-in? t '(plus minimum maximum))
	 (length-increase (tree-ref t :last) by))
	((tree-in? t '(minus))
	 (length-increase (tree-ref t :last) (- by)))
	((tm-length? t)
	 (let* ((l (tree->string t))
		(v (tm-length-value l))
		(u (tm-length-unit l))
		(a (get-step u))
		(new-v (+ v (* by a)))
		(new-l (tm-make-length new-v u)))
	   (tree-set t new-l)))))

(define (length-rightmost t)
  (cond ((tree-in? t '(plus minus minimum maximum))
	 (length-rightmost (tree-ref t :last)))
	(else t)))

(define (lengths-consistent? len1 len2)
  (let* ((t1 (length-rightmost len1))
	 (t2 (length-rightmost len2)))
    (and (tm-length? t1)
	 (tm-length? t2)
	 (== (tm-length-unit t1) (tm-length-unit t2)))))

(define (replace-empty t i by)
  (when (tree-empty? (tree-ref t i))
    (tree-assign (tree-ref t i) by)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Rigid horizontal spaces
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(tm-define (space-context? t)
  (tree-is? t 'space))

(tm-define (var-space-context? t)
  (or (tree-is? t 'space) (tree-func? t 'separating-space 1)))

(define (space-make-ternary t)
  (cond ((== (tm-arity t) 1) (tree-insert t 1 '("0ex" "1ex")))
	((== (tm-arity t) 2) (tree-insert t 1 '("1ex")))))

(define (space-consistent? t)
  (and (== (tm-arity t) 3)
       (lengths-consistent? (tree-ref t 1) (tree-ref t 2))))

(tm-define (geometry-speed t inc?)
  (:require (var-space-context? t))
  (with inc (if inc? 1 -1)
    (with-focus-after t
      (length-increase-step (tree-ref t 0) inc))))

(tm-define (geometry-horizontal t forward?)
  (:require (var-space-context? t))
  (with inc (if forward? 1 -1)
    (with-focus-after t
      (length-increase (tree-ref t 0) inc))))

(tm-define (geometry-vertical t down?)
  (:require (space-context? t))
  (with inc (if down? -1 1)
    (with-focus-after t
      (space-make-ternary t)
      (length-increase (tree-ref t 2) inc))))

(tm-define (geometry-incremental t down?)
  (:require (space-context? t))
  (with inc (if down? -1 1)
    (with-focus-after t
      (space-make-ternary t)
      (when (space-consistent? t)
	(length-increase (tree-ref t 1) inc)
	(length-increase (tree-ref t 2) inc)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Rubber horizontal spaces
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(tm-define (hspace-context? t)
  (tree-is? t 'hspace))

(define (rubber-space-consistent? t)
  (or (== (tm-arity t) 1)
      (and (== (tm-arity t) 3)
	   (lengths-consistent? (tree-ref t 0) (tree-ref t 1))
	   (lengths-consistent? (tree-ref t 1) (tree-ref t 2)))))

(define (rubber-space-increase t by)
  (when (rubber-space-consistent? t)
    (length-increase (tree-ref t 0) by)
    (when (== (tm-arity t) 3)
      (length-increase (tree-ref t 1) by)
      (length-increase (tree-ref t 2) by))))

(tm-define (geometry-speed t inc?)
  (:require (hspace-context? t))
  (with inc (if inc? 1 -1)
    (with-focus-after t
      (length-increase-step (tree-ref t 0) inc))))

(tm-define (geometry-horizontal t forward?)
  (:require (hspace-context? t))
  (with inc (if forward? 1 -1)
    (with-focus-after t
      (rubber-space-increase t inc))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Vertical spaces
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(tm-define (vspace-context? t)
  (tree-in? t '(vspace vspace*)))

(tm-define (geometry-speed t inc?)
  (:require (vspace-context? t))
  (with inc (if inc? 1 -1)
    (with-focus-after t
      (length-increase-step (tree-ref t 0) inc))))

(tm-define (geometry-vertical t down?)
  (:require (vspace-context? t))
  (with inc (if down? 1 -1)
    (with-focus-after t
      (rubber-space-increase t inc))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Move and shift
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(tm-define (move-context? t)
  (tree-in? t '(move shift)))

(tm-define (make-move hor ver)
  (:argument hor "Horizontal")
  (:argument ver "Vertical")
  (wrap-selection-small
    (insert-go-to `(move "" ,hor ,ver) '(0 0))))

(tm-define (make-shift hor ver)
  (:argument hor "Horizontal")
  (:argument ver "Vertical")
  (wrap-selection-small
    (insert-go-to `(shift "" ,hor ,ver) '(0 0))))

(tm-define (geometry-speed t inc?)
  (:require (move-context? t))
  (with inc (if inc? 1 -1)
    (with-focus-after t
      (length-increase-step (tree-ref t 1) inc)
      (when (not (lengths-consistent? (tree-ref t 1) (tree-ref t 2)))
        (length-increase-step (tree-ref t 2) inc)))))

(tm-define (geometry-variant t forward?)
  (:require (move-context? t))
  (circulate-unit (if forward? 1 -1)))

(tm-define (geometry-horizontal t forward?)
  (:require (move-context? t))
  (with inc (if forward? 1 -1)
    (with-focus-after t
      (replace-empty t 1 (get-zero-unit))
      (length-increase (tree-ref t 1) inc))))

(tm-define (geometry-vertical t down?)
  (:require (move-context? t))
  (with inc (if down? -1 1)
    (with-focus-after t
      (replace-empty t 2 (get-zero-unit))
      (length-increase (tree-ref t 2) inc))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Resize and clipped
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(tm-define (resize-context? t)
  (tree-in? t '(resize clipped)))

(tm-define (make-resize l b r t)
  (:argument l "Left")
  (:argument b "Bottom")
  (:argument r "Right")
  (:argument t "Top")
  (wrap-selection-small
    (insert-go-to `(resize "" ,l ,b ,r ,t) '(0 0))))

(tm-define (make-clipped l b r t)
  (:argument l "Left")
  (:argument b "Bottom")
  (:argument r "Right")
  (:argument t "Top")
  (wrap-selection-small
    (insert-go-to `(clipped "" ,l ,b ,r ,t) '(0 0))))

(define (replace-empty-horizontal t)
  (replace-empty t 1 `(plus "1l" ,(get-zero-unit)))
  (replace-empty t 3 `(plus "1r" ,(get-zero-unit))))

(define (replace-empty-vertical t)
  (replace-empty t 2 `(plus "1b" ,(get-zero-unit)))
  (replace-empty t 4 `(plus "1t" ,(get-zero-unit))))

(define (resize-consistent-horizontal? t)
  (replace-empty-horizontal t)
  (lengths-consistent? (tree-ref t 1) (tree-ref t 3)))

(define (resize-consistent-vertical? t)
  (replace-empty-vertical t)
  (lengths-consistent? (tree-ref t 2) (tree-ref t 4)))

(tm-define (geometry-speed t inc?)
  (:require (resize-context? t))
  (with inc (if inc? -1 1)
    (with-focus-after t
      (length-increase-step (tree-ref t 3) inc)
      (when (not (lengths-consistent? (tree-ref t 3) (tree-ref t 4)))
        (length-increase-step (tree-ref t 3) inc)))))

(tm-define (geometry-variant t forward?)
  (:require (resize-context? t))
  (circulate-unit (if forward? 1 -1)))

(tm-define (geometry-horizontal t forward?)
  (:require (resize-context? t))
  (with inc (if forward? 1 -1)
    (with-focus-after t
      (replace-empty-horizontal t)
      (length-increase (tree-ref t 3) inc))))

(tm-define (geometry-vertical t down?)
  (:require (resize-context? t))
  (with inc (if down? -1 1)
    (with-focus-after t
      (replace-empty-vertical t)
      (length-increase (tree-ref t 4) inc))))

(tm-define (geometry-extremal t forward?)
  (:require (resize-context? t))
  (with inc (if forward? 1 -1)
    (with-focus-after t
      (when (resize-consistent-horizontal? t)
        (length-increase (tree-ref t 1) inc)
        (length-increase (tree-ref t 3) inc)))))

(tm-define (geometry-incremental t down?)
  (:require (resize-context? t))
  (with inc (if down? -1 1)
    (with-focus-after t
      (when (resize-consistent-vertical? t)
        (length-increase (tree-ref t 2) inc)
        (length-increase (tree-ref t 4) inc)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Images
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(tm-define (image-context? t)
  (tm-func? t 'image 5))

(tm-define (geometry-speed t inc?)
  (:require (image-context? t))
  (with inc (if inc? 1 -1)
    (with-focus-after t
      (length-increase-step (tree-ref t 0) inc))))

(tm-define (geometry-horizontal t forward?)
  (:require (image-context? t))
  (with inc (if forward? 1 -1)
    (with-focus-after t
      (replace-empty t 1 "1w")
      (length-increase (tree-ref t 1) inc))))

(tm-define (geometry-vertical t down?)
  (:require (image-context? t))
  (with inc (if down? 1 -1)
    (with-focus-after t
      (replace-empty t 2 "1h")
      (length-increase (tree-ref t 2) inc))))

(tm-define (geometry-incremental t down?)
  (:require (image-context? t))
  (with inc (if down? -1 1)
    (with-focus-after t
      (replace-empty t 4 "0h")
      (length-increase (tree-ref t 4) inc))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Animations
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(tm-define (anim-context? t)
  (tree-in? t '(anim-constant anim-translate anum-progressive)))

(tm-define (make-anim-constant duration)
  (:argument duration "Duration")
  (insert-go-to `(anim-constant "" ,duration) '(0 0)))

(define (make-anim-translate duration start)
  (insert-go-to `(anim-translate "" ,duration ,start "") '(0 0)))

(tm-define (make-anim-translate-right duration)
  (:argument duration "Duration")
  (make-anim-translate duration '(tuple "-1.0" "0.0")))

(tm-define (make-anim-translate-left duration)
  (:argument duration "Duration")
  (make-anim-translate duration '(tuple "1.0" "0.0")))

(tm-define (make-anim-translate-up duration)
  (:argument duration "Duration")
  (make-anim-translate duration '(tuple "0.0" "-1.0")))

(tm-define (make-anim-translate-down duration)
  (:argument duration "Duration")
  (make-anim-translate duration '(tuple "0.0" "1.0")))

(define (make-anim-progressive duration start)
  (insert-go-to `(anim-progressive "" ,duration ,start "") '(0 0)))

(tm-define (make-anim-progressive-right duration)
  (:argument duration "Duration")
  (make-anim-progressive duration '(tuple "0.0" "0.0" "0.0" "1.0")))

(tm-define (make-anim-progressive-left duration)
  (:argument duration "Duration")
  (make-anim-progressive duration '(tuple "1.0" "0.0" "1.0" "1.0")))

(tm-define (make-anim-progressive-up duration)
  (:argument duration "Duration")
  (make-anim-progressive duration '(tuple "0.0" "0.0" "1.0" "0.0")))

(tm-define (make-anim-progressive-down duration)
  (:argument duration "Duration")
  (make-anim-progressive duration '(tuple "0.0" "1.0" "1.0" "1.0")))

(tm-define (make-anim-progressive-center duration)
  (:argument duration "Duration")
  (make-anim-progressive duration '(tuple "0.5" "0.5" "0.5" "0.5")))

(tm-define (geometry-speed t inc?)
  (:require (anim-context? t))
  (with inc (if inc? 1 -1)
    (with-focus-after t
      (length-increase-step (tree-ref t 1) inc))))

(tm-define (geometry-horizontal t forward?)
  (:require (anim-context? t))
  (with inc (if forward? 1 -1)
    (with-focus-after t
      (replace-empty t 1 "1sec")
      (length-increase (tree-ref t 1) inc))))