(require 'ecb-autoloads)

(add-hook 'after-init-hook (lambda () (load "slime")))

(setq stack-trace-on-error t)

(require 'quack)

(require 'init-themes)

;;add global key set
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)

