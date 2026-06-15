;; -*- lexical-binding: t -*-
;; emacs org init file for jesper@pobox.com

;; Workflows this org config is intended to manage
;; Primary: outlining books and documents
;; Secondary: agenda related to those books and documents
;; Tertiary: knowledge base connected to said books and documents

;; All other uses are at this point not covered


;; Enable Org mode
(require 'org)
(setq org-todo-keywords
  '((sequence "TODO" "IN-PROGRESS" "WAITING" "DONE")))

;; Must do this so the agenda knows where to look for my files
(setq org-agenda-files '("~/Documents/org"))

;; When a TODO is set to a done state, record a timestamp
(setq org-log-done 'time)

;; Follow the links
(setq org-return-follows-link  t)

;; Make the indentation look nicer and wrap the lines
(add-hook 'org-mode-hook #'(lambda ()
                             (visual-line-mode)
                             (org-indent-mode)))

;; Remap the change priority keys to use the UP or DOWN key
(define-key org-mode-map (kbd "C-c <up>") 'org-priority-up)
(define-key org-mode-map (kbd "C-c <down>") 'org-priority-down)

;; Shortcuts for storing links, viewing the agenda, and starting a capture
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(define-key global-map "\C-cc" 'org-capture)
(define-key global-map "\C-cb" 'org-iswitchb)

;; When you want to change the level of an org item, use SMR
(define-key org-mode-map (kbd "C-c C-g C-r") 'org-shiftmetaright)

;; Hide the markers so you just see bold text as BOLD-TEXT and not *BOLD-TEXT*
(setq org-hide-emphasis-markers t)

;; Pretty bullets
(use-package org-bullets
  :init (add-hook 'org-mode-hook (lambda ()
                                   (org-bullets-mode 1))))


(provide 'jas-org)
;; EOF
