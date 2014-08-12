(require 'ecb-autoloads)

(add-hook 'after-init-hook (lambda () (load "slime")))

(setq stack-trace-on-error t)

(menu-bar-mode t)

(require 'quack)

;;org-mode
;;add global key set
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)

;;color-theme
;;(require 'color-theme)

;;(require 'color-theme-solarized)
;;(load-theme 'solarized-dark t)
;;zenburn color-theme
(load-theme 'zenburn t)

;;yasnippet
(add-to-list 'load-path
              "~/.emacs.d/plugins/yasnippet")
(require 'yasnippet)
(setq yas-snippet-dirs
        ;; personal snippets
      '("~/.emacs.d/snippets"                
;;      foo-mode and bar-mode snippet collection
;;      "/path/to/some/collection/"
;;      the yasmate collection
        "~/.emacs.d/plugins/yasnippet/yasmate/snippets"
;;      the default collection
        "~/.emacs.d/plugins/yasnippet/snippets"
        ))
(yas-global-mode 1)

;;Enhanced-Ruby-Mode
(add-to-list 'load-path "~/.emacs.d/plugins/enhanced-ruby-mode")
;; must be added after any path containing old ruby-mode
(autoload 'enh-ruby-mode "enh-ruby-mode" "Major mode for ruby files" t)
(add-to-list 'auto-mode-alist '("\\.rb$" . enh-ruby-mode))
(add-to-list 'interpreter-mode-alist '("ruby" . enh-ruby-mode))
(eval-after-load 'inf-ruby
  '(define-key inf-ruby-minor-mode-map
     (kbd "C-c C-s") 'inf-ruby-console-auto))

;; optional, so that still works if ruby points to ruby1.8
;;(setq enh-ruby-program "(path-to-ruby1.9)/bin/ruby")

;;inf-ruby
(autoload 'inf-ruby-minor-mode "inf-ruby" "Run an inferior Ruby process" t)
(add-hook 'enh-ruby-mode-hook 'inf-ruby-minor-mode)
(add-hook 'after-init-hook 'inf-ruby-switch-setup)

;;auto-complete
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories
             "~/.emacs.d/.cask/24.3.50.1/elpa/auto-complete-20130724.1750/dict")
(ac-config-default)
(setq ac-ignore-case nil)
(add-to-list 'ac-modes 'enh-ruby-mode)
(add-to-list 'ac-modes 'web-mode)

;;flymake-ruby
(require 'flymake-ruby)
;;(add-hook 'ruby-mode-hook 'flymake-ruby-load)
(add-hook 'enh-ruby-mode-hook 'flymake-ruby-load)

;;robe
(defadvice inf-ruby-console-auto (before activate-rvm-for-robe activate)
  (rvm-activate-corresponding-ruby))
;;(add-hook 'ruby-mode-hook 'robe-mode)
(add-hook 'enh-ruby-mode-hook 'robe-mode)
;;(push 'company-robe company-backends)
(add-hook 'robe-mode-hook 'ac-robe-setup)

;;smartparens
(require 'smartparens-config)
(require 'smartparens-ruby)
(smartparens-global-mode)
(show-smartparens-global-mode t)
(sp-with-modes '(rhtml-mode)
  (sp-local-pair "<" ">")
  (sp-local-pair "<%" "%>"))

;;grizzl, projectile
(require 'grizzl)
(require 'projectile)
(projectile-global-mode)
(setq projectile-enable-caching t)
(setq projectile-completion-system 'grizzl)
;; Press Command-p for fuzzy find in project
(global-set-key (kbd "s-p") 'projectile-find-file)
;; Press Command-b for fuzzy switch buffer
(global-set-key (kbd "s-b") 'projectile-switch-to-buffer)

;;helm
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; PACKAGE: helm              ;;
;;                            ;;
;; GROUP: Convenience -> Helm ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'helm)

;; must set before helm-config,  otherwise helm use default
;; prefix "C-x c", which is inconvenient because you can
;; accidentially pressed "C-x C-c"
(setq helm-command-prefix-key "C-c h")

(require 'helm-config)
(require 'helm-eshell)
(require 'helm-files)
(require 'helm-grep)

(define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ; rebihnd tab to do persistent action
(define-key helm-map (kbd "C-i") 'helm-execute-persistent-action) ; make TAB works in terminal
(define-key helm-map (kbd "C-z")  'helm-select-action) ; list actions using C-z

(define-key helm-grep-mode-map (kbd "<return>")  'helm-grep-mode-jump-other-window)
(define-key helm-grep-mode-map (kbd "n")  'helm-grep-mode-jump-other-window-forward)
(define-key helm-grep-mode-map (kbd "p")  'helm-grep-mode-jump-other-window-backward)

(setq
 helm-google-suggest-use-curl-p t
 helm-scroll-amount 4 ; scroll 4 lines other window using M-<next>/M-<prior>
 helm-quick-update t ; do not display invisible candidates
 helm-idle-delay 0.01 ; be idle for this many seconds, before updating in delayed sources.
 helm-input-idle-delay 0.01 ; be idle for this many seconds, before updating candidate buffer
 helm-ff-search-library-in-sexp t ; search for library in `require' and `declare-function' sexp.

 helm-split-window-default-side 'other ;; open helm buffer in another window
 helm-split-window-in-side-p t ;; open helm buffer inside current window, not occupy whole other window
 helm-buffers-favorite-modes (append helm-buffers-favorite-modes
                                     '(picture-mode artist-mode))
 helm-candidate-number-limit 200 ; limit the number of displayed canidates
 helm-M-x-requires-pattern 0     ; show all candidates when set to 0
 helm-boring-file-regexp-list
 '("\\.git$" "\\.hg$" "\\.svn$" "\\.CVS$" "\\._darcs$" "\\.la$" "\\.o$" "\\.i$") ; do not show these files in helm buffer
 helm-ff-file-name-history-use-recentf t
 helm-move-to-line-cycle-in-source t ; move to end or beginning of source
                                        ; when reaching top or bottom of source.
 ido-use-virtual-buffers t      ; Needed in helm-buffers-list
 helm-buffers-fuzzy-matching t          ; fuzzy matching buffer names when non--nil
                                        ; useful in helm-mini that lists buffers
 )

;; Save current position to mark ring when jumping to a different place
(add-hook 'helm-goto-line-before-hook 'helm-save-current-pos-to-mark-ring)

(helm-mode 1)

;;(require 'rvm)
