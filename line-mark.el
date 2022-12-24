;;; line-mark.el --- mark variant for operating on lines  -*- lexical-binding: t; -*-

;; Copyright (C) 2022  Overdr0ne

;; Author: Overdr0ne <scmorris.dev@gmail.com>
;; Keywords: tools

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; Like rectangle-mark-mode, but for lines. Also like Vim’s visual line mode.

;;; Code:

(define-minor-mode line-mark-mode
  "Minor mode for marking entire lines.")

(defvar line-mark--point-after-p t)

(defun line-mark-post-command ()
  (cond ((equal (point) (mark))
         (message "penises")
         (if line-mark--point-after-p
             (previous-line)
           (next-line)))
        ((< (point) (mark))
         (beginning-of-line))
        ((not (equal (point) (line-beginning-position)))
         (end-of-line)
         (forward-char)))
  (setq line-mark--point-after-p (> (point) (mark))))

(defun line-mark-mode-disable ()
  (remove-hook 'post-command-hook #'line-mark-post-command))
(add-hook 'line-mark-mode-off-hook #'line-mark-mode-disable)

(defun line-mark-mode-enable ()
  "Enable line mark mode."
  (add-hook 'deactivate-mark-hook
            (lambda () (line-mark-mode -1)))
  (add-hook 'post-command-hook #'line-mark-post-command)
  (beginning-of-line)
  (unless (region-active-p)
    (push-mark (point) t t)
    (message "Mark set (line mode)"))
  (forward-line)
  (setq line-mark--point-after-p t))
(add-hook 'line-mark-mode-on-hook #'line-mark-mode-enable)

(provide 'line-mark)
;;; line-mark.el ends here
