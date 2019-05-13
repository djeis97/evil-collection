;;; evil-collection-sly.el --- Evil bindings for `sly' -*- lexical-binding: t -*-

;; Copyright (C) 2017 James Nguyen

;; Author: James Nguyen <james@jojojames.com>
;; Maintainer: James Nguyen <james@jojojames.com>
;; Pierre Neidhardt <mail@ambrevar.xyz>
;; URL: https://github.com/emacs-evil/evil-collection
;; Version: 0.0.1
;; Package-Requires: ((emacs "25.1"))
;; Keywords: evil, sly, tools

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:
;; Evil bindings for `sly-mode'.

;;; Code:
(require 'evil-collection)
(require 'sly nil t)

(defvar sly-parent-map)
(defvar sly-db-mode-map)
(defvar sly-inspector-mode-map)
(defvar sly-mode-map)
(defvar sly-popup-buffer-mode-map)
(defvar sly-xref-mode-map)

(defconst evil-collection-sly-maps '(sly-parent-map
				     sly-db-mode-map
				     sly-inspector-mode-map
				     sly-mode-map
				     sly-popup-buffer-mode-map
				     sly-xref-mode-map ))

(defun evil-collection-sly-last-sexp (command &rest args)
  "In normal-state or motion-state, last sexp ends at point."
  (if (and (not evil-move-beyond-eol)
           (or (evil-normal-state-p) (evil-motion-state-p)))
      (save-excursion
        (unless (or (eobp) (eolp)) (forward-char))
        (apply command args))
    (apply command args)))

;;;###autoload
(defun evil-collection-sly-setup ()
  "Set up `evil' bindings for `sly'."
  (unless evil-move-beyond-eol
    (advice-add 'sly-eval-last-expression :around 'evil-collection-sly-last-sexp)
    (advice-add 'sly-pprint-eval-last-expression :around 'evil-collection-sly-last-sexp)
    (advice-add 'sly-eval-print-last-expression :around 'evil-collection-sly-last-sexp)
    (advice-add 'sly-eval-last-expression-in-repl
                :around 'evil-collection-sly-last-sexp))

  (evil-set-initial-state 'sly-db-mode 'normal)
  (evil-set-initial-state 'sly-inspector-mode 'normal)
  (evil-set-initial-state 'sly-popup-buffer-mode 'normal)
  (evil-set-initial-state 'sly-xref-mode 'normal)

  (evil-collection-define-key 'normal 'sly-parent-map
    "gd" 'sly-edit-definition
    (kbd "C-t") 'sly-pop-find-definition-stack)

  (evil-collection-define-key 'normal 'sly-db-mode-map
    [follow-link] 'mouse-face
    "\C-i" 'sly-db-cycle
    "g?" 'describe-mode
    "S" 'sly-db-show-source
    "e" 'sly-db-eval-in-frame
    "d" 'sly-db-pprint-eval-in-frame
    "D" 'sly-db-disassemble
    "i" 'sly-db-inspect-in-frame
    "gj" 'sly-db-down
    "gk" 'sly-db-up
    (kbd "C-j") 'sly-db-down
    (kbd "C-k") 'sly-db-up
    "]]" 'sly-db-details-down
    "[[" 'sly-db-details-up
    (kbd "M-j") 'sly-db-details-down
    (kbd "M-k") 'sly-db-details-up
    "gg" 'sly-db-beginning-of-backtrace
    "G" 'sly-db-end-of-backtrace
    "t" 'sly-db-toggle-details
    "gr" 'sly-db-restart-frame
    "I" 'sly-db-invoke-restart-by-name
    "R" 'sly-db-return-from-frame
    "c" 'sly-db-continue
    "s" 'sly-db-step
    "n" 'sly-db-next
    "o" 'sly-db-out
    "b" 'sly-db-break-on-return
    "a" 'sly-db-abort
    "q" 'sly-db-quit
    "A" 'sly-db-break-with-system-debugger
    "B" 'sly-db-break-with-default-debugger
    "P" 'sly-db-print-condition
    "C" 'sly-db-inspect-condition
    "g:" 'sly-interactive-eval
    "0" 'sly-db-invoke-restart-0
    "1" 'sly-db-invoke-restart-1
    "2" 'sly-db-invoke-restart-2
    "3" 'sly-db-invoke-restart-3
    "4" 'sly-db-invoke-restart-4
    "5" 'sly-db-invoke-restart-5
    "6" 'sly-db-invoke-restart-6
    "7" 'sly-db-invoke-restart-7
    "8" 'sly-db-invoke-restart-8
    "9" 'sly-db-invoke-restart-9)

  (evil-collection-define-key 'normal 'sly-inspector-mode-map
    ;; TODO: `sly-inspector-next' and `sly-inspector-pop' should probably
    ;; just be bound to C-i and C-o.
    "gk" 'sly-inspector-pop
    (kbd "C-k") 'sly-inspector-pop
    "[[" 'sly-inspector-pop
    (kbd "C-o") 'sly-inspector-pop
    "gj" 'sly-inspector-next
    (kbd "C-j") 'sly-inspector-next
    "]]" 'sly-inspector-next
    (kbd "<tab>") 'forward-button
    (kbd "<S-tab>") 'backward-button
    "K" 'sly-inspector-describe
    "e" 'sly-inspector-eval
    "h" 'sly-inspector-history
    "gr" 'sly-inspector-reinspect
    "gv" 'sly-inspector-toggle-verbose
    "." 'sly-inspector-show-source
    "gR" 'sly-inspector-fetch-all
    "q" 'sly-inspector-quit)

  (evil-collection-define-key 'normal 'sly-mode-map
    (kbd "K") 'sly-describe-symbol
    (kbd "C-t") 'sly-pop-find-definition-stack
    ;; goto
    "gd" 'sly-edit-definition
    "gz" 'sly-switch-to-output-buffer)

  (evil-collection-define-key 'normal 'sly-popup-buffer-mode-map
    ;; quit
    "q" 'quit-window

    (kbd "C-t") 'sly-pop-find-definition-stack

    ;; goto
    "gd" 'sly-edit-definition)

  (evil-collection-define-key 'normal 'sly-xref-mode-map
    (kbd "RET") 'sly-goto-xref
    (kbd "S-<return>") 'sly-goto-xref
    "go" 'sly-show-xref
    "gj" 'sly-xref-next-line
    "gk" 'sly-xref-prev-line
    (kbd "C-j") 'sly-xref-next-line
    (kbd "C-k") 'sly-xref-prev-line
    "]]" 'sly-xref-next-line
    "[[" 'sly-xref-prev-line
    "gr" 'sly-recompile-xref
    "gR" 'sly-recompile-all-xrefs
    "r" 'sly-xref-retract)

  (evil-collection-define-key 'normal 'sly-mrepl-mode-map
    "gj" 'sly-mrepl-next-input-or-button
    "gk" 'sly-mrepl-previous-input-or-button
    (kbd "C-j") 'sly-mrepl-next-input-or-button
    (kbd "C-k") 'sly-mrepl-previous-input-or-button
    "]]" 'sly-mrepl-next-input-or-button
    "[[" 'sly-mrepl-previous-input-or-button
    (kbd "C-p") 'sly-repl-previous-input
    (kbd "C-n") 'sly-repl-next-input)

  (add-hook 'sly-popup-buffer-mode-hook #'evil-normalize-keymaps))

(provide 'evil-collection-sly)
;;; evil-collection-sly.el ends here
