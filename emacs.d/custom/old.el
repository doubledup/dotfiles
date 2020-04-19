;; set up org mode
(setq org-startup-indented t)
(setq org-startup-folded "overview")
(setq org-directory "~/org")

;; set up fonts
(set-face-attribute 'default nil :font "Inconsolata" :height 120)

;; set up ace-jump-mode
;; ace jump mode major function
(add-to-list 'load-path "~/.emacs.d/elpa/ace-jump-mode-2.0/ace-jump-mode.el")
(autoload
  'ace-jump-mode
  "ace-jump-mode"
  "Emacs quick move minor mode"
  t)
(define-key global-map (kbd "C-c SPC") 'ace-jump-mode)
;; enable a more powerful jump back function from ace jump mode
(autoload
  'ace-jump-mode-pop-mark
  "ace-jump-mode"
  "Ace jump back:-)"
  t)
(eval-after-load "ace-jump-mode"
  '(ace-jump-mode-enable-mark-sync))
(define-key global-map (kbd "C-x SPC") 'ace-jump-mode-pop-mark)

;; ace window mode shortcut
(global-set-key (kbd "M-p") 'ace-window)

;; change indents nicely
(defun outdent (limit)
  (while (search-forward "\n\t" limit t)
    (replace-match "\n" nil t)))

(defun unindent ()
  (interactive)
  (save-excursion (outdent 2)))

(defun unindent-region ()
  (interactive)
  (save-excursion
    (and (> (point) (mark)) (exchange-point-and-mark))
    (outdent (mark))))

(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" default)))
 '(package-archives
   (quote
    (("gnu" . "http://elpa.gnu.org/packages/")
     ("melpa-stable" . "https://stable.melpa.org/packages/"))))
 '(package-selected-packages (quote (solarized-theme ace-window ace-jump-mode))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; set up solarized theme
;; (must be after packages are loaded, as solarized is a MELPA theme)
(setq solarized-use-variable-pitch nil
      solarized-scale-org-headlines nil)
(load-theme 'solarized-light t)
