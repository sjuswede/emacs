;; -*- lexical-binding: t -*-
;; emacs basic init file for jesper@pobox.com

;; Provides basic settings
;; Should be loaded first in init file
;; This sets up package management, file handling and the like

;;; Files and cleanliness

(setq use-short-answers t)

;; Don't litter file system with *~ backup files; put them all inside
;; ~/.emacs.d/emacs-backup
(let ((backup-dir (expand-file-name "emacs-backup/" user-emacs-directory)))
  (setopt backup-directory-alist `(("." . ,backup-dir)))
  ;; Keep # files away from current directory as well
  (setq auto-save-file-name-transforms
    `((".*" ,backup-dir t)))
  ;; Make sure backup directory exist
  (when (not (file-exists-p backup-dir))
    (make-directory backup-dir t)))

;; Sane backup management
(setq backup-by-copying t    ; Don't delink hardlinks
      delete-old-versions t  ; Clean up the backups
      version-control t      ; Use version numbers on backups,
      kept-new-versions 5    ; keep some new versions
      kept-old-versions 2)   ; and some old ones, too

;; Automatically reread from disk if the underlying file changes
(setopt auto-revert-avoid-polling t)
;; Save history of minibuffer
(savehist-mode)

;;; UI changes

(blink-cursor-mode -1)                                ; Steady cursor
(pixel-scroll-precision-mode)                         ; Smooth scrolling

(setq ring-bell-function #'ignore)

;; Move through windows with Ctrl-<arrow keys>
(windmove-default-keybindings 'control) ; You can use other modifiers here
;; Make right-click do something sensible
(when (display-graphic-p)
  (context-menu-mode))

;; Whenever text is selected using the mouse, copy it to the clipboard
(setq mouse-drag-copy-region t)

;; Mode line information
(setopt line-number-mode t)                        ; Show current line in modeline
(setopt column-number-mode t)                      ; Show column as well

(setopt x-underline-at-descent-line nil)           ; Prettier underlines
(setopt switch-to-buffer-obey-display-actions t)   ; Make switching buffers more consis

;; Use common keystrokes by default
(cua-mode)

;; Display line numbers in programming mode
(add-hook 'prog-mode-hook 'display-line-numbers-mode)
(setopt display-line-numbers-width 3)           ; Set a minimum width

;; Nice line wrapping when working with text
(add-hook 'text-mode-hook 'visual-line-mode)

;; Modes to highlight the current line with
(let ((hl-line-hooks '(text-mode-hook prog-mode-hook)))
  (mapc (lambda (hook) (add-hook hook 'hl-line-mode)) hl-line-hooks))

;; Turn on which key mode, and special window. Omit window if desired
(which-key-mode 1)
(which-key-setup-side-window-right-bottom)

;;; editing

;; Fix archaic defaults
(setopt sentence-end-double-space nil)

;; Tell find file to create directory if it doesn't exist
(defadvice find-file (before make-directory-maybe (filename &optional wildcards) activate)
  "Create parent directory if not exists while visiting file."
  (unless (file-exists-p filename)
    (let ((dir (file-name-directory filename)))
      (unless (file-exists-p dir)
        (make-directory dir t)))))

;; character encoding can be a bother
(prefer-coding-system 'utf-8)
;(setq system-time-locale "en_US")

;; ripgrep for fast searches
(use-package rg
  :config (rg-enable-default-bindings)
  :bind
  ("C-c s" . rg-menu))

;; better fill and unfill
(use-package unfill
  :bind
  ("M-q" . unfill-toggle)
  ("A-q" . unfill-paragraph))

;;;; packages

;;; Basic package setup and management

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;; Always grab packages if they are not there
(require 'use-package-ensure)
(setq use-package-always-ensure t)

;; Icons everywhere when in graphic mode
;; Remember to run all-the-icons-install to get the fonts
(use-package all-the-icons
  :if (display-graphic-p))

;; Better c-k behaviour
(use-package whole-line-or-region)
(whole-line-or-region-global-mode t)
(with-eval-after-load 'embark
  (cl-pushnew 'embark--mark-target
              (alist-get 'whole-line-or-region-delete-region
                         embark-around-action-hooks)))

;; imenu
(use-package imenu-list
  :ensure t
  :bind (("C-'" . imenu-list-smart-toggle))
  :config
  (setq imenu-list-focus-after-activation t
        imenu-list-auto-resize t))

(use-package olivetti
  :ensure
  :diminish
  :config
  (setq olivetti-body-width 0.65)
  (setq olivetti-minimum-body-width 72)
  (setq olivetti-recall-visual-line-mode-entry-state t)

  (define-minor-mode prot/olivetti-mode
    "Toggle buffer-local `olivetti-mode' with additional parameters.

Fringes are disabled.  The modeline is hidden, except for
`prog-mode' buffers (see `prot/hidden-mode-line-mode').  The
default typeface is set to a proportionately-spaced family,
except for programming modes (see `prot/variable-pitch-mode').
The cursor becomes a blinking bar, per `prot/cursor-type-mode'."
    :init-value nil
    :global nil
    (if prot/olivetti-mode
        (progn
          (olivetti-mode 1)
          (set-window-fringes (selected-window) 0 0)
          (prot/variable-pitch-mode 1)
          (prot/cursor-type-mode 1)
          (unless (derived-mode-p 'prog-mode)
            (prot/hidden-mode-line-mode 1))
          (window-divider-mode 1)
          (when (eq major-mode 'org-mode)
            (org-superstar-mode 1)))
      (olivetti-mode -1)
      (set-window-fringes (selected-window) nil) ; Use default width
      (prot/variable-pitch-mode -1)
      (prot/cursor-type-mode -1)
      (unless (derived-mode-p 'prog-mode)
        (prot/hidden-mode-line-mode -1))
      (window-divider-mode -1)
      (when (eq major-mode "org-mode")
        (org-superstar-mode -1))))

  :bind ("C-c o" . prot/olivetti-mode))


;(add-hook 'markdown-mode-hook (lambda () (setq-local imenu-auto-rescan t)))
;(add-hook 'makefile-mode-hook (lambda () (setq-local imenu-auto-rescan t)))
;(add-hook 'prog-mode-hook
;      (lambda ()
;        (setq-local imenu-auto-rescan t)
;        (setq-local imenu-sort-function #'imenu--sort-by-name)))


(provide 'jas-basic)
;; EOF
