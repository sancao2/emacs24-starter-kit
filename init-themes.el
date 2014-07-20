;; -*- coding: utf-8 -*-

(require 'color-theme)
(color-theme-initialize)
(if window-system
    (color-theme-deep-blue)
  ;; (color-theme-tty-dark)
  ;; (color-theme-comidia)
  ;; (color-theme-gnome2)
  ;; (color-theme-dark-laptop)
  (color-theme-charcoal-black))


(provide 'init-themes)
