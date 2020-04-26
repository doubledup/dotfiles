;; Emacs init order:
;; site-start init default abbrevs packages after-init-time after-init-hook

(package-initialize)

(setq package-archives
      '(("gnu" . "https://elpa.gnu.org/packages/")
        ("melpa-stable" . "https://stable.melpa.org/packages/")))
(setq package-archive-priorities '(("melpa-stable" . 1)))
(setq package-selected-packages '(org-evil evil zenburn-theme org))

(blink-cursor-mode 0)
(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode 1)
(setq indent-tabs-mode nil)
(setq inhibit-startup-screen t)
(setq ring-bell-function 'ignore)
(scroll-bar-mode 0)
(setq standard-indent 4)
(tool-bar-mode 0)

;; Note: no need to call require for packages, as package-initialize
;; in init.el takes care of this
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(ido-mode 1)

(evil-mode 1)

(load "~/.emacs.d/customize")
(load "~/.emacs.d/local")
