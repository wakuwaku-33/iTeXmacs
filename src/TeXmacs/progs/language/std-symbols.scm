
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; MODULE      : std-symbols.scm
;; DESCRIPTION : standard mathematical symbols
;; COPYRIGHT   : (C) 2010  Joris van der Hoeven
;;
;; This software falls under the GNU general public license version 3 or later.
;; It comes WITHOUT ANY WARRANTY WHATSOEVER. For details, see the file LICENSE
;; in the root directory or <http://www.gnu.org/licenses/gpl-3.0.html>.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(texmacs-module (language std-symbols))

(define-language std-symbols
  (:synopsis "default semantics for mathematical symbols")

  (define Assign-symbol
    (:type infix)
    (:penalty 3)
    (:spacing default default)
    "<assign>" "<plusassign>" "<minusassign>" "<astassign>" "<overassign>")
  
  (define Flux-symbol
    (:type associative-infix)
    (:spacing default default)
    "<lflux>" "<gflux>")

  (define Models-symbol
    (:type infix)
    (:spacing default default)
    "<models>" "<vdash>" "<dashv>" "<vDash>" "<Vdash>" "<Vvdash>" "<VDash>"
    "<longvdash>" "<longdashv>" "<longvDash>"
    "<longVdash>" "<longVvdash>" "<longVDash>"
    "<nvdash>" "<ndashv>" "<nvDash>" "<nVdash>" "<nVvdash>" "<nVDash>")

  (define Quantifier-symbol
    (:type prefix)
    "<forall>" "<exists>" "<nexists>")

  (define Imply-nolim-symbol
    (:type infix)
    (:penalty 10)
    (:spacing default default)
    "<implies>" "<equivalent>" "<Leftarrow>" "<Rightarrow>" "<Leftrightarrow>"
    "<Longleftarrow>" "<Longrightarrow>" "<Longleftrightarrow>"
    "<Lleftarrow>" "<Rrightarrow>"
    "<nLeftarrow>" "<nRightarrow>" "<nLeftrightarrow>")

  (define Imply-lim-symbol
    (:type infix)
    (:penalty 10)
    (:spacing default default)
    (:limits always)
    "<Leftarrowlim>" "<Rightarrowlim>" "<Leftrightarrowlim>"
    "<Longleftarrowlim>" "<Longrightarrowlim>" "<Longleftrightarrowlim>")
  
  (define Imply-symbol
    Imply-nolim-symbol Imply-symbol)

  (define Or-symbol
    (:type associative-infix)
    (:penalty 10)
    (:spacing default default)
    "<vee>" "<curlyvee>")

  (define And-symbol
    (:type associative-infix)
    (:penalty 10)
    (:spacing default default)
    "<wedge>" "<curlywedge>")

  (define Not-symbol
    (:type prefix)
    (:penalty 10)
    "<neg>")

  (define Relation-nolim-symbol
    (:type infix)
    (:penalty 20)
    (:spacing default default)

    "=" "<ne>" "<neq>" "<longequal>" "<less>" "<gtr>" "<le>" "<leq>"
    "<prec>" "<preceq>" "<ll>" "<lleq>" "<subset>" "<subseteq>"
    "<sqsubset>" "<sqsubseteq>" "<in>" "<ge>" "<geq>" "<succ>" "<succeq>"
    "<gg>" "<ggeq>" "<supset>" "<supseteq>" "<sqsupset>" "<sqsupseteq>" "<ni>"
    "<equiv>" "<nequiv>" "<sim>" "<simeq>" "<asymp>" "<approx>" "<cong>"
    "<subsetsim>" "<supsetsim>" "<doteq>" "<propto>" "<varpropto>"
    "<perp>" "<bowtie>" "<Join>" "<smile>" "<frown>" "<signchange>"
    "<mid>" "<parallel>" "<shortmid>" "<shortparallel>" "<nmid>"
    "<nparallel>" "<nshortmid>" "<nshortparallel>"

    "<approxeq>" "<backsim>" "<backsimeq>" "<Bumpeq>" "<bumpeq>" "<circeq>"
    "<curlyeqprec>" "<curlyeqsucc>" "<Doteq>" "<doteqdot>" "<eqcirc>"
    "<eqslantgtr>" "<eqslantless>" "<fallingdotseq>" "<geqq>" "<geqslant>"
    "<ggg>" "<gggtr>" "<gnapprox>" "<gneq>" "<gneqq>" "<gnsim>" "<gtrapprox>"
    "<gtrdot>" "<gtreqdot>" "<gtreqless>" "<gtreqqless>" "<gtrless>"
    "<gtrsim>" "<gvertneqq>" "<leqq>" "<leqslant>" "<lessapprox>"
    "<lessdot>" "<lesseqdot>" "<lesseqgtr>" "<lesseqqgtr>" "<lessgtr>"
    "<lesssim>" "<lll>" "<llless>" "<lnapprox>" "<lneq>" "<lneqq>"
    "<lnsim>" "<lvertneqq>" "<napprox>" "<ngeq>" "<ngeqq>" "<ngeqslant>"
    "<ngtr>" "<nleq>" "<nleqq>" "<nleqslant>" "<nless>" "<nprec>" "<npreceq>"
    "<nsim>" "<nasymp>" "<nsubset>" "<nsupset>" "<nsqsubset>" "<nsqsupset>"
    "<nsqsubseteq>" "<nsqsupseteq>" "<nsubseteq>" "<nsucc>" "<nsucceq>"
    "<nsupseteq>" "<nsupseteqq>" "<nvdash>" "<precapprox>" "<preccurlyeq>"
    "<npreccurlyeq>" "<precnapprox>" "<precneqq>" "<precnsim>" "<risingdoteq>"
    "<Subset>" "<subseteqq>" "<subsetneq>" "<subsetneqq>" "<succapprox>"
    "<succcurlyeq>" "<nsucccurlyeq>" "<succnapprox>" "<succneqq>"
    "<succnsim>" "<succsim>" "<Supset>" "<supseteqq>" "<supsetneq>"
    "<thickapprox>" "<thicksim>" "<varsubsetneq>" "<varsubsetneqq>"
    "<varsupsetneq>" "<varsupsetneqq>"

    "<vartriangleleft>" "<vartriangleright>"
    "<triangleleft>" "<triangleright>"
    "<trianglelefteq>" "<trianglerighteq>" "<trianglelefteqslant>"
    "<trianglerighteqslant>" "<blacktriangleleft>" "<blacktriangleright>"
    "<ntriangleleft>" "<ntriangleright>"
    "<ntrianglelefteq>" "<ntrianglerighteq>"
    "<ntrianglelefteqslant>" "<ntrianglerighteqslant>"

    "<precprec>" "<precpreceq>" "<precprecprec>" "<precprecpreceq>"
    "<succsucc>" "<succsucceq>" "<succsuccsucc>" "<succsuccsucceq>"
    "<nprecprec>" "<nprecpreceq>" "<nprecprecprec>" "<nprecprecpreceq>"
    "<nsuccsucc>" "<nsuccsucceq>" "<nsuccsuccsucc>" "<nsuccsuccsucceq>"
    "<asympasymp>" "<nasympasymp>" "<simsim>" "<nsimsim>" "<nin>" "<nni>"
    "<notin>" "<notni>" "<precdot>" "<preceqdot>" "<dotsucc>" "<dotsucceq>")

  (define Relation-lim-symbol
    (:type infix)
    (:penalty 20)
    (:spacing default default)
    (:limits always)
    "<equallim>" "<longequallim>")

  (define Relation-symbol
    Relation-nolim-symbol Relaton-symbol)

  (define Arrow-nolim-symbol
    (:type infix)
    (:penalty 20)
    (:spacing default default)

    "<to>" "<into>" "<from>" "<transtype>" "<leftarrow>" "<rightarrow>"
    "<leftrightarrow>" "<mapsto>" "<mapsfrom>"
    "<hookleftarrow>" "<hookrightarrow>"
    "<longleftarrow>" "<longrightarrow>" "<longleftrightarrow>"
    "<longmapsto>" "<longmapsfrom>"
    "<longhookleftarrow>" "<longhookrightarrow>" "<leftharpoonup>"
    "<leftharpoondown>" "<rightleftharpoons>" "<rightharpoonup>"
    "<rightharpoondown>" "<leadsto>" "<noarrow>" "<searrow>" "<swarrow>"
    "<nwarrow>" "<longtwoheadleftarrow>" "<longtwoheadrightarrow>"
    "<leftprec>" "<leftpreceq>" "<succright>" "<succeqright>"

    "<circlearrowleft>" "<circlearrowdown>"
    "<curvearrowleft>" "<curvearrowright>"
    "<downdownarrows>" "<downharpoonleft>" "<downharpoonright>"
    "<leftarrowtail>" "<leftleftarrows>" "<leftrightarrows>"
    "<leftrightharpoons>"
    "<looparrowleft>" "<looparrowright>" "<Lsh>" "<multimap>"
    "<nleftarrow>" "<nleftrightarrow>" "<nrightarrow>" "<restriction>"
    "<rightarrowtail>" "<rightleftarrows>" "<rightleftharpoons>"
    "<rightrightarrows>" "<rightsquigarrow>" "<Rsh>" "<twoheadleftarrow>"
    "<twoheadrightarrow>" "<upharpoonleft>" "<upharpoonright>" "<upuparrows>")
  
  (define Arrow-lim-symbol
    (:type infix)
    (:penalty 20)
    (:spacing default default)
    (:limits always)
    "<leftarrowlim>" "<rightarrowlim>" "<leftrightarrowlim>"
    "<longleftarrowlim>" "<longrightarrowlim>" "<longleftrightarrowlim>"
    "<mapstolim>" "<longmapstolim>"
    "<leftsquigarrowlim>" "<rightsquigarrowlim>" "<leftrightsquigarrowlim>")

  (define Arrow-symbol
    Arrow-nolim-symbol Arrow-lim-symbol)

  (define Union-symbol
    (:type associative-infix)
    (:penalty 30)
    (:spacing default default)
    "<cup>" "<Cup>" "<doublecup>")

  (define Intersection-symbol
    (:type associative-infix)
    (:penalty 30)
    (:spacing default default)
    "<cap>" "<Cap>" "<doublecap>")

  (define Exclude-symbol
    (:type left-associative-infix)
    (:penalty 30)
    (:spacing default default)
    "<setminus>" "<smallsetminus>")

  (define Plus-symbol
    (:type associative-infix)
    (:penalty 30)
    (:spacing default default)
    "+" "<amalg>" "<oplus>" "<boxplus>" "<dotplus>" "<dotamalg>" "<dotoplus>")

  (define Minus-symbol
    (:type left-associative-infix)
    (:penalty 30)
    (:spacing default default)
    "-" "<pm>" "<mp>" "<ominus>" "<boxminus>")

  (define Times-visible-symbol
    (:type associative-infix)
    (:penalty 40)
    (:spacing default default)
    "<cdot>" "<times>" "<otimes>" "<circ>" "<boxdot>" "<boxtimes>"
    "<dottimes>" "<dototimes>" "<ltimes>" "<rtimes>" "<atimes>" "<btimes>"
    "<join>" "<ast>" "<star>" "<oast>")

  (define Times-invisible-symbol
    (:type associative-infix)
    (:penalty invalid)
    (:spacing none default)
    "*")

  (define Times-symbol
    Times-visible-symbol Times-invisible-symbol)

  (define Over-regular-symbol
    (:type left-associative-infix)
    (:penalty 40)
    (:spacing default default)
    "<oover>")

  (define Over-condensed-symbol
    (:type left-associative-infix)
    (:penalty 40)
    "/")

  (define Over-symbol
    Over-regular-symbol Over-condensed-symbol)

  (define Power-symbol
    (:type infix)
    (:penalty 50)
    "^")

  (define Index-symbol
    (:type infix)
    (:penalty 50)
    "_")

  (define Big-nolim-symbol
    (:type prefix)
    (:penalty panic)
    (:spacing none big)
    "<big-int>" "<big-oint>")

  (define Big-lim-symbol
    (:type prefix)
    (:penalty panic)
    (:spacing none big)
    (:limits display)
    "<big-sum>" "<big-prod>" "<big-amalg>" "<big-intlim>" "<big-ointlim>"
    "<big-cap>" "<big-cup>" "<big-sqcup>" "<big-vee>" "<big-wedge>"
    "<big-odot>" "<big-otimes>" "<big-oplus>" "<big-uplus>"
    "<big-triangleup>" "<big-triangledown>")

  (define Big-symbol
    Big-nolim-symbol Big-lim-symbol)

  (define Prefix-symbol
    (:type prefix)
    (:penalty invalid)
    (:spacing none none)
    "<um>" "<upl>" "<upm>" "<ump>" "<card>")

  (define Postfix-symbol
    (:type postfix)
    (:penalty panic)
    "!")

  (define Prime-symbol
    (:type symbol)
    (:penalty panic)
    "'" "`" "<dag>" "<ddag>")

  (define Open-symbol
    (:type opening-bracket)
    "(" "[" "{" "<lfloor>" "<lceil>" "<langle>"
    "<left-(>" "<left-[>" "<left-{>" "<left-less>"
    "<left-}>" "<left-]>" "<left-)>" "<left-gtr>"
    "<left-|>" "<left-||>" "<left-.>"
    "<left-lfloor>" "<left-lceil>" "<left-rfloor>" "<left-rceil>"
    "<left-langle>" "<left-rangle>")
  
  (define Ponctuation-symbol
    (:type separator)
    (:spacing none default)
    (:penalty 0)
    "," ";" ":")

  (define Bar-symbol
    (:type symbol)
    "|" "<||>" "<mid-|>" "<mid-||>")

  (define Close-symbol
    (:type closing-bracket)
    "}" "]" ")" "<rfloor>" "<rceil>" "<rangle>"
    "<right-(>" "<right-[>" "<right-{>" "<right-less>"
    "<right-}>" "<right-]>" "<right-)>" "<right-gtr>"
    "<right-|>" "<right-||>" "<right-.>"
    "<right-lfloor>" "<right-lceil>" "<right-rfloor>" "<right-rceil>"
    "<right-langle>" "<right-rangle>")

  (define Suspension-nolim-symbol
    (:type symbol)
    (:penalty invalid invalid)
    "<ldots>" "<cdots>" "<udots>" "<vdots>" "<ddots>" "<mdots>" "<colons>")
  
  (define Suspension-lim-symbol
    (:type symbol)
    (:penalty invalid invalid)
    (:limits always)
    "<cdotslim>")

  (define Suspension-symbol
    Suspension-nolim-symbol Suspension-lim-symbol)

  (define Variable-symbol
    (:type symbol)
    "<alpha>" "<beta>" "<gamma>" "<delta>" "<varepsilon>"
    "<epsilon>" "<zeta>" "<eta>" "<theta>" "<iota>"
    "<kappa>" "<lambda>" "<mu>" "<nu>" "<xi>" "<omikron>"
    "<varpi>" "<pi>" "<rho>" "<sigma>" "<tau>" "<upsilon>"
    "<varphi>" "<phi>" "<psi>" "<chi>" "<omega>"

    "<Alpha>" "<Beta>" "<Gamma>" "<Delta>" "<Varepsilon>"
    "<Epsilon>" "<Zeta>" "<Eta>" "<Theta>" "<Iota>"
    "<Kappa>" "<Lambda>" "<Mu>" "<Nu>" "<Xi>" "<Omikron>"
    "<Varpi>" "<Pi>" "<Rho>" "<Sigma>" "<Tau>" "<Upsilon>"
    "<Varphi>" "<Phi>" "<Psi>" "<Chi>" "<Omega>"

    "<b-alpha>" "<b-beta>" "<b-gamma>" "<b-delta>" "<b-varepsilon>"
    "<b-epsilon>" "<b-zeta>" "<b-eta>" "<b-theta>" "<b-iota>"
    "<b-kappa>" "<b-lambda>" "<b-mu>" "<b-nu>" "<b-xi>" "<b-omikron>"
    "<b-varpi>" "<b-pi>" "<b-rho>" "<b-sigma>" "<b-tau>" "<b-upsilon>"
    "<b-varphi>" "<b-phi>" "<b-psi>" "<b-chi>" "<b-omega>"

    "<b-Alpha>" "<b-Beta>" "<b-Gamma>" "<b-Delta>" "<b-Varepsilon>"
    "<b-Epsilon>" "<b-Zeta>" "<b-Eta>" "<b-Theta>" "<b-Iota>"
    "<b-Kappa>" "<b-Lambda>" "<b-Mu>" "<b-Nu>" "<b-Xi>" "<b-Omikron>"
    "<b-Varpi>" "<b-Pi>" "<b-Rho>" "<b-Sigma>" "<b-Tau>" "<b-Upsilon>"
    "<b-Varphi>" "<b-Phi>" "<b-Psi>" "<b-Chi>" "<b-Omega>"

    "<b-a>" "<b-b>" "<b-c>" "<b-d>" "<b-e>" "<b-f>" "<b-g>"
    "<b-h>" "<b-i>" "<b-j>" "<b-k>" "<b-l>" "<b-m>" "<b-n>"
    "<b-o>" "<b-p>" "<b-q>" "<b-r>" "<b-s>" "<b-t>" "<b-u>"
    "<b-v>" "<b-w>" "<b-x>" "<b-y>" "<b-z>"

    "<b-A>" "<b-B>" "<b-C>" "<b-D>" "<b-E>" "<b-F>" "<b-G>"
    "<b-H>" "<b-I>" "<b-J>" "<b-K>" "<b-L>" "<b-M>" "<b-N>"
    "<b-O>" "<b-P>" "<b-Q>" "<b-R>" "<b-S>" "<b-T>" "<b-U>"
    "<b-V>" "<b-W>" "<b-X>" "<b-Y>" "<b-Z>"
    
    "<cal-A>" "<cal-B>" "<cal-C>" "<cal-D>" "<cal-E>" "<cal-F>" "<cal-G>"
    "<cal-H>" "<cal-I>" "<cal-J>" "<cal-K>" "<cal-L>" "<cal-M>" "<cal-N>"
    "<cal-O>" "<cal-P>" "<cal-Q>" "<cal-R>" "<cal-S>" "<cal-T>" "<cal-U>"
    "<cal-V>" "<cal-W>" "<cal-X>" "<cal-Y>" "<cal-Z>"

    "<b-cal-A>" "<b-cal-B>" "<b-cal-C>" "<b-cal-D>" "<b-cal-E>" "<b-cal-F>"
    "<b-cal-G>" "<b-cal-H>" "<b-cal-I>" "<b-cal-J>" "<b-cal-K>" "<b-cal-L>"
    "<b-cal-M>" "<b-cal-N>" "<b-cal-O>" "<b-cal-P>" "<b-cal-Q>" "<b-cal-R>"
    "<b-cal-S>" "<b-cal-T>" "<b-cal-U>" "<b-cal-V>" "<b-cal-W>" "<b-cal-X>"
    "<b-cal-Y>" "<b-cal-Z>"

    "<frak-a>" "<frak-b>" "<frak-c>" "<frak-d>" "<frak-e>" "<frak-f>"
    "<frak-g>" "<frak-h>" "<frak-i>" "<frak-j>" "<frak-k>" "<frak-l>"
    "<frak-m>" "<frak-n>" "<frak-o>" "<frak-p>" "<frak-q>" "<frak-r>"
    "<frak-s>" "<frak-t>" "<frak-u>" "<frak-v>" "<frak-w>" "<frak-x>"
    "<frak-y>" "<frak-z>"

    "<frak-A>" "<frak-B>" "<frak-C>" "<frak-D>" "<frak-E>" "<frak-F>"
    "<frak-G>" "<frak-H>" "<frak-I>" "<frak-J>" "<frak-K>" "<frak-L>"
    "<frak-M>" "<frak-N>" "<frak-O>" "<frak-P>" "<frak-Q>" "<frak-R>"
    "<frak-S>" "<frak-T>" "<frak-U>" "<frak-V>" "<frak-W>" "<frak-X>"
    "<frak-Y>" "<frak-Z>"

    "<bbb-A>" "<bbb-B>" "<bbb-C>" "<bbb-D>" "<bbb-E>" "<bbb-F>" "<bbb-G>"
    "<bbb-H>" "<bbb-I>" "<bbb-J>" "<bbb-K>" "<bbb-L>" "<bbb-M>" "<bbb-N>"
    "<bbb-O>" "<bbb-P>" "<bbb-Q>" "<bbb-R>" "<bbb-S>" "<bbb-T>" "<bbb-U>"
    "<bbb-V>" "<bbb-W>" "<bbb-X>" "<bbb-Y>" "<bbb-Z>")
  
  (define Miscellaneous-symbol
    (:type symbol)

    "<ldot>" "<udot>"

    "<uparrow>" "<Uparrow>" "<downarrow>" "<Downarrow>"
    "<updownarrow>" "<Updownarrow>" "<mapsup>" "<mapsdown>"
    "<hookuparrow>" "<hookdownarrow>" "<longuparrow>" "<Longuparrow>"
    "<longdownarrow>" "<Longdownarrow>" "<longupdownarrow>" "<Longupdownarrow>"
    "<longmapsup>" "<longmapsdown>" "<longhookuparrow>" "<longhookdownarrow>"

    "<aleph>" "<hbar>" "<imath>" "<jmath>" "<ell>"
    "<wp>" "<Re>" "<Im>" "<Mho>" "<prime>" "<emptyset>"
    "<nabla>" "<surd>" "<top>" "<bot>" "<angle>"
    "<bflat>" "<natural>" "<sharp>" "<backslash>"
    "<partial>" "<infty>" "<infty>" "<Box>" "<Diamont>"
    "<triangle>" "<clubsuit>" "<diamondsuit>" "<heartsuit>"
    "<spadesuit>" "<diamond>"

    "<backepsilon>" "<backprime>" "<barwedge>" "<because>"
    "<beth>" "<between>" "<bigstar>" "<blacklozenge>"
    "<blacksquare>" "<blacktriangle>" "<blacktriangledown>"
    "<centerdot>" "<checkmark>" "<circledast>" "<circledcirc>"
    "<circleddash>" "<complement>" "<daleth>" "<digamma>"
    "<divideontimes>" "<doublebarwedge>" "<gimel>"
    "<hbar>" "<hslash>" "<intercal>" "<leftthreetimes>" "<llcorner>"
    "<lozenge>" "<lrcorner>" "<maltese>" "<measuredangle>"
    "<pitchfork>" "<rightthreetimes>"
    "<smallfrown>" "<smallsmile>" "<sphericalangle>"
    "<square>" "<therefore>" "<thorn>" "<triangledown>"
    "<triangleq>" "<ulcorner>" "<urcorner>" "<varkappa>"
    "<varnothing>" "<vartriangle>" "<veebar>" "<yen>"

    "<comma>")

  (define Spacing-symbol
    (:type symbol)
    (:spacing big none)
    "<spc>")

  (define Prefix-operator
    (:type prefix)
    (:penalty panic)
    (:spacing none default)
    "arccos" "arcsin" "arctan" "cos" "cosh" "cot" "coth" "csc"
    "deg" "det" "dim" "exp" "gcd" "hom" "ker" "Pr"
    "lg" "ln" "log" "sec" "sin" "sinh" "tan" "tanh")

  (define Infix-operator
    (:type infix)
    (:penalty panic)
    (:spacing default default)
    "div" "mod")

  (define Big-operator
    (:type prefix)
    (:penalty panic)
    (:spacing none default)
    (:limits display)
    "inf" "lim" "liminf" "limsup" "max" "min" "sup")

  (define Reserved
    :<frac :<sqrt :<wide
    :<left :<mid :<right :<big
    :<lsub :<lsup :<rsub :<rsup :<lprime :<rprime))