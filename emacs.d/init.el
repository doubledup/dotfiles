;; Emacs init order:
;; site-start init default abbrevs packages after-init-time after-init-hook

; set up package system
(setq package-archives
      '(("gnu" . "https://elpa.gnu.org/packages/")
        ("melpa-stable" . "https://stable.melpa.org/packages/")))
(setq package-archive-priorities '(("melpa-stable" . 1)))
(setq package-selected-packages '(color-theme-sanityinc-tomorrow evil-org evil org))
(package-initialize)

; refresh archives, if necessary
(unless package-archive-contents
  (package-refresh-contents))
; install all packages
(dolist (package package-selected-packages)
  (unless (package-installed-p package)
    (package-install package)))

(blink-cursor-mode 0)
(global-display-line-numbers-mode 1)
(scroll-bar-mode 0)
(tool-bar-mode 0)
;; auto-revert-mode

(setq default-directory "~/")
;; (setq display-line-numbers-type 'relative)
(setq indent-tabs-mode nil)
(setq inhibit-startup-screen t)
(setq make-backup-files nil)
(setq ring-bell-function 'ignore)
(setq standard-indent 4)
(setq vc-follow-symlinks t)

(setq org-startup-folded t)

; (define-key org-mode-map (kbd "C-c a") 'org-agenda)

;; Note: no need to call require for packages, as package-initialize
;; in init.el takes care of this
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(ido-mode 1)

(evil-mode 1)

(load "~/.emacs.d/customize")
(if (file-exists-p "~/.emacs.d/init.os.el")
    (load "~/.emacs.d/init.os"))
(if (file-exists-p "~/.emacs.d/init.local.el")
    (load "~/.emacs.d/init.local"))
