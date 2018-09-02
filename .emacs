(require 'package) 
(setq package-enable-at-startup nil)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))

(package-initialize)

(setq indent-tabs-mode t)
(setq-default tab-width 4)

(setq-default header-line-format 
              (list " " (make-string 79 ?-) "|"))

(require 'dired )

(define-key dired-mode-map (kbd "RET") 'dired-find-alternate-file) ;was dired-advertised-find-file

;;(define-key dired-mode-map (kbd "^") (lambda () (interactive) (find-alternate-file "..")))  ; was dired-up-directory


(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(use-package yasnippet
  :config
  (yas-reload-all))

(use-package web-mode
  :ensure t
  :config
   (setq web-mode-markup-indent-offset 4)
   (setq web-mode-code-indent-offset 4)
   (web-mode-use-tabs)
  
  (add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.tpl\\.php\\.module\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.module?\\'" . web-mode))

  )

(use-package dumb-jump
  :bind (("M-g o" . dumb-jump-go-other-window)
         ("M-g j" . dumb-jump-go)
         ("M-g i" . dumb-jump-go-prompt)
         ("M-g x" . dumb-jump-go-prefer-external)
         ("M-g z" . dumb-jump-go-prefer-external-other-window))
  :config (setq dumb-jump-selector 'ivy) ;; (setq dumb-jump-selector 'helm)
  :ensure)

(use-package rainbow-mode
  :ensure t
  :config
  (add-hook 'less-css-mode-hook (lambda () (rainbow-mode 1)))
  (add-hook 'web-mode-hook (lambda () (rainbow-mode 1)))
  )

(use-package web-beautify
  :ensure t
  :config
  (setenv "PATH" (concat (getenv "PATH") ":/usr/local/bin"))
  (setq exec-path (append exec-path '("/usr/local/bin")))
  )

(use-package vue-mode
  :ensure t
  )

(use-package js2-mode
  :ensure t
  :config
  (add-to-list 'auto-mode-alist (cons (rx ".js" eos) 'js2-mode))
  (setq js-indent-level 8)

  )

(use-package php-mode
  :ensure t
  :config
  (add-to-list 'auto-mode-alist '("\\.php\\'" . php-mode))
  (add-to-list 'auto-mode-alist '("\\.module\\'" . php-mode))
  )

(defun kill-other-buffers ()
  "Kill all other buffers."
  (interactive)
  (mapc 'kill-buffer 
	(delq (current-buffer) 
	      (remove-if-not 'buffer-file-name (buffer-list)))))


(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))

(use-package company
  :ensure t
  :config (global-company-mode))

(use-package color-theme-sanityinc-solarized
  :ensure t
  :config
  (load-theme 'sanityinc-solarized-dark t)
  )

;; (setq web-mode-markup-indent-offset 2)	

(use-package helm
  :ensure t
  :config
  (helm-mode 1)
  (helm-autoresize-mode t)
  (global-set-key (kbd "M-x") 'helm-M-x)
  (setq helm-M-x-fuzzy-match t
	helm-buffers-fuzzy-matching t
	helm-recentf-fuzzy-match t
	helm-buffer-skip-remote-checking t
	)
  (global-set-key (kbd "C-x b") 'helm-mini)
  (global-set-key (kbd "C-x C-f") 'helm-find-files)
  (global-set-key (kbd "M-y") 'helm-show-kill-ring)
  )

(use-package swiper-helm
  :ensure t
  :config
  (global-set-key (kbd "C-s") 'swiper-helm)
  )

(use-package expand-region
  :ensure t
  :config
  (global-set-key (kbd "C-=") 'er/expand-region)
  )

(use-package multiple-cursors
  :ensure t
  :config
  (global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
  (global-set-key (kbd "C->") 'mc/mark-next-like-this)
  (global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
  (global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)
  (global-set-key (kbd "C-=") 'er/expand-region)
  )



;;;;;;;;;;;;;;;;

(show-paren-mode 1)
(set-default 'truncate-lines t)

(when (fboundp 'electric-indent-mode) (electric-indent-mode -1))



(desktop-save-mode 1)

(setq desktop-files-not-to-save "^$")


(setq backup-by-copying t)

;;Stop creating autosave and backup files
(setq make-backup-files nil)
(setq auto-save-default nil)

(delete-selection-mode 1)


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (sanityinc-solarized-dark)))
 '(custom-safe-themes
   (quote
	("4aee8551b53a43a883cb0b7f3255d6859d766b6c5e14bcb01bed572fcbef4328" default)))
 '(electric-indent-mode nil)
 '(mac-option-modifier (quote (:ordinary meta :function alt :mouse alt)))
 '(mac-right-option-modifier nil)
 '(package-selected-packages
   (quote
	(typescript-mode helm-css-scss dumb-jump rainbow-mode less-css-mode skewer-mode simple-httpd lorem-ipsum vue-mode xah-css-mode web-mode web-beautify use-package swiper-helm php-mode multiple-cursors magit js2-mode flycheck expand-region emacsql-psql company color-theme-sanityinc-solarized)))
 '(vc-annotate-very-old-color nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(put 'dired-find-alternate-file 'disabled nil)
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)
