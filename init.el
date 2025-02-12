;;; init.el --- Load the full configuration -*- lexical-binding: t -*-
;;; Commentary:

;; This file bootstraps the configuration, which is divided into
;; a number of other files.

;;; Code:

;; Produce backtraces when errors occur: can be helpful to diagnose startup issues
;;(setq debug-on-error t)

(let ((minver "25.1"))
  (when (version< emacs-version minver)
    (error "Your Emacs is too old -- this config requires v%s or higher" minver)))
(when (version< emacs-version "26.1")
  (message "Your Emacs is old, and some functionality in this config will be disabled. Please upgrade if possible."))

(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))
(require 'init-benchmarking) ;; Measure startup time

;(defconst *spell-check-support-enabled* nil) ;; Enable with t if you prefer
(defconst *is-a-mac* (eq system-type 'darwin))

;; Adjust garbage collection thresholds during startup, and thereafter

(let ((normal-gc-cons-threshold (* 20 1024 1024))
      (init-gc-cons-threshold (* 128 1024 1024)))
  (setq gc-cons-threshold init-gc-cons-threshold)
  (add-hook 'emacs-startup-hook
            (lambda () (setq gc-cons-threshold normal-gc-cons-threshold))))

;; Bootstrap config

;(setq custom-file (locate-user-emacs-file "custom.el"))
;(require 'init-utils)
;(require 'init-site-lisp) ;; Must come before elpa, as it may provide package.el
;; Calls (package-initialize)
(require 'init-elpa)      ;; Machinery for installing required packages
(require 'init-exec-path) ;; Set up $PATH

;; Allow users to provide an optional "init-preload-local.el"
(require 'init-preload-local nil t)

;; Load configs for specific features and modes
(require-package 'diminish)
(maybe-require-package 'scratch)
(require-package 'command-log-mode)

(require 'init-frame-hooks)
                                        ;(require 'init-xterm)
;(require 'init-themes)
;(require 'init-osx-keys)
;(require 'init-gui-frames)
;(require 'init-dired)
;(require 'init-isearch)
;(require 'init-grep)
;(require 'init-uniquify)
;(require 'init-ibuffer)
                                        ;(require 'init-flycheck)

(require 'init-recentf)
(require 'init-minibuffer)
;;(require 'init-hippie-expand)
(require 'init-company)
;(require 'init-windows)
;(require 'init-sessions)
;;(require 'init-mmm)
;
;(require 'init-editing-utils)
;                                        ;(require 'init-whitespace)
;
;                                        ;(require 'init-vc)
;                                        ;(require 'init-darcs)
(require 'init-git)
(require 'init-github)
;
;;(require 'init-projectile)
;
;;(require 'init-compile)
;;(require 'init-crontab)
;                                        ;(require 'init-textile)
;                                        ;(require 'init-markdown)
;                                        ;(require 'init-csv)
;                                        ;(require 'init-erlang)
;                                        ;(require 'init-javascript)
;                                        ;(require 'init-php)
;                                        ;(require 'init-org)
;                                        ;(require 'init-nxml)
;                                        ;(require 'init-html)
;                                        ;(require 'init-css)
;                                        ;(require 'init-haml)
;                                        ;(require 'init-http)
;                                        ;(require 'init-python)
;                                        ;(require 'init-haskell)
;                                        ;(require 'init-elm)
;                                        ;(require 'init-purescript)
;                                        ;(require 'init-ruby)
;                                        ;(require 'init-rails)
;                                        ;(require 'init-sql)
;                                        ;(require 'init-ocaml)
;                                        ;(require 'init-j)
;                                        ;(require 'init-nim)
;                                        ;(require 'init-rust)
;                                        ;(require 'init-toml)
;                                        ;(require 'init-yaml)
;                                        ;(require 'init-docker)
;                                        ;(require 'init-terraform)
;                                        ;(require 'init-nix)
;                                        ;(maybe-require-package 'nginx-mode)
;
;                                        ;(require 'init-paredit)
;                                        ;(require 'init-lisp)
;                                        ;(require 'init-slime)
;                                        ;(require 'init-clojure)
;                                        ;(require 'init-clojure-cider)
;;(require 'init-common-lisp)
;
;(when *spell-check-support-enabled*
; ; (require 'init-spelling)
;  )
;
;                                        ;(require 'init-misc)
;
;                                        ;(require 'init-folding)
;                                        ;(require 'init-dash)
;
;;;(require 'init-twitter)
;;; (require 'init-mu)
;                                        ;(require 'init-ledger)
;;; Extra packages which don't require any configuration
;
;                                        ;(require-package 'sudo-edit)
;                                        ;(require-package 'gnuplot)
;                                        ;(require-package 'lua-mode)
;                                        ;(require-package 'htmlize)
(when *is-a-mac*
  (require-package 'osx-location)
  )
;;(maybe-require-package 'dotenv-mode)
;(;maybe-require-package 'shfmt
; )
;
(when (maybe-require-package 'uptimes)
  (setq-default uptimes-keep-count 200)
  (add-hook 'after-init-hook (lambda () (require 'uptimes)))
  )
;
;
;                                        ;
;(when (fboundp 'global-eldoc-mode)
;                                        ;  (add-hook 'after-init-hook 'global-eldoc-mode)
;
;  )
;
;                                        ;(require 'init-direnv)
;
;                                        ;
;                                        ;
;(unless (package-installed-p 'evil)
;  (package-install 'evil))
;(require 'evil)
;(evil-mode 1)
;
;(setq
; backup-directory-alist '(("." . "~/.saves-emacs"))
; delete-old-versions t
; kept-new-versions 3
; kept-old-versions 1
; )
;
;
;;; Allow access from emacsclient
;(add-hook 'after-init-hook
;          (lambda ()
;            (require 'server)
;            (unless (server-running-p)
;              (server-start))))
;
;;; Variables configured via the interactive 'customize' interface
;(when (file-exists-p custom-file)
;  (load custom-file))
;
;;; Locales (setting them earlier in this file doesn't work in X)
;(require 'init-locales)
;
;;; Allow users to provide an optional "init-local" containing personal settings
;(require 'init-local nil t)
;
;(provide 'init)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (uptimes github-review forge github-clone bug-reference-github yagist git-commit magit-todos magit git-timemachine git-modes git-blamed company-quickhelp company command-log-mode scratch diminish exec-path-from-shell gnu-elpa-keyring-update fullframe seq zygospore which-key highlight-escape-sequences whole-line-or-region move-dup page-break-lines multiple-cursors avy browse-kill-ring symbol-overlay rainbow-delimiters beacon mode-line-bell vlf list-unicode-display unfill session windswap switch-window marginalia vertico whitespace-cleanup-mode wgrep vc-darcs use-package textile-mode sudo-edit slime-company shfmt regex-tool rainbow-mode popup paredit origami mmm-mode lua-mode ledger-mode ipretty info-colors immortal-scratch ibuffer-vc ibuffer-projectile htmlize highlight-quoted gnuplot flycheck-relint flycheck-package flycheck-ledger flycheck-color-mode-line flycheck-clojure evil envrc elisp-slime-nav elein dotenv-mode diredfl dimmer diff-hl crontab-mode color-theme-sanityinc-tomorrow color-theme-sanityinc-solarized cljsbuild-mode cl-libify cask-mode browse-at-remote auto-compile anzu alert aggressive-indent)))
 '(session-use-package t nil (session)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
 ;; Local Variables:
;; coding: utf-8
;; no-byte-compile: t
;; End:
;;; init.el ends here
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;(require 'package)
;(add-to-list 'package-archives
;         '("melpa" . "http://melpa.org/packages/") t)

;(package-initialize)

(when (not package-archive-contents)
    (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;(add-to-list 'load-general)
(if (version< emacs-version "24.4")
    (require 'setup-ivy-counsel)
;  (require 'setup-helm)
;  (require 'setup-helm-gtags)
  )
;; (require 'setup-ggtags)
;(require 'setup-cedet)
;(require 'setup-editing)

(require 'setup-general)

(message "<<<<<<<<<<<<<<<<<<<evil>>>>>>>>>>>>>>>>>>>>>>")
;; Download Evil
(unless (package-installed-p 'evil)
  (package-install 'evil))
(require 'evil)
(evil-mode 0)

;(global-linum-mode t)

;(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 ;'(package-selected-packages (quote (use-package))))
;(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 ;)

(provide 'init)
;; Local Variables:
;; coding: utf-8
;; no-byte-compile: t
;; End:
;;; init.el ends here
