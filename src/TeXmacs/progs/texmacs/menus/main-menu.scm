
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; MODULE      : main-menu.scm
;; DESCRIPTION : the default main menu of TeXmacs
;; COPYRIGHT   : (C) 1999  Joris van der Hoeven
;;
;; This software falls under the GNU general public license version 3 or later.
;; It comes WITHOUT ANY WARRANTY WHATSOEVER. For details, see the file LICENSE
;; in the root directory or <http://www.gnu.org/licenses/gpl-3.0.html>.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(texmacs-module (texmacs menus main-menu)
  (:use (utils library cursor)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Main dynamic, extensible or user defined submenus
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(menu-bind texmacs-extra-menu)
(menu-bind texmacs-extra-icons)
(tm-define (buffer-menu) (get-buffer-menu))
(tm-define (project-buffer-menu) (get-project-buffer-menu))
(tm-define (style-menu) (get-style-menu))
(tm-define (add-package-menu) (get-add-package-menu))
(tm-define (remove-package-menu) (get-remove-package-menu))
(menu-bind bookmarks-menu)
(menu-bind test-menu)
(menu-bind help-icons (if (in-session?) (link session-help-icons)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The TeXmacs main menu
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(menu-bind texmacs-menu
  (=> "File" (link file-menu))
  (=> "Edit" (link edit-menu))
  (if (in-graphics?)
      (=> "Insert" (link graphics-insert-menu))
      (=> "Focus" (link graphics-focus-menu)))
  (if (not (in-graphics?))
      (=> "Insert" (link insert-menu))
      (if (or (in-source?) (with-source-tool?))
	  (=> "Source" (link source-menu)))
      (if (with-linking-tool?)
	  (=> "Link" (link link-menu)))
      (if (in-presentation?)
	  (=> "Dynamic" (link dynamic-menu)))
      (link texmacs-extra-menu)
      (=> "Focus" (link focus-menu))
      (=> "Format" (link format-menu)))
  (=> "Document" (link document-menu))
  (if (and (not (project-attached?))
       (== (get-init-tree "sectional-short-style") (tree 'macro "false")))
      (=> "Part" (link document-part-menu)))
  (if (project-attached?) (=> "Project" (link project-menu)))
  (if (with-versioning-tool?)
      (=> "Version" (link version-menu)))
  (=> "View" (link view-menu))
  (=> "Go" (link go-menu))
  (=> "Tools" (link tools-menu))
  (if (with-remote-connections?)
      (=> "Remote" (link remote-menu)))
  (if (with-debugging-tool?)
      (=> "Debug" (link debug-menu)))
  (if (nnull? (test-menu))
      (=> "Test" (link test-menu)))
  (=> "Help" (link help-menu)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The TeXmacs popup menu
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
#!
(menu-bind texmacs-popup-menu
  (link focus-menu)
  ---
  (-> "File" (link file-menu))
  (-> "Edit" (link edit-menu))
  (if (in-graphics?)
      (-> "Insert" (link graphics-insert-menu))
      (-> "Focus" (link graphics-focus-menu)))
  (if (not (in-graphics?))
      (-> "Insert" (link insert-menu))
      (if (or (in-source?) (with-source-tool?))
	  (-> "Source" (link source-menu)))
      (if (with-linking-tool?)
	  (-> "Link" (link link-menu)))
      (if (in-presentation?)
	  (-> "Dynamic" (link dynamic-menu)))
      (-> "Format" (link format-menu)))
  (-> "Document" (link document-menu))
  (if (== (get-init-tree "sectional-short-style") (tree 'macro "false"))
      (-> "Part" (link document-part-menu)))
  (if (project-attached?) (=> "Project" (link project-menu)))
  (if (with-versioning-tool?) (-> "Version" (link version-menu)))
  (-> "View" (link view-menu))
  (-> "Go" (link go-menu))
  (if (detailed-menus?) (-> "Tools" (link tools-menu)))
  (if (with-remote-connections?) (-> "Remote" (link remote-menu)))
  (if (with-debugging-tool?) (-> "Debug" (link debug-menu)))
  (if (nnull? (test-menu)) (-> "Test" (link test-menu)))
  ---
  (-> "Help" (link help-menu)))
!#
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The main icon bar
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(if (x-gui?)
(menu-bind texmacs-main-icons
  (=> (balloon (icon "tm_new.xpm") "Create a new document")
      (link new-file-menu))
  (=> (balloon (icon "tm_open.xpm") "Load a file") (link load-menu))
  (=> (balloon (icon "tm_save.xpm") "Save this buffer") (link save-menu))
  (if (experimental-qt-gui?)
      ((balloon (icon "tm_print.xpm") "Print") (interactive-print-buffer)))
  (if (not (experimental-qt-gui?))
      (=> (balloon (icon "tm_print.xpm") "Print") (link print-menu)))
  (if (detailed-menus?)
      ;;(=> (balloon (icon "tm_style.xpm") "Select a document style")
      ;;(link document-style-menu))
      (=> (balloon (icon "tm_language.xpm") "Select a language")
      (link global-language-menu)))
  (=> (balloon (icon "tm_cancel.xpm") "Close") (link close-menu))
  |
  ((balloon (icon "tm_cut.xpm") "Cut text")
   (clipboard-cut "primary"))
  ((balloon (icon "tm_copy.xpm") "Copy text")
   (clipboard-copy "primary"))
  ((balloon (icon "tm_paste.xpm") "Paste text")
   (clipboard-paste "primary"))
  (if (not (in-search-mode?))
      ((balloon (icon "tm_find.xpm") "Find text") (search-start #t)))
  (if (in-search-mode?)
      ((balloon (icon "tm_find_next.xpm") "Find next match")
       (search-button-next)))
  ((balloon (icon "tm_replace.xpm") "Query replace")
   (interactive replace-start-forward))
  (if (not (in-math?))
      ((balloon (icon "tm_spell.xpm") "Check text for spelling errors")
       (spell-start)))
  (if (in-math?)
      (=> (balloon (icon "tm_spell.xpm") "Correct mathematical formulas")
          (link math-correct-menu)))
  ((balloon (icon "tm_undo.xpm") "Undo last changes") (undo 0))
  ((balloon (icon "tm_redo.xpm") "Redo undone changes") (redo 0))
  |
  ((balloon (icon "tm_back.xpm") "Browse back")
   (cursor-history-backward))
  ((balloon (icon "tm_reload.xpm") "Reload")
   (revert-buffer))
  ((balloon (icon "tm_forward.xpm") "Browse forward")
   (cursor-history-forward))
  (if (in-presentation?)
    |
    (link dynamic-icons)))
)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The mode dependent icon bar
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(menu-bind texmacs-mode-icons
  (if (in-source?) (link source-icons))
  (if (in-text?) (link text-icons))
  (if (in-math?) (link math-icons))
  (if (in-prog?) (link prog-icons))
  (if (in-graphics?) (link graphics-icons))
  (link help-icons))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; iTeXmacs: the popup menu
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(menu-bind texmacs-popup-menu
  (when (or (selection-active-any?)
        (and (in-graphics?)
         (graphics-selection-active?)))
    ("Copy" (clipboard-copy "primary"))
    ("Cut" (clipboard-cut "primary")))
  ("Paste" (clipboard-paste "primary"))
  ---
  (if (and (in-text?) (not (in-table?)))
    ("Strong" (make 'strong))
    ("Emphasize" (make 'em))
    ---
    (if (and (style-has? "section-base-dtd")
          (not (style-has? "header-exam-dtd")))
        (-> "Section" (link section-menu)))
    (if (style-has? "std-markup-dtd")
        (-> "Size tag" (link size-tag-menu)))
    (if (style-has? "std-list-dtd")
        (-> "Itemize" (link itemize-menu))
        (-> "Enumerate" (link enumerate-menu))))
  (if (in-math?)
    (if (style-has? "std-dtd")
      (-> "Insert table"
        ("Matrix" (make 'matrix))
        ("Determinant" (make 'det))
        ("Choice" (make 'choice))
        ("Stack" (make 'stack))
      )
    )
    (if (in-table?)
      (-> "Edit table"
        ("Insert row above" (table-insert-row #f))
        ("Insert row below" (table-insert-row #t))
        ("Insert column to the left" (table-insert-column #f))
        ("Insert column to the right" (table-insert-column #t))
        ---
        ("remove this row" (table-remove-row #f))
        ("remove this column" (table-remove-column #f))
      )
    ---
    )
    ("Fraction" (make-fraction))
    ("Square root" (make-sqrt))
    ("N-th root" (make-var-sqrt))
    ("Text" (make-with "mode" "text"))
    ---
    (-> "Script"
      ("Left subscript" (make-script #f #f))
      ("Left superscript" (make-script #t #f))
      ("Right subscript" (make-script #f #t))
      ("Right superscript" (make-script #t #t))
      ("Script below" (make-below))
      ("Script above" (make-above)))
    (-> "Accent above"
      ("Tilda" (make-wide "~"))
      ("Hat" (make-wide "^"))
      ("Bar" (make-wide "<bar>"))
      ("Vector" (make-wide "<vect>"))
      ("Check" (make-wide "<check>"))
      ("Breve" (make-wide "<breve>"))
      ("Acute" (make-wide "<acute>"))
      ("Grave" (make-wide "<grave>"))
      ("Dot" (make-wide "<dot>"))
      ("Two dots" (make-wide "<ddot>"))
      ("Circle" (make-wide "<abovering>"))
      ---
      ("Overbrace" (make-wide "<wide-overbrace>"))
      ("Underbrace" (make-wide "<wide-underbrace*>"))
      ("Square overbrace" (make-wide "<wide-sqoverbrace>"))
      ("Square underbrace" (make-wide "<wide-squnderbrace*>"))
      ("Right arrow" (make-wide "<wide-varrightarrow>"))
      ("Left arrow" (make-wide "<wide-varleftarrow>"))
      ("Wide bar" (make-wide "<wide-bar>")))
    (-> "Accent below"
      ("Tilda" (make-wide-under "~"))
      ("Hat" (make-wide-under "^"))
      ("Bar" (make-wide-under "<bar>"))
      ("Vector" (make-wide-under "<vect>"))
      ("Check" (make-wide-under "<check>"))
      ("Breve" (make-wide-under "<breve>"))
      ("Acute" (make-wide-under "<acute>"))
      ("Grave" (make-wide-under "<grave>"))
      ("Dot" (make-wide-under "<dot>"))
      ("Two dots" (make-wide-under "<ddot>"))
      ("Circle" (make-wide-under "<abovering>"))
      ---
      ("Overbrace" (make-wide-under "<wide-overbrace*>"))
      ("Underbrace" (make-wide-under "<wide-underbrace>"))
      ("Square overbrace" (make-wide-under "<wide-sqoverbrace*>"))
      ("Square underbrace" (make-wide-under "<wide-squnderbrace>"))
      ("Right arrow" (make-wide-under "<wide-varrightarrow>"))
      ("Left arrow" (make-wide-under "<wide-varleftarrow>"))
      ("Wide bar" (make-wide-under "<wide-bar>")))
    ---
    (-> "Big operator"
      (tile 8 (link big-operator-menu)))
    (-> "Arrow"
      (tile 9 (link horizontal-arrow-menu))
      ---
      (tile 8 (link vertical-arrow-menu))
      ---
      (tile 6 (link long-arrow-menu)))
    (-> "Greek letter"
      (tile 8 (link lower-greek-menu))
      ---
      (tile 8 (link upper-greek-menu)))
  )
  (if (in-graphics?) 
    (-> "Geometry" (link graphics-geometry-menu))
    (-> "Grids" (link graphics-grids-menu))
    (-> "Mode" (link graphics-mode-menu))
    (-> "Color" (link graphics-color-menu))
    (-> "Point style" (link graphics-point-style-menu))
    (-> "Fill color" (link graphics-fill-color-menu))
    (-> "Line properties"
      (-> "Width" (link graphics-line-width-menu))
      (-> "Dashes" (link graphics-dash-menu))
      (-> "Arrows" (link graphics-line-arrows-menu)))
    (-> "Text box alignment" (link graphics-text-align-menu))
    (-> "Enable change" (link graphics-enable-change-properties-menu)))  
  (if (in-session?)
    (-> "Input options" (link session-input-menu))
    (-> "Output options" (link session-output-menu))
    (-> "Field" (link session-field-menu))
    (-> "Session" (link session-session-menu))
    ---
    (-> "Evaluate" (link session-evaluate-menu))
    ("Interrupt execution" (plugin-interrupt))
    ("Close session" (plugin-stop)))
  (if (and (in-table?) (not (in-math?)))
    (-> "Insert"
      ("Insert row above" (table-insert-row #f))
      ("Insert row below" (table-insert-row #t))
      ("Insert column to the left" (table-insert-column #f))
      ("Insert column to the right" (table-insert-column #t)))
    (-> "Remove"
      ("remove this row" (table-remove-row #f))
      ("remove column" (table-remove-column #f)))
    ---
    (-> "Width" (link cell-width-menu))
    (-> "Height" (link cell-height-menu))
    (-> "Border" (link cell-border-menu))
    (-> "Padding" (link cell-padding-menu))
    (-> "Horizontal alignment" (link cell-halign-menu))
    (-> "Vertical alignment" (link cell-valign-menu))
    (-> "Background color" (link cell-color-menu)))
  (if (full-screen-edit?)
    ---
    ("Full screen mode"  (toggle-full-screen-edit-mode)))
  (if (full-screen?)
    ---
    ("Presentation mode" (toggle-full-screen-mode)))
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; iTeXmacs: the main icon bar
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(if (not (x-gui?))
(menu-bind texmacs-main-icons
  ((balloon (icon "tm_new.png") "Create a new document")
      (new-buffer))
  ((balloon (icon "tm_open.png") "Open a document") (choose-file load-buffer "Open a document" ""))
  ((balloon (icon "tm_save.png") "Save this document") (if (no-name?) (choose-file save-buffer "Save TeXmacs file" "texmacs") (save-buffer)))
  ((balloon (icon "tm_print.png") "Print this document") (print-buffer))
  ((balloon (icon "tm_cancel.png") "Close this document") (safely-kill-buffer))
  |
  ((balloon (icon "tm_cut.png") "Cut text")
   (clipboard-cut "primary"))
  ((balloon (icon "tm_copy.png") "Copy text")
   (clipboard-copy "primary"))
  ((balloon (icon "tm_paste.png") "Paste text")
   (clipboard-paste "primary"))
  (if (not (in-search-mode?))
      ((balloon (icon "tm_find.png") "Find text") (search-start #t)))
  (if (in-search-mode?)
      ((balloon (icon "tm_find_next.xpm") "Find next match")
       (search-button-next)))
  ((balloon (icon "tm_replace.png") "Query replace")
   (interactive replace-start-forward))
  ((balloon (icon "tm_spell.png") "Check text for spelling errors")
   (spell-start))
  ((balloon (icon "tm_undo.png") "Undo last changes") (undo 0))
  ((balloon (icon "tm_redo.png") "Redo undone changes") (redo 0))
  |
  ((balloon (icon "tm_back.png") "Browse back")
   (cursor-history-backward))
  ((balloon (icon "tm_reload.png") "Reload")
   (revert-buffer))
  ((balloon (icon "tm_forward.png") "Browse forward")
   (cursor-history-forward)))
)
