;;; jai-mode.el --- major mode for jai  -*- lexical-binding: t; -*-

;; copyright (c) 2015-2023 Kristoffer Grönlund
;; modifications (c) 2025 jak2 <jak2@clover-work.shop>

;; author: Kristoffer Grönlund <k@ziran.se>
;; maintainer: jak2 <jak2@clover-work.shop>
;; url: https://github.com/krig/jai-mode
;; version: 0.0.1
;; package-requires: ((emacs "26.1"))
;; keywords: languages

;; this file is not part of gnu emacs.

;; this program is free software: you can redistribute it and/or modify
;; it under the terms of the gnu general public license as published by
;; the free software foundation, either version 3 of the license, or
;; (at your option) any later version.

;; this program is distributed in the hope that it will be useful,
;; but without any warranty; without even the implied warranty of
;; merchantability or fitness for a particular purpose. see the
;; gnu general public license for more details.

;; you should have received a copy of the gnu general public license
;; along with this program. if not, see <https://www.gnu.org/licenses/>.

;;; commentary:
;; major mode for jai.

;;; code:

(require 'rx)
(require 'js)
(require 'compile)

(defconst jai-mode-syntax-table
  (let ((table (make-syntax-table)))
    (modify-syntax-entry ?\" "\"" table)
    (modify-syntax-entry ?\\ "\\" table)
    (modify-syntax-entry ?_ "w" table)
    (modify-syntax-entry ?/ ". 124b" table)
    (modify-syntax-entry ?* ". 23n" table)
    (modify-syntax-entry ?\n "> b" table)
    (modify-syntax-entry ?\^m "> b" table)
    table))

(defconst jai-builtins
  '("it" "it_index"))

(defconst jai-keywords
  '("if" "ifx" "else" "then" "while" "for" "switch" "case" "struct" "enum"
    "return" "remove" "continue" "break" "defer" "inline" "no_inline"
    "using" "code_of" "initializer_of" "size_of" "type_of" "cast"  "type_info"
    "null" "true" "false" "xx" "context" "operator" "push_context" "is_constant"
    "enum_flags" "union" "interface"))

(defconst jai-typenames
  '("int" "u64" "u32" "u16" "u8"
    "s64" "s32" "s16" "s8" "float"
    "float32" "float64" "string"
    "bool"))

(defun jai-wrap-word-rx (s)
  (concat "\\<" s "\\>"))

(defun jai-keywords-rx (keywords)
  (jai-wrap-word-rx (regexp-opt keywords t)))

(defconst jai-hat-type-rx (rx (group (and "^" (1+ word)))))
(defconst jai-dollar-type-rx (rx (group "$" (or (1+ word) (opt "$")))))
(defconst jai-number-rx
  (rx (and
       symbol-start
       (or (and (+ digit) (opt (and (any "eE") (opt (any "-+")) (+ digit))))
           (and "0" (any "xX") (+ hex-digit)))
       (opt (and (any "_" "A-Z" "a-z") (* (any "_" "A-Z" "a-z" "0-9"))))
       symbol-end)))

(defconst jai-font-lock-defaults
  `((,(jai-keywords-rx jai-keywords) 1 font-lock-keyword-face)
    ("\\('[[:word:]]\\)\\>" 1 font-lock-constant-face)
    (,(jai-keywords-rx jai-builtins) 1 font-lock-variable-name-face)
    ("#\\w+" . font-lock-preprocessor-face)
    ("@\\w+" . font-lock-preprocessor-face)
    ("\\\".*\\\"" . font-lock-string-face)
    (,(jai-wrap-word-rx jai-number-rx) . font-lock-constant-face)
    (,(jai-keywords-rx jai-typenames) 1 font-lock-type-face)
    (,jai-hat-type-rx 1 font-lock-type-face)
    (,jai-dollar-type-rx 1 font-lock-type-face)
    ("\\<[A-Z][A-Z0-9_]*[a-z][a-zA-Z0-9_]*\\>" . font-lock-type-face)
    ("\\<\\([a-zA-Z0-9_]+\\)\\s-*\\(::?\\)\\s-*(" 1 font-lock-function-name-face)
    ("\\<\\([a-zA-Z0-9_]+\\)\\s-*(" 1 font-lock-function-name-face)
    ("\\<[A-Z][A-Z0-9_]+\\>" . font-lock-constant-face)
    (,(rx (any "(){}[]<>;.:*|!?^&%+-=/")) . font-lock-keyword-face)))

(unless (fboundp 'setq-local)
  (defmacro setq-local (var val)
    `(set (make-local-variable ',var) ,val)))

(defconst jai--defun-rx "\(.*\).*\{")

(defface font-lock-bracket-face
  '((t (:foreground "red" :weight bold)))
  "face for highlighting brackets and punctuation in jai mode.")

(defmacro jai-paren-level ()
  `(car (syntax-ppss)))

(defun jai-line-is-defun ()
  (interactive)
  (save-excursion
    (beginning-of-line)
    (let (found)
      (while (and (not (eolp)) (not found))
        (if (looking-at jai--defun-rx)
            (setq found t)
          (forward-char 1)))
      found)))

(defun jai-beginning-of-defun ()
  (interactive)
  (let ((orig-level (jai-paren-level)))
    (while (and
            (not (jai-line-is-defun))
            (not (bobp))
            (> orig-level 0))
      (setq orig-level (jai-paren-level))
      (while (>= (jai-paren-level) orig-level)
        (skip-chars-backward "^{")
        (backward-char))))
  (when (jai-line-is-defun)
    (beginning-of-line)))

(defun jai-end-of-defun ()
  (interactive)
  (let ((orig-level (jai-paren-level)))
    (when (> orig-level 0)
      (jai-beginning-of-defun)
      (end-of-line)
      (setq orig-level (jai-paren-level))
      (skip-chars-forward "^}")
      (while (>= (jai-paren-level) orig-level)
        (skip-chars-forward "^}")
        (forward-char)))))

(defalias 'jai-parent-mode
  (if (fboundp 'prog-mode) 'prog-mode 'fundamental-mode))

(add-hook 'jai-mode-hook
          (lambda ()
            (setq imenu-generic-expression
                  '(("type" "^\\(.*:*.*\\) : " 1)
                    ("function" "^\\(.*\\) :: " 1)
                    ("struct" "^\\(.*\\) *:: *\\(struct\\)\\(.*\\){" 1)))))

(defun jai--indent-on-parentheses ()
  (when (and (= (char-syntax (char-before)) ?\))
             (= (save-excursion (back-to-indentation) (point)) (1- (point))))
    (js-indent-line)))

(defun jai--add-self-insert-hooks ()
  (add-hook 'post-self-insert-hook
            'jai--indent-on-parentheses))

;;;###autoload
(define-derived-mode jai-mode jai-parent-mode "Jai"
  :syntax-table jai-mode-syntax-table
  :group 'jai
  (setq bidi-paragraph-direction 'left-to-right)
  (setq-local require-final-newline mode-require-final-newline)
  (setq-local parse-sexp-ignore-comments t)
  (setq-local comment-start-skip "\\(//+\\|/\\*+\\)\\s *")
  (setq-local comment-start "//")
  (setq-local block-comment-start "/*")
  (setq-local block-comment-end "*/")
  (setq-local indent-line-function 'js-indent-line)
  (setq-local font-lock-defaults '(jai-font-lock-defaults))
  (setq-local beginning-of-defun-function 'jai-beginning-of-defun)
  (setq-local end-of-defun-function 'jai-end-of-defun)
  (jai--add-self-insert-hooks)
  (font-lock-ensure))

;;;###autoload
(add-to-list 'auto-mode-alist '("\\.jai\\'" . jai-mode))

(defconst jai--error-regexp
  "\\([^ \n:]+.*\.jai\\):\\([0-9]+\\),\\([0-9]+\\):")
(push `(jai ,jai--error-regexp 1 2 3 2) compilation-error-regexp-alist-alist)
(push 'jai compilation-error-regexp-alist)

(provide 'jai-mode)
;;; jai-mode.el ends here