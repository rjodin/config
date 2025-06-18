(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#212526" "#ff4b4b" "#b4fa70" "#fce94f" "#729fcf" "#ad7fa8" "#8cc4ff" "#eeeeec"])
 '(c-basic-offset 4)
 '(column-number-mode t)
 '(custom-enabled-themes '(manoj-dark))
 '(electric-pair-mode t)
 '(fringe-mode 0 nil (fringe))
 '(ignored-local-variable-values
   '((eval ignore-errors
           (require 'whitespace)
           (whitespace-mode 1))
     (whitespace-line-column . 79)
     (whitespace-style face indentation)
     (eval progn
           (c-set-offset 'case-label '0)
           (c-set-offset 'innamespace '0)
           (c-set-offset 'inline-open '0))))
 '(indent-tabs-mode nil)
 '(inhibit-startup-screen t)
 '(menu-bar-mode nil)
 '(package-selected-packages
    '(go-mode clang-format flycheck pkg-info epl lsp-mode lv ht rustic spinner xterm-color markdown-mode f s rust-mode company eglot flymake project jsonrpc eldoc xref multiple-cursors magit transient ghub treepy git-commit magit-popup with-editor dash async))
 '(python-indent-offset 4)
 '(ruby-indent-level 4 t)
 '(show-paren-mode t)
 '(show-trailing-whitespace t)
 '(tab-width 4)
 '(tool-bar-mode nil)
 '(whitespace-line-column 120))


(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "DejaVu Sans" :foundry "unknown" :slant normal :weight normal :height 83 :width normal)))))

(require 'mouse)
(xterm-mouse-mode t)
(defun track-mouse (e))
(setq mouse-sel-mode t)

;;FOLD PARANTHESIS
(add-hook 'c-mode-common-hook
          (lambda()
            (local-set-key (kbd "C-c <right>") 'hs-show-block)
            (local-set-key (kbd "C-c <left>")  'hs-hide-block)
            (local-set-key (kbd "C-c <up>")    'hs-hide-level)
            (local-set-key (kbd "C-c <down>")  'hs-show-all)
            (hs-minor-mode t)))
(add-hook 'rustic-mode-hook
          (lambda()
            (local-set-key (kbd "C-c <right>") 'hs-show-block)
            (local-set-key (kbd "C-c <left>")  'hs-hide-block)
            (local-set-key (kbd "C-c <up>")    'hs-hide-level)
            (local-set-key (kbd "C-c <down>")  'hs-show-all)
            (hs-minor-mode t)))

(require 'clang-format)

(global-set-key (kbd "C-:") 'undo)
(global-set-key (kbd "M-c") 'comment-or-uncomment-region)

(global-set-key (kbd "C-x C-i") 'clang-format-region)
;; (require 'cc-mode)
;; (define-key c-mode-base-map (kbd "C-i") 'clang-format-region)
;; (define-key c++-mode-map (kbd "C-i") 'clang-format-region)

;; (global-set-key (kbd "C-i") 'clang-format-region)

(setq vc-follow-symlinks t)

;;HIGHLIGHT CURRENT LINE
(global-hl-line-mode 1)

;;MAGIT
(require 'magit)
(setq magit-bind-magit-project-status nil)
(global-set-key (kbd "C-x g") 'magit-status)

;; NO ~ FILE GENERATED
(setq auto-save-default nil)
(defvar backup-dir "~/.emacsbackups/")
(setq backup-directory-alist (list (cons "." backup-dir)))

;; MULTIPLE CURSORS
(global-set-key (kbd "C-x &") 'mc/edit-lines)
(global-set-key (kbd "C-x <") 'mc/mark-next-like-this)
(global-set-key (kbd "C-x >") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-x é") 'mc/mark-all-like-this)

;; PACKAGE SOURCE
(require 'package)
(setq package-archives
      '(("GNU ELPA" . "https://elpa.gnu.org/packages/")
        ("MELPA Stable" . "https://stable.melpa.org/packages/")
        ("MELPA" . "https://melpa.org/packages/")
        )
      package-archive-priorities
      '(("MELPA Stable" . 10)
        ("MELPA" . 5)
        ("GNU ELPA" . 0)
        )
      )
(package-initialize)

(require 'ansi-color)
(defun display-ansi-colors ()
  (interactive)
  (ansi-color-apply-on-region (point-min) (point-max)))

;; INFER INDENTATION STYLE
(defun how-many-region (begin end regexp &optional interactive)
  "Print number of non-trivial matches for REGEXP in region.
Non-interactive arguments are Begin End Regexp"
  (interactive "r\nsHow many matches for (regexp): \np")
  (let ((count 0) opoint)
    (save-excursion
      (setq end (or end (point-max)))
      (goto-char (or begin (point)))
      (while (and (< (setq opoint (point)) end)
                  (re-search-forward regexp end t))
        (if (= opoint (point))
            (forward-char 1)
          (setq count (1+ count))))
      (if interactive (message "%d occurrences" count))
      count)))

(defun guess-default-offset ()
  "Print offset detected"
  (interactive)
  (let ((nb-occur 0)
        (offset-min 0)
        (two-space (how-many-region (point-min) (point-max) "^  [^ ]"))
        (three-space (how-many-region (point-min) (point-max) "^   [^ ]"))
        (four-space (how-many-region (point-min) (point-max) "^    [^ ]"))
        (eight-space (how-many-region (point-min) (point-max) "^        [^ ]")))
        (if (< nb-occur eight-space) (setq offset-min 8))
        (if (< nb-occur eight-space) (setq nb-occur eight-space))
        (if (< nb-occur four-space) (setq offset-min 4))
        (if (< nb-occur four-space) (setq nb-occur four-space))
        (if (< nb-occur three-space) (setq offset-min 3))
        (if (< nb-occur three-space) (setq nb-occur three-space))
        (if (< nb-occur two-space) (setq offset-min 2))
        (if (< nb-occur two-space) (setq nb-occur two-space))
        (message "offset detected: %d ( %d occur )" offset-min nb-occur)
        (setq c-basic-offset offset-min)
        (setq ruby-indent-level offset-min)
        (setq tab-width offset-min)
        )
  )

(defun infer-indent-mode ()
  "Infer indent mode and switch to it"
  (interactive)
  (let ((space-count (how-many-region (point-min) (point-max) "^  "))
        (tab-count (how-many-region (point-min) (point-max) "^\t")))
    (if (> space-count tab-count) (setq indent-tabs-mode nil))
    (if (> space-count tab-count) (guess-default-offset))
    (if (> space-count tab-count) (message "Switch to space mode"))
    (if (> tab-count space-count) (setq indent-tabs-mode t))
    (if (> tab-count space-count) (message "Switch to tab mode"))
    ))

(add-hook 'find-file-hook
          '(lambda () (infer-indent-mode)))

(require 'rustic)
;;INFER INDENTATION STYLE
(add-to-list 'auto-mode-alist '("CMakeLists\\.txt\\'" . makefile-mode))
(add-to-list 'auto-mode-alist '("\\.cmake\\'" . makefile-mode))
(add-to-list 'auto-mode-alist '("\\.rs\\'" . rustic-mode))

(add-to-list 'auto-mode-alist '("bashrc" . sh-mode))
(add-to-list 'auto-mode-alist '("emacs" . emacs-lisp-mode))

(add-to-list 'auto-mode-alist '("\\.ebuild\\'" . sh-mode))

(add-to-list 'auto-mode-alist '("\\.cl\\'" . c-mode))

;; whitespace-mode : to see white space, tab, etc
;; setq show-trailing-whitespace : to see useless tab/whitespace (t or nil)
;; change offset : setq c-basic-offset
;; setq indent-tabs-mode (t or nil)
;; setq c-default-style "linux" "gnu" "ellemtel"(c++)
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)

(add-hook 'after-init-hook 'global-company-mode)

(defun project-root (project)
    (car (project-roots project)))

(require 'eglot)
(add-to-list 'eglot-server-programs '((c++-mode c-mode) "clangd" "--background-index"))
(add-hook 'c-mode-hook 'eglot-ensure)
(add-hook 'c++-mode-hook 'eglot-ensure)
(global-set-key (kbd "M-/") 'xref-find-references)
(global-set-key (kbd "M-.") 'xref-find-definitions)
