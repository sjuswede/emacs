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
  ;; Make sure backup directory exist
  (when (not (file-exists-p backup-dir))
    (make-directory backup-dir t)))

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

(provide 'jas-basic)
;; EOF
