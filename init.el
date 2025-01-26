;; copyright (c) 2025 jak2 <jak2@clover-work.shop>

;; author: jak2 <jak2@clover-work.shop>
;; version: 0.0.1
;; package-requires: ((emacs "26.1"))
;; keywords: initialization

;; this file is not part of gnu emacs

;; this program is free software: you can redistribute it and/or modify
;; it under the terms of the gnu general public license as published by
;; the free software foundation, either version 3 of the license, or
;; (at your option) any later version

;; this program is distributed in the hope that it will be useful,
;; but without any warranty; without even the implied warranty of
;; merchantability or fitness for a particular purpose. see the
;; gnu general public license for more details

;; you should have received a copy of the gnu general public license
;; along with this program. if not, see <https://www.gnu.org/licenses/>

;; grant me wisdom to see and understand

(tool-bar-mode -1)

(menu-bar-mode -1)

(scroll-bar-mode -1)

(add-to-list 'default-frame-alist '(fullscreen . maximized))

(setq custom-safe-themes t)

(setq inhibit-startup-screen t)

(setq initial-scratch-message nil)

(setq initial-buffer-choice nil)

(set-face-attribute 'default nil :font "Departure Mono" :height 130)

(setq initial-buffer-choice (lambda () (dired "C:/projects/programming")))

(add-to-list 'custom-theme-load-path (expand-file-name "~/.emacs.d/themes"))

(add-hook 'after-init-hook (lambda () (load-theme 's-plus-clover-light)))

(add-to-list 'load-path (expand-file-name "~/.emacs.d/modes"))

(require 'jai-mode)

(add-to-list 'auto-mode-alist '("\\.jai\\'" . jai-mode))

(set-face-attribute 'bold nil :weight 'normal)

(global-hl-line-mode 1)

(setq make-backup-files nil)

(auto-save-mode -1)

(setq ring-bell-function 'ignore)