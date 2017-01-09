;;; sproto-mode.el --- Major mode for sproto protocol
;;

;;; Commentary:
;; A very basic version of major mode for sproto protocol.
;; Current features:
;;
;; - syntax highlight
;; - basic indent
;;

;;; Code:

(defvar sproto-mode-hook nil)


;; keymap
(defvar sproto-mode-map
  (let ((map (make-keymap)))
  ;; (define-key "\C-j" 'newline-and-indent)
  map)
  "Keymap for Sproto `'major-mode.")


;; autoload
(add-to-list 'auto-mode-alist '("\\.sproto$" . sproto-mode))


;; font
(defvar sproto-font-lock-defaults
  `((
    ("-*[0-9]+-*" . font-lock-constant-face)
    ("[\\.\\*][[[:alnum:]]_]+" . font-lock-type-face)
    ("\\:-*[[:alnum:]]+" . font-lock-constant-face)
    ("-*\\(string\\|integer\\|boolean\\|request\\|response\\)-*" . font-lock-keyword-face))))


;; syntax table
(defvar sproto-mode-syntax-table
  (let ((st (make-syntax-table)))
    (modify-syntax-entry ?_ "w" st)
    (modify-syntax-entry ?# "< b" st)
    (modify-syntax-entry ?\n "> b" st)
    st)
  "Sproto mode syntax table.")


;; indent
(defun sproto-indent-line ()
  "Indent current line as sproto code."
  (interactive)
  (beginning-of-line)
  (if (bobp)
      (indent-line-to 0)
    (let ((not-indented t) cur-indent)
      (if (looking-at ".*}$")        ; curline is end of block
          (progn
            (save-excursion
              (forward-line -1)
              (setq cur-indent (- (current-indentation) tab-width)))
            (if (< cur-indent 0)
                (setq cur-indent 0)))
        (save-excursion
          (while not-indented
            (forward-line -1)
            (if (looking-at ".*}$") ; preline is start block
                (progn
                  (setq cur-indent (current-indentation))
                  (setq not-indented nil))
              (if (looking-at ".*{$") ; preline is start of block
                  (progn
                    (setq cur-indent (+ (current-indentation) tab-width))
                    (setq not-indented nil))
                (if (bobp)
                    (setq not-indented nil)))))))
      (if cur-indent
          (progn
            (indent-line-to cur-indent)
            (if (looking-at ".*{$")
                (save-excursion
                  (forward-line 2)
                  (if (looking-at ".*}$")
                      (indent-line-to cur-indent)))))
        (indent-line-to 0)))))


;; entry
(defun sproto-mode ()
  "Major mode editing sproto files."
  (interactive)
  (kill-all-local-variables)
  (use-local-map sproto-mode-map)
  (set (make-local-variable 'font-lock-defaults) sproto-font-lock-defaults)
  (set (make-local-variable 'indent-line-function) 'sproto-indent-line)
  (set-syntax-table sproto-mode-syntax-table)
  (setq major-mode 'sproto-mode)
  (setq mode-name "sproto")
  (set (make-local-variable 'comment-start) "#")
  (run-hooks 'sproto-mode-hook))

(provide 'sproto-mode)

;;; sproto-mode.el ends here
