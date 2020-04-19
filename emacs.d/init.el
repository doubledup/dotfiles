;; Emacs init order:
;; site-start init default abbrevs packages after-init-time after-init-hook

(package-initialize)
(load "~/.emacs.d/custom/global")
(load "~/.emacs.d/custom/local")
(load "~/.emacs.d/custom/customize")
