;; copyright (c) 2025 jak2 <jak2@clover-work.shop>

;; author: jak2 <jak2@clover-work.shop>
;; version: 0.0.1
;; package-requires: ((emacs "26.1"))
;; keywords: themes

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

(deftheme s-plus-clover-dark "s-plus-clover-dark")

(let ((bg "#252525")
      (fg "#D8C391")
      (line-highlight "#2F2F2F")
      (type-color "#9CF69E")
      (fn-keyword-builtin "#FEF2D8")
      (punctuation "#FEF2D8")
      (number-constant-enum "#B6AFA6")
      (string-color "#AED2EF")
      (cursor-color "#90EE90")
      (selection-color "#0000FF")
      (comment-color "#37CB4E"))

  (custom-theme-set-faces
   's-plus-clover-dark

   `(default ((t (:background ,bg :foreground ,fg))))

   `(hl-line ((t (:background ,line-highlight))))

   `(cursor ((t (:background ,cursor-color))))

   `(region ((t (:background ,selection-color))))

   `(font-lock-comment-face ((t (:foreground ,comment-color :slant italic))))
   `(font-lock-comment-delimiter-face ((t (:foreground ,comment-color :slant italic))))

   `(font-lock-type-face ((t (:foreground ,type-color))))

   `(font-lock-function-name-face ((t (:foreground ,fn-keyword-builtin))))
   `(font-lock-builtin-face ((t (:foreground ,fn-keyword-builtin))))
   `(font-lock-keyword-face ((t (:foreground ,fn-keyword-builtin))))

   `(font-lock-string-face ((t (:foreground ,string-color))))

   `(font-lock-punctuation-face ((t (:foreground ,punctuation))))

   `(font-lock-constant-face ((t (:foreground ,number-constant-enum))))
   `(font-lock-variable-name-face ((t (:foreground ,number-constant-enum))))
   `(font-lock-bool-face ((t (:foreground ,number-constant-enum))))

   `(highlight ((t (:background ,bg))))

   `(mode-line ((t (:background ,fg :foreground ,bg :box nil))))
   `(mode-line-inactive ((t (:background ,fg :foreground ,bg :box nil))))

   `(fringe ((t (:background ,bg))))

   ))

(provide-theme 's-plus-clover-dark)