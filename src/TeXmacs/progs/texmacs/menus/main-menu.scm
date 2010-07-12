
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The TeXmacs main menu
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(menu-bind texmacs-menu
  (=> "File" (link file-menu))
  (=> "Edit" (link edit-menu))
  (if (not (in-graphics?)) (=> "Insert" (link insert-menu)))
  (if (in-source?) (=> "Source" (link source-menu)))
  (if (in-text?) (=> "Text" (link text-menu)))
  (if (in-math?) (=> "Mathematics" (link math-menu)))
  (if (in-session?) (=> "Session" (link session-menu)))
  (if (in-graphics?) (=> "Graphics" (link graphics-menu)))
  (if (in-table?) (link vertical-table-cell-menu))
  (link texmacs-extra-menu)
  (if (not (in-graphics?)) (=> "Format" (link format-menu)))
  (=> "Document" (link document-menu))
  (if (and (not (project-attached?))
	   (== (get-init-tree "sectional-short-style") (tree 'macro "false")))
      (=> "Part" (link document-part-menu)))
  (if (project-attached?) (=> "Project" (link project-menu)))
  (if (with-remote-connections?)
      (=> "Remote" (link remote-menu)))
  (if (with-linking-tool?)
      (=> "Link" (link link-menu)))
  (if (with-versioning-tool?)
      (=> "Version" (link version-menu)))
  (=> "View" (link view-menu))
  (=> "Window" (link go-menu))
  (if (detailed-menus?) (=> "Tools" (link tools-menu)))
  (=> "Help" (link help-menu)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The TeXmacs popup menu
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
      (tile 8 (link upper-greek-menu))))  
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
  ;(if (in-session?) (-> "Session" (link session-menu)))
  (if (in-session?)
    (-> "Input options" (link session-input-menu))
    (-> "Output options" (link session-output-menu))
    (-> "Field" (link session-field-menu))
    (-> "Session" (link session-session-menu))
    ---
    (-> "Evaluate" (link session-evaluate-menu))
    ("Interrupt execution" (plugin-interrupt))
    ("Close session" (plugin-stop)))
  (if (in-table?)
    (-> "Insert"
      ("Insert row above" (table-insert-row #f))
      ("Insert row below" (table-insert-row #t))
      ("Insert column to the left" (table-insert-column #f))
      ("Insert column to the right" (table-insert-column #t)))
    (-> "Remove"
      ("remove this row" (table-remove-row #f))
      ("remove column" (table-remove-column #f)))
    ---
    (-> "Width" (link table-width-menu))
    (-> "Height" (link table-height-menu))
    (-> "Border" (link table-border-menu))
    (-> "Padding" (link table-padding-menu))
    (-> "Horizontal alignment" (link table-halign-menu))
    (-> "Vertical alignment" (link table-valign-menu))
    ---
    (if (== (get-cell-mode) "cell") (-> "Cell" (link cell-menu)))
    (if (== (get-cell-mode) "row") (-> "Row" (link cell-menu)))
    (if (== (get-cell-mode) "column") (-> "Column" (link cell-menu)))
    (if (== (get-cell-mode) "table") (-> "Cells" (link cell-menu))))
  ;(if (not (in-graphics?)) (-> "Format" (link format-menu)))
  ;(-> "Document" (link document-menu))
  ;(if (== (get-init-tree "sectional-short-style") (tree 'macro "false"))
  ;    (-> "Part" (link document-part-menu)))
  ;(if (project-attached?) (=> "Project" (link project-menu)))
  (if (with-remote-connections?)
      (-> "Remote" (link remote-menu)))
  (if (with-linking-tool?)
      (-> "Link" (link link-menu)))
  (if (with-versioning-tool?)
      (-> "Version" (link version-menu)))
  ;(-> "View" (link view-menu))
  ;(-> "Go" (link go-menu))
  ;(if (detailed-menus?) (-> "Tools" (link tools-menu)))
  ;---
  ;(-> "Help" (link help-menu))
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The main icon bar
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(menu-bind texmacs-main-icons
  ((balloon (icon "tm_new.xpm") "Create a new document")
      (new-buffer))
  ((balloon (icon "tm_open.xpm") "Open a document") (choose-file load-buffer "Open a document" ""))
  ((balloon (icon "tm_save.xpm") "Save this document") (if (no-name?) (choose-file save-buffer "Save TeXmacs file" "texmacs") (save-buffer)))
  (=> (balloon (icon "tm_print.xpm") "Print") (link print-menu))
  (if (detailed-menus?)
      (=> (balloon (icon "tm_style.xpm") "Select a document style")
	  (link document-style-menu))
      (=> (balloon (icon "tm_language.xpm") "Select a language")
	  (link global-language-menu)))
  ((balloon (icon "tm_cancel.xpm") "Close this document") (safely-kill-buffer))
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
  ((balloon (icon "tm_spell.xpm") "Check text for spelling errors")
   (spell-start))
  ((balloon (icon "tm_undo.xpm") "Undo last changes") (undo 0))
  ((balloon (icon "tm_redo.xpm") "Redo undone changes") (redo 0))
  (if (not (in-graphics?))
      |
      (=> (balloon (icon "tm_table.xpm") "Insert a table")
	  (link insert-table-menu))
      (=> (balloon (icon "tm_image.xpm") "Insert a picture")
	  (link insert-image-menu))
      (=> (balloon (icon "tm_link.xpm") "Insert a link")
	  (link insert-link-menu))
      (if (detailed-menus?)
	  (if (style-has? "std-fold-dtd")
	      (=> (balloon (icon "tm_switch.xpm") "Switching and folding")
		  (link insert-fold-menu)))
	  (=> (balloon (icon "tm_animate.xpm") "Animation")
	      (link insert-animation-menu)))
      (=> (balloon (icon "tm_math.xpm") "Insert mathematics")
	  (link insert-math-menu))
      (if (and (style-has? "program-dtd") (detailed-menus?))
	  (=> (balloon (icon "tm_shell.xpm")
		       "Start an interactive session")
	      (link insert-session-menu))))
  |
  ((balloon (icon "tm_back.xpm") "Browse back (C-<)")
   (cursor-history-backward))
  ((balloon (icon "tm_reload.xpm") "Reload (C-F2)")
   (revert-buffer))
  ((balloon (icon "tm_forward.xpm") "Browse forward (C->)")
   (cursor-history-forward)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The context dependent icon bar
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(menu-bind texmacs-context-icons
  (if (in-source?) (link source-icons))
  (if (in-text?) (link text-icons))
  (if (in-session?) (link session-icons))
  (if (in-math?) (link math-icons))
  (if (in-graphics?) (link graphics-icons))
  (if (not (in-graphics?)) |)
  (if (or (in-source?) (in-text?)) (link text-format-icons))
  (if (in-math?) (link math-format-icons))
  (if (in-prog?) (link prog-format-icons))
  (if (in-table?) (link table-icons))
  (link help-icons))
