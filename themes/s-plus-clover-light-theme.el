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

(deftheme s-plus-clover-light "s-plus-clover-light")

(let ((bg "#C5C1BC")
      (fg "#6A5320")
      (line-highlight "#D4D2CE")
      (type-color "#098A4F")
      (highlight "#393E69")
      (number-constant-enum "#6C6C6C")
      (string-color "#3B82B0")
      (cursor-color "#6363D6")
      (selection-color "#9AF2BD")
      (comment-color "#6363D6")
      (paren-match-color "#D56D8A"))

  (custom-theme-set-faces
   's-plus-clover-light

   `(default ((t (:background ,bg :foreground ,fg))))

   `(hl-line ((t (:background ,line-highlight))))

   `(cursor ((t (:background ,cursor-color))))

   `(region ((t (:background ,selection-color))))

   `(font-lock-comment-face ((t (:foreground ,comment-color :slant italic))))
   `(font-lock-comment-delimiter-face ((t (:foreground ,comment-color :slant italic))))

   `(font-lock-type-face ((t (:foreground ,type-color))))

   `(font-lock-function-name-face ((t (:foreground ,highlight))))
   `(font-lock-builtin-face ((t (:foreground ,highlight))))
   `(font-lock-keyword-face ((t (:foreground ,highlight))))

   `(font-lock-string-face ((t (:foreground ,string-color))))

   `(font-lock-constant-face ((t (:foreground ,number-constant-enum))))
   `(font-lock-variable-name-face ((t (:foreground ,number-constant-enum))))
   `(font-lock-bool-face ((t (:foreground ,number-constant-enum))))

   `(font-lock-bracket-face ((t (:foreground ,highlight))))

   `(highlight ((t (:background ,bg))))

   `(mode-line ((t (:background ,fg :foreground ,bg :box nil :weight normal))))
   `(mode-line-inactive ((t (:background ,fg :foreground ,bg :box nil :weight normal))))

   `(mode-line-buffer-id ((t (:weight normal :foreground ,bg :background ,fg))))

   `(help-key-binding ((t (:background ,bg :foreground ,fg :box (:line-width 1 :color ,bg)))))

   `(show-paren-match ((t (:background ,paren-match-color :foreground ,bg))))

   `(fringe ((t (:background ,bg))))

   ))

(provide-theme 's-plus-clover-light)