;;; spirv-mode.el --- Major mode for the SPIRV assembler language.

;;; Code:

(defvar spirv-mode-syntax-table
  (let ((table (make-syntax-table)))
    (modify-syntax-entry ?% "_" table)
    (modify-syntax-entry ?. "_" table)
    (modify-syntax-entry ?\; "< " table)
    (modify-syntax-entry ?\n "> " table)
    table)
  "Syntax table used while in SPIRV mode.")

(defvar spirv-font-lock-keywords
  (list
   ;; Variables
   '("%[-a-zA-Z$._0-9]*" . font-lock-variable-name-face)
   ;; Spirv Inst
   '("Op[-a-zA-Z$._0-9]*" . font-lock-keyword-face)
   ;; Integer literals
   '("\\b[-]?[0-9]+\\b" . font-lock-preprocessor-face)
   ;; Floating point constants
   '("\\b[-+]?[0-9]+.[0-9]*\\([eE][-+]?[0-9]+\\)?\\b" . font-lock-preprocessor-face)
   ;; Hex constants
   '("\\b0x[0-9A-Fa-f]+\\b" . font-lock-preprocessor-face))
  "Syntax highlighting for SPIRV.")

;;;###autoload
(define-derived-mode spirv-mode prog-mode "SPIRV"
  "Major mode for editing SPIRV source files.
\\{spirv-mode-map}
  Runs `spirv-mode-hook' on startup."
  (setq font-lock-defaults `(spirv-font-lock-keywords))
  (setq-local comment-start ";"))

;; Associate .spirv files with spirv-mode
;;;###autoload
(add-to-list 'auto-mode-alist (cons "\\.spirv\\'" 'spirv-mode))
(add-to-list 'auto-mode-alist (cons "\\.spvasm\\'" 'spirv-mode))

(provide 'spirv-mode)

;;; spirv-mode.el ends here
