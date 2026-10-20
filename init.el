;; -*- lexical-binding: t -*-
;; emacs init file for jesper@pobox.com

;;; Preparation

;; Set me
(setq user-full-name "Jesper Anderson")
(setq user-mail-address "jesper@pobox.com")

;;;; Startup debugging tools
;; (setopt debug-on-error t)

;;; Fonts

(set-frame-font "FiraCode Nerd Font Mono-13:style=Retina" nil t)
(set-face-font 'fixed-pitch-serif "FiraCode Nerd Font Mono-13:style=Retina")
(set-face-font 'variable-pitch "FiraCode Nerd Font Propo-13:style=Retina")

 (when window-system
      (set-frame-position (selected-frame) 0 0)
      (set-frame-size (selected-frame) 110 50))

;; Default frame configuration
(when (display-graphic-p)
    (tool-bar-mode -1)
    (scroll-bar-mode -1))
(menu-bar-mode -1)

;;; Package preparation early

;; use-package is started in early-init
;(eval-when-compile
(require 'package)
(require 'use-package)
;; Melpa. Yes, I know. I still want it.
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
;(setq use-package-always-ensure t)

;(eval-when-compile
;  (require 'use-package))
;(require 'diminish)                ;; if you use :diminish
(require 'bind-key)                ;; if you use any :bind variant

(use-package auto-compile
  :ensure t
  :config (auto-compile-on-load-mode))
(setq native-compile-prune-cache t)

;;; Cleanups

;; Keep my .emacs.d clean!
(use-package no-littering
  :ensure t
  :demand t)

(setq custom-file (no-littering-expand-etc-file-name "custom.el"))
;(load custom-file 't)
;; You read it right. No reading in the custom.el.

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

;;; Code

;; Automatically reread from disk if the underlying file changes
(setopt auto-revert-avoid-polling t)

;; Save history of minibuffer
(setq savehist-file (expand-file-name "history" user-emacs-directory))
(savehist-mode)

;; Disable GUI
;(scroll-bar-mode -1)        ; Disable visible scrollbar
;(tool-bar-mode -1)          ; Disable the toolbar
(tooltip-mode -1)           ; Disable tooltips
;(menu-bar-mode -1)            ; Disable the menu bar
(setq use-dialog-box nil)
(setq use-file-dialog nil)
;(setq-default frame-title-format '("%b  -  GNU Emacs @" system-name))

(if (display-graphic-p)
  (set-fringe-mode 10) ; give some breathing room
  )

;;; Fix up some annoyances
;; No startup message
(setq inhibit-startup-message  t
      case-fold-search         nil
      indent-tabs-mode         nil
      shift-select-mode        t
      scroll-error-top-bottom  t
      ring-bell-function       'ignore ; disable bell sound
      switch-to-visible-buffer nil
      use-short-answers        t   ; for the lazy
      indicate-empty-lines     t   ; show empty lines at end of file
      kill-read-only-ok        t   ; use kill to copy text in read-only buffer
      display-time-24hr-format t)

(global-display-line-numbers-mode t)

(blink-cursor-mode -1)         ; Steady cursor
(pixel-scroll-precision-mode)  ; Smooth scrolling

;; Don't hide the frame
(global-set-key (kbd "C-z") nil)
(global-set-key (kbd "C-x C-z") nil)

;; Mode line information
(setopt line-number-mode t)                        ; Show current line in modeline
(setopt column-number-mode t)                      ; Show column as well
(setopt display-line-numbers-width 3)              ; Set a minimum width

(setopt x-underline-at-descent-line nil)           ; Prettier underlines
(setopt switch-to-buffer-obey-display-actions t)   ; Make switching buffers more consis

;; Make right-click do something sensible
(when (display-graphic-p)
  (context-menu-mode))

;; Move through windows with Ctrl-<arrow keys>
(windmove-default-keybindings 'control) ; You can use other modifiers here

;;; Editing

;; Use common keystrokes by default
(cua-mode)

;; Whenever text is selected using the mouse, copy it to the clipboard
(setq mouse-drag-copy-region t)

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
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)

;; By default, clean up whitespace on save
(add-hook 'before-save-hook 'whitespace-cleanup)

;; Nice line wrapping when working with text
(add-hook 'text-mode-hook 'visual-line-mode)

;; Modes to highlight the current line with
(let ((hl-line-hooks '(text-mode-hook prog-mode-hook)))
  (mapc (lambda (hook) (add-hook hook 'hl-line-mode)) hl-line-hooks))

;; Turn on which key mode, and special window. Omit window if desired
(which-key-mode 1)
;(which-key-setup-side-window-right-bottom)

;;; Package main chunk

;; Icons everywhere when in graphic mode
;; Remember to run all-the-icons-install to get the fonts
(use-package all-the-icons
  :ensure t
  :if (display-graphic-p))

(use-package nerd-icons
  :ensure t
  ;; :custom
  ;; The Nerd Font you want to use in GUI
  ;; "Symbols Nerd Font Mono" is the default and is recommended
  ;; but you can use any other Nerd Font if you want
  ;; (nerd-icons-font-family "Symbols Nerd Font Mono")
  )

(use-package modus-themes
  :ensure t
  :config
  ;; Your customizations here.  All customizations must be evaluated
  ;; BEFORE loading the theme.  Reload the theme for new customizations
  ;; to take effect.
  (setq modus-themes-italic-constructs t
	modus-themes-bold-constructs nil)

  ;(modus-themes-load-theme 'modus-operandi)
  (modus-themes-load-theme 'modus-vivendi)

  (define-key global-map (kbd "<f5>") #'modus-themes-toggle))

(use-package marginalia
  :ensure t
  :init (marginalia-mode))

;; ripgrep for fast searches
(use-package rg
  :ensure t
  :config (rg-enable-default-bindings)
  :bind
  ("C-c s" . rg-menu))

;; better fill and unfill
(use-package unfill
  :ensure t
  :bind
  ("M-q" . unfill-toggle)
  ("A-q" . unfill-paragraph))

;; Better c-k behaviour
(use-package whole-line-or-region
  :ensure t)
(whole-line-or-region-global-mode t)

;; https://robbmann.io/posts/emacs-treesit-auto/
(use-package treesit-auto
  :ensure t
  :custom
  (treesit-auto-install 'prompt)
  :config
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode))

;;; org mode and friends

(use-package org
  :ensure t
  :mode (("\\.org$" . org-mode))
  :config
)

(use-package org-contrib
  :ensure t
  :after org
)

;; To hide drawers, e.g. PROPERTIES.
(setq org-startup-folded 'fold)

;; Non-nil means font-lock should hide
;; the emphasis marker characters.
(setq org-hide-emphasis-markers t)

;; Make invisible parts of Org elements appear visible.
(use-package org-appear
  :ensure t
  :init
  (setq org-appear-delay 0.2)
  :hook
  org-mode
)

;; Better list bullets.
(font-lock-add-keywords
 'org-mode
 '(("^ +\\([-*]\\) "
    (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

(use-package org-bullets
  :ensure t)
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))
(setq org-bullets-bullet-list
  '("①" "②" "③" "④" "⑤" "⑥" "⑦" "⑧" "⑨" "⑩"))

(setq org-hide-leading-stars t)

;; Indent levels.
(add-hook 'org-mode-hook 'org-indent-mode)

;; Use this character(s) for ellipsis.
(setq org-ellipsis "...")

;;; End of org mode and friends

(use-package howm
  :ensure t
  :init
  ;;
  ;; Options: Remove the leading ";" in the following lines if you like.
  ;;
  ;; Format
  ;(require 'howm-markdown) ;; Write notes in markdown-mode. (*1)
  ;(require 'howm-org) ;; Write notes in Org-mode. (*2)
  ;;
  ;; Preferences
  (setq howm-directory "~/notes") ;; where to store the files?
  (setq howm-home-directory "~/notes") ;; special files
  (setq howm-follow-theme t) ;; use your Emacs theme colors
  (setq howm-file-name-format "%Y/%m/%Y-%m-%d-%H%M%S.md") ;; default file format
  ;;
  ;; Performance
  ;(setq howm-menu-expiry-hours 1) ;; Cache menu N hours
  ;(setq howm-menu-refresh-after-save nil) ;; Speed up note saving
  ;; Use ripgrep as grep
  (setq howm-view-use-grep t)
  (setq howm-view-grep-command "rg")
  (setq howm-view-grep-option "-nH --no-heading --color never")
  (setq howm-view-grep-extended-option nil)
  (setq howm-view-grep-fixed-option "-F")
  (setq howm-view-grep-expr-option nil)
  (setq howm-view-grep-file-stdin-option nil)
  :config
  (define-key howm-menu-mode-map "\C-h" nil)
  (define-key riffle-summary-mode-map "\C-h" nil)
  (define-key howm-view-contents-mode-map "\C-h" nil)
  ;; The hook will rename buffers to their title
  :hook (('howm-mode . 'howm-mode-set-buffer-name)
	 ('after-save . 'howm-mode-set-buffer-name))
  )

;; Writing and coding niceties

;; When using multiple windows, this will resize current window to be more useful
(use-package golden-ratio
  :ensure t)
(golden-ratio-mode 1)


;; Hide all minor modes
(use-package minions
  :ensure t
  :config
  (setq minions-mode-line-lighter ""
	minions-mode-line-delimiters '("" . ""))
  (minions-mode 1))

;;; Hooks and such for loaded modes

(global-display-line-numbers-mode t)
;; Disable line numbers for some modes
(dolist (mode '(org-mode-hook
		term-mode-hook
		shell-mode-hook
		treemacs-mode-hook
		eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

;; Local file per machine.
;; Loaded last to override previous settings.
;(let ((local-settings (expand-file-name "local.el" user-emacs-directory)))
; (when (file-exists-p local-settings)
;   (load-file local-settings)))

;;; Trust my elisp files (this enables flymake byte-compile checking)
(add-to-list 'trusted-content "~/.config/emacs/init.el")
(add-to-list 'trusted-content "~/.config/emacs/early-init.el")
(add-to-list 'trusted-content "~/.config/emacs/user-lisp/")
(add-to-list 'trusted-content "~/.config/emacs/site-lisp/")
(add-to-list 'trusted-content "~/.config/emacs/themes/")

(setq gc-cons-threshold (or bedrock--initial-gc-threshold 800000))
(provide 'init)
;; EOF
