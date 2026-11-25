;;; early-init.el --- runs before the UI and package system load  -*- lexical-binding: t; -*-

;; Faster startup: don't garbage collect while loading the config.
(setq gc-cons-threshold most-positive-fixnum)
(add-hook 'emacs-startup-hook
          (lambda () (setq gc-cons-threshold (* 64 1024 1024))))

;; LSP servers send big JSON payloads; read more per chunk.
(setq read-process-output-max (* 4 1024 1024))

;; Strip the chrome before the first frame is drawn (no flicker).
(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)
(setq inhibit-startup-screen t
      frame-inhibit-implied-resize t)
