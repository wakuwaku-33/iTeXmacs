
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; MODULE      : fonts-composite.scm
;; DESCRIPTION : agglomerated fonts
;; COPYRIGHT   : (C) 2005  Joris van der Hoeven
;;
;; This software falls under the GNU general public license version 3 or later.
;; It comes WITHOUT ANY WARRANTY WHATSOEVER. For details, see the file LICENSE
;; in the root directory or <http://www.gnu.org/licenses/gpl-3.0.html>.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(texmacs-module (fonts fonts-composite))

(set-font-rules
  `(((modern $v $a $b $s $d)
     (compound (ec (roman $v $a $b $s $d))
	       (la (cyrillic $v $a $b $s $d))
	       (cmr (tex cmr $s $d))
	       (cmmi (tex cmmi $s $d))
	       (cmsy (tex cmsy $s $d))
	       (msam (tex msam $s $d))
	       (msbm (tex $sbm $s $d))
	       (stmary (tex stmary $s $d))
	       (wasy (tex wasy $s $d))
	       (line (tex line $s $d))
	       (cmex (tex cmex $s $d))
	       (math-cal (tex cmsy $s $d))
	       (math-frak (tex eufm $s $d))
	       (math-bbb (tex bbm $s $d))
	       (math-upgreek (tex grmn $s $d))
	       (math-bold-1 (tex cmbx $s $d))
	       (math-bold-2 (tex cmmib $s $d))
	       (math-bold-cal (tex cmbsy $s $d))
	       (long (virtual long $s $d))
	       (negate (virtual negate $s $d))
	       (misc (virtual misc $s $d))
           ,@(cond 
              ((os-mingw?) 
                '((hangul (batang $v $a $b $s $d))
                  (oriental (msmincho $v $a $b $s $d))))
              ((os-macos?) 
                '((hangul (apple-myungjo $v $a $b $s $d))
                  (oriental (hiragino $v $a $b $s $d))))
              (else
                '((hangul (unbatang $v $a $b $s $d))
                  (oriental (takao $v $a $b $s $d)))))
	       (any (roman $v $a $b $s $d))))))

(set-font-rules
  `(((songti $v $a $b $s $d)
     (compound (ec (roman $v $a $b $s $d))
           (la (cyrillic $v $a $b $s $d))
           (cmr (tex cmr $s $d))
           (cmmi (tex cmmi $s $d))
           ;(cmsy (tex cmsy $s $d))
           ;(msam (tex msam $s $d))
           ;(msbm (tex $sbm $s $d))
           ;(stmary (tex stmary $s $d))
           ;(wasy (tex wasy $s $d))
           ;(line (tex line $s $d))
           ;(cmex (tex cmex $s $d))
           ;(math-cal (tex cmsy $s $d))
           ;(math-frak (tex eufm $s $d))
           ;(math-bbb (tex bbm $s $d))
           ;(math-upgreek (tex grmn $s $d))
           ;(math-bold-1 (tex cmbx $s $d))
           ;(math-bold-2 (tex cmmib $s $d))
           ;(math-bold-cal (tex cmbsy $s $d))
           ;(long (virtual long $s $d))
           ;(negate (virtual negate $s $d))
           ;(misc (virtual misc $s $d))
           ,@(cond 
              ((os-mingw?) 
                '((hangul (batang $v $a $b $s $d))
                  (oriental (simsun $v $a $b $s $d))))
              ((os-macos?) 
                '((hangul (apple-gothic $v $a $b $s $d))
                  (oriental (stsong $v $a $b $s $d))))
              (else
                '((hangul (unbatang $v $a $b $s $d))
                  (oriental (uming $v $a $b $s $d)))))
           (any (roman $v $a $b $s $d))))))

(set-font-rules
  `(((mingti $v $a $b $s $d)
     (compound (ec (roman $v $a $b $s $d))
           (la (cyrillic $v $a $b $s $d))
           (cmr (tex cmr $s $d))
           (cmmi (tex cmmi $s $d))
           ;(cmsy (tex cmsy $s $d))
           ;(msam (tex msam $s $d))
           ;(msbm (tex $sbm $s $d))
           ;(stmary (tex stmary $s $d))
           ;(wasy (tex wasy $s $d))
           ;(line (tex line $s $d))
           ;(cmex (tex cmex $s $d))
           ;(math-cal (tex cmsy $s $d))
           ;(math-frak (tex eufm $s $d))
           ;(math-bbb (tex bbm $s $d))
           ;(math-upgreek (tex grmn $s $d))
           ;(math-bold-1 (tex cmbx $s $d))
           ;(math-bold-2 (tex cmmib $s $d))
           ;(math-bold-cal (tex cmbsy $s $d))
           ;(long (virtual long $s $d))
           ;(negate (virtual negate $s $d))
           ;(misc (virtual misc $s $d))
           ,@(cond 
              ((os-mingw?) 
                '((hangul (batang $v $a $b $s $d))
                  (oriental (mingliu $v $a $b $s $d))))
              ((os-macos?) 
                '((hangul (apple-gothic $v $a $b $s $d))
                  (oriental (lisong $v $a $b $s $d))))
              (else   
                '((hangul (unbatang $v $a $b $s $d))
                  (oriental (bsmi $v $a $b $s $d)))))
           (any (roman $v $a $b $s $d))))))
