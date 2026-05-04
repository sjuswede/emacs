;; early emacs init for jesper@pobox.com
;; --**--

;; Startup speed, annoyance suppression
(setq bedrock--initial-gc-threshold gc-cons-threshold)
(setq gc-cons-threshold most-positive-fixnum)
(setq byte-compile-warnings '(not obsolete))
(setq warning-suppress-log-types '((comp) (bytecomp)))
(setq native-comp-async-report-warnings-errors 'silent)

;; Silence stupid startup message
(setq inhibit-startup-echo-area-message (user-login-name))

;; Default frame configuration
(tool-bar-mode -1)

;; Faster to disable these here (before they've been initialized)
(unless (eq system-type 'android)
   (push '(menu-bar-lines . 0) default-frame-alist)
   (push '(tool-bar-lines . 0) default-frame-alist)
   ;(push '(vertical-scroll-bars) default-frame-alist)
   )

;; disable scrollbars
;(customize-set-variable 'scroll-bar-mode nil)
;(customize-set-variable 'horizontal-scroll-bar-mode nil)

(scroll-bar-mode -1)
(menu-bar-mode -1)

;; Resizing the Emacs frame can be an expensive part of changing the
;; font. Inhibit this to reduce startup times with fonts that are
;; larger than the system default.
(setq frame-inhibit-implied-resize t
      frame-resize-pixelwise t)

(setq default-frame-alist '(
  (font . "FiraCode Nerd Font Mono-18:style=Retina")
  ;; Setting the face in here prevents flashes of
  ;; color as the theme gets activated
  (background-color . "#000000")
  (foreground-color . "#ffffff")
  (ns-appearance . dark)
  (ns-transparent-titlebar . t)))


;; If an `.el' file is newer than its corresponding `.elc', load the `.el'.
(setq load-prefer-newer t)

(provide 'early-init)
;; EOF
