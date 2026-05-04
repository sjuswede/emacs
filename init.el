;; -*- lexical-binding: t -*-
;; emacs init file for jesper@pobox.com

;;;; Startup debugging tools
;; (setopt debug-on-error t)
;; Prefer .el file if newer than .elc
(setq load-prefer-newer t)

;;; Code

;; Set me
(setq user-full-name "Jesper Anderson")
(setq user-mail-address "jesper@pobox.com")

;; Add directories to emacs's `load-path' recursively.
;; if path does not exist, create directory.
;; Need to do this before requiring the functions below
(let* ((lisp-dir '("site-lisp/" "user-lisp/" "themes/")))
  (dolist (lisp-path lisp-dir)
    (when (not (file-exists-p lisp-path))
      (make-directory (concat user-emacs-directory lisp-path) t))
    (let* ((load-dir (concat user-emacs-directory lisp-path))
           (default-directory load-dir))
      (setq load-path
            (append
             (let ((load-path (copy-sequence load-path)))
               (append
                (copy-sequence (normal-top-level-add-to-load-path '(".")))
                (normal-top-level-add-subdirs-to-load-path)))
             load-path)))))

;; Keep my .emacs.d clean!
(require 'no-littering)
(setq custom-file (no-littering-expand-etc-file-name "custom.el"))
;; You read it right. No reading in the custom.el.

;;; All the bits and bobs live in external files
;;; Load them now

(require 'jas-basic)
(require 'jas-completion)
;(require 'jas-org)

;; Set a theme which is nice
(use-package emacs
  :config
  (load-theme 'modus-vivendi)
  :if (display-graphic-p))

;;; Trust all of my elisp files (this enables flymake byte-compile checking)
(add-to-list 'trusted-content "~/.config/emacs/init.el")
(add-to-list 'trusted-content "~/.config/emacs/early-init.el")
(add-to-list 'trusted-content "~/.config/emacs/user-lisp/")
(add-to-list 'trusted-content "~/.config/emacs/site-lisp/")
(add-to-list 'trusted-content "~/.config/emacs/themes/")

(setq gc-cons-threshold (or bedrock--initial-gc-threshold 800000))
(provide 'emacs)
;; EOF
