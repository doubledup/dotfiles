(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#242424" "#e5786d" "#95e454" "#cae682" "#8ac6f2" "#333366" "#ccaa8f" "#f6f3e8"])
 '(blink-cursor-mode nil)
 '(custom-enabled-themes (quote (wombat)))
 '(display-line-numbers (quote visual))
 '(ido-enable-flex-matching t)
 '(ido-everywhere t)
 '(ido-mode (quote both) nil (ido))
 '(indent-tabs-mode nil)
 '(inhibit-startup-screen t)
 '(package-archive-priorities (quote (("melpa-stable" . 1))))
 '(package-archives
   (quote
    (("gnu" . "https://elpa.gnu.org/packages/")
     ("melpa-stable" . "https://stable.melpa.org/packages/"))))
 '(package-enable-at-startup t)
 '(package-selected-packages (quote (solarized-theme org)))
 '(ring-bell-function (quote ignore))
 '(scroll-bar-mode nil)
 '(standard-indent 4)
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:height 110 :foundry "SRC" :family "Hack")))))

;; ;; set up ido mode
;; (require 'ido)
;; (setq ido-enable-flex-matching t)
;; (setq ido-everywhere t)
;; (ido-mode 1)

;; ;; set up org mode
;; (setq org-startup-indented t)
;; (setq org-startup-folded "overview")
;; (setq org-directory "~/org")

;; ;; set up fonts
;; (set-face-attribute 'default nil :font "Inconsolata" :height 120)
;; (if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
;; (if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
;; (if (fboundp 'menu-bar-mode) (menu-bar-mode -1))

;; ;; disable that bloody audio ping
;; ;(setq ring-bell-function 'ignore)

;; ;; set up ace-jump-mode
;; ;; ace jump mode major function
;; (add-to-list 'load-path "~/.emacs.d/elpa/ace-jump-mode-2.0/ace-jump-mode.el")
;; (autoload
;;   'ace-jump-mode
;;   "ace-jump-mode"
;;   "Emacs quick move minor mode"
;;   t)
;; (define-key global-map (kbd "C-c SPC") 'ace-jump-mode)
;; ;; enable a more powerful jump back function from ace jump mode
;; (autoload
;;   'ace-jump-mode-pop-mark
;;   "ace-jump-mode"
;;   "Ace jump back:-)"
;;   t)
;; (eval-after-load "ace-jump-mode"
;;   '(ace-jump-mode-enable-mark-sync))
;; (define-key global-map (kbd "C-x SPC") 'ace-jump-mode-pop-mark)

;; ;; ace window mode shortcut
;; (global-set-key (kbd "M-p") 'ace-window)

;; ;; change indents nicely
;; (defun outdent (limit)
;;   (while (search-forward "\n\t" limit t)
;;     (replace-match "\n" nil t)))

;; (defun unindent ()
;;   (interactive)
;;   (save-excursion (outdent 2)))

;; (defun unindent-region ()
;;   (interactive)
;;   (save-excursion
;;     (and (> (point) (mark)) (exchange-point-and-mark))
;;     (outdent (mark))))

;; ;;
;; ;; set up packages from MELPA
;; ;;
;; (require 'package)
;; (let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
;;                     (not (gnutls-available-p))))
;;        (url (concat (if no-ssl "http" "https") "://melpa.org/packages/")))
;; ;  (add-to-list 'package-archives (cons "melpa" url) t))
;;   (add-to-list 'package-archives
;;              '("melpa-stable" . "https://stable.melpa.org/packages/") t))
;; (when (< emacs-major-version 24)
;;   ;; For important compatibility libraries like cl-lib
;;   (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
;; (package-initialize)
;; (custom-set-variables
;;  ;; custom-set-variables was added by Custom.
;;  ;; If you edit it by hand, you could mess it up, so be careful.
;;  ;; Your init file should contain only one such instance.
;;  ;; If there is more than one, they won't work right.
;;  '(custom-safe-themes
;;    (quote
;;     ("8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" default)))
;;  '(package-archives
;;    (quote
;;     (("gnu" . "http://elpa.gnu.org/packages/")
;;      ("melpa-stable" . "https://stable.melpa.org/packages/"))))
;;  '(package-selected-packages (quote (solarized-theme ace-window ace-jump-mode))))
;; (custom-set-faces
;;  ;; custom-set-faces was added by Custom.
;;  ;; If you edit it by hand, you could mess it up, so be careful.
;;  ;; Your init file should contain only one such instance.
;;  ;; If there is more than one, they won't work right.
;;  )

;; ;; set up solarized theme
;; ;; (must be after packages are loaded, as solarized is a MELPA theme)
;; (setq solarized-use-variable-pitch nil
;;       solarized-scale-org-headlines nil)
;; (load-theme 'solarized-light t)
