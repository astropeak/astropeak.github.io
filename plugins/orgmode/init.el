;; Init file to use with the orgmode plugin.

;; Load org-mode
;; Requires org-mode v8.x

(require 'package)
(setq package-load-list '((htmlize t)))
(package-initialize)

(require 'org)
(require 'ox-html)

;;; Custom configuration for the export.

;;; Add any custom configuration that you would like to 'conf.el'.
(setq nikola-use-pygments t
      org-export-with-toc nil
      org-export-with-section-numbers nil
      org-startup-folded 'showeverything)

;; Load additional configuration from conf.el
(let ((conf (expand-file-name "conf.el" (file-name-directory load-file-name))))
  (if (file-exists-p conf)
      (load-file conf)))

;;; Macros

;; Load Nikola macros
(setq nikola-macro-templates
      (with-current-buffer
          (find-file
           (expand-file-name "macros.org" (file-name-directory load-file-name)))
        (org-macro--collect-macros)))

;;; Code highlighting
(defun org-html-decode-plain-text (text)
  "Convert HTML character to plain TEXT. i.e. do the inversion of
     `org-html-encode-plain-text`. Possible conversions are set in
     `org-html-protect-char-alist'."
  (mapc
   (lambda (pair)
     (setq text (replace-regexp-in-string (cdr pair) (car pair) text t t)))
   (reverse org-html-protect-char-alist))
  text)

;; Use pygments highlighting for code
(defun pygmentize (lang code)
  "Use Pygments to highlight the given code and return the output"
  (with-temp-buffer
    (insert code)
    (let ((lang (or (cdr (assoc lang org-pygments-language-alist)) "text")))
      (shell-command-on-region (point-min) (point-max)
                               (format "pygmentize -f html -l %s" lang)
                               (buffer-name) t))
    (buffer-string)))

(defconst org-pygments-language-alist
  '(("asymptote" . "asymptote")
    ("awk" . "awk")
    ("c" . "c")
    ("c++" . "cpp")
    ("cpp" . "cpp")
    ("clojure" . "clojure")
    ("css" . "css")
    ("d" . "d")
    ("emacs-lisp" . "scheme")
    ("F90" . "fortran")
    ("gnuplot" . "gnuplot")
    ("groovy" . "groovy")
    ("haskell" . "haskell")
    ("java" . "java")
    ("js" . "js")
    ("julia" . "julia")
    ("latex" . "latex")
    ("lisp" . "lisp")
    ("makefile" . "makefile")
    ("matlab" . "matlab")
    ("mscgen" . "mscgen")
    ("ocaml" . "ocaml")
    ("octave" . "octave")
    ("perl" . "perl")
    ("picolisp" . "scheme")
    ("python" . "python")
    ("r" . "r")
    ("ruby" . "ruby")
    ("sass" . "sass")
    ("scala" . "scala")
    ("scheme" . "scheme")
    ("sh" . "sh")
    ("sql" . "sql")
    ("sqlite" . "sqlite3")
    ("tcl" . "tcl"))
  "Alist between org-babel languages and Pygments lexers.
lang is downcased before assoc, so use lowercase to describe language available.
See: http://orgmode.org/worg/org-contrib/babel/languages.html and
http://pygments.org/docs/lexers/ for adding new languages to the mapping.")

(defun mylog (msg)
  (with-current-buffer (find-file-literally "../e.log")
    (goto-char (point-max))
    (insert msg)
    (insert "\n")
    (save-buffer)))

;; Override the html export function to use pygments
(defun org-html-src-block (src-block contents info)
  "Transcode a SRC-BLOCK element from Org to HTML.
CONTENTS holds the contents of the item.  INFO is a plist holding
contextual information."
  (if (org-export-read-attribute :attr_html src-block :textarea)
      (org-html--textarea-block src-block)
    (let ((lang (org-element-property :language src-block))
          (code (org-element-property :value src-block))
          (code-html (org-html-format-code src-block info))
          (show-linenr-p (equal (org-element-property :switches src-block) "-n"))
          (start-linenr (string-to-int (or (org-element-property :parameters src-block) "0")))
          (tmp nil))

      ;; (mylog (format "%s" (org-export-read-attribute :attr_html src-block :results)))
      ;; (mylog (format "%s" (org-export-read-attribute :results src-block)))
      ;; (mylog (format "options: %s" (org-element-property :options src-block)))
      ;; (mylog (format "parameters: %s" (org-element-property :parameters src-block)))
      ;; (mylog (format "switches: %s" (org-element-property :switches src-block)))

      (if nikola-use-pygments
          (progn
            (setq tmp (pygmentize (downcase lang) (org-html-decode-plain-text code)))
            (setq tmp (aspk-add-line-number tmp show-linenr-p start-linenr))

            tmp)
        code-html))))

(defun aspk-add-line-number (code show-linenr-p start-linenr)
  (setq code (string-trim code))
  (setq code (string-remove-prefix "<div class=\"highlight\"><pre>" code))
  (setq code (string-remove-suffix "\n</pre></div>" code))
  (let ((idx (- start-linenr 1))
        (number-idx 1))
    (format "%s\n%s\n%s"
            (if show-linenr-p
                "<div class=\"highlight show-linenr\"><pre>"
              "<div class=\"highlight\"><pre>")
            (mapconcat (lambda (x)
                         (incf idx)
                         (let ((rst x))
                           (when show-linenr-p
                             (setq rst (format "<span class=\"linenr unselectable\">%d </span>%s" idx rst)))

                           (when (string-match-p "#H#" rst)
                             (setq rst (replace-regexp-in-string "#H#" "" rst))
                             (setq rst (format "<span class=\"codeH\">%s</span>" rst))
                             )

                           (when (string-match-p "#N#" rst)
                             (setq rst (replace-regexp-in-string "#N#" "" rst))
                             (setq rst (format "%s  <span class=\"numberCircle unselectable\">%s</span>" rst number-idx))
                             (incf number-idx)
                             )
                           rst))
                       (split-string code "\n")
                       "\n")
            "</pre></div>"
            )))

;; Export images with custom link type
(defun org-custom-link-img-url-export (path desc format)
  (cond
   ((eq format 'html)
    (format "<img src=\"%s\" alt=\"%s\"/>" path desc))))
(org-add-link-type "img-url" nil 'org-custom-link-img-url-export)

;; Export function used by Nikola.
(defun nikola-html-export (infile outfile)
  "Export the body only of the input file and write it to
specified location."
  (with-current-buffer (find-file infile)
    (org-macro-replace-all nikola-macro-templates)
    (org-html-export-as-html nil nil t t)
    (write-file outfile nil)))
