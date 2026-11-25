;;; init.el --- starter config for Ruby on Rails  -*- lexical-binding: t; -*-
;;
;; Mirrors the Zed setup: ruby-lsp + standard, format on save, Berkeley Mono,
;; light/dark theme that follows the system, file finder, project search, git.
;;
;; After editing this file: M-x eval-buffer (or just restart Emacs).

;;;; ------------------------------------------------------------------
;;;; Packages
;;;; ------------------------------------------------------------------
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)
(unless package-archive-contents (package-refresh-contents))

(require 'use-package)
(setq use-package-always-ensure t)   ; install anything missing on startup

;; Keep M-x customize from writing junk into this file.
(setq custom-file (locate-user-emacs-file "custom.el"))
(load custom-file 'noerror)

;;;; ------------------------------------------------------------------
;;;; macOS + shell environment
;;;; ------------------------------------------------------------------
;; A GUI Emacs launched from the Dock doesn't see your zsh PATH, so it
;; can't find rbenv's shims (ruby, ruby-lsp, bundle, rspec...). Fix that.
(use-package exec-path-from-shell
  :if (memq window-system '(mac ns))
  :config
  (dolist (var '("PATH" "MANPATH" "RBENV_ROOT" "RBENV_VERSION" "GEM_HOME" "GEM_PATH"))
    (add-to-list 'exec-path-from-shell-variables var))
  (exec-path-from-shell-initialize))

(when (eq system-type 'darwin)
  (setq mac-command-modifier 'super      ; Cmd = super, so Cmd-c/v/s work like elsewhere
        mac-option-modifier  'meta)      ; Option = Meta (M-x is Option-x)
  (global-set-key (kbd "s-s") #'save-buffer)
  (global-set-key (kbd "s-c") #'kill-ring-save)
  (global-set-key (kbd "s-v") #'yank)
  (global-set-key (kbd "s-z") #'undo)
  (global-set-key (kbd "s-w") #'kill-current-buffer)
  (global-set-key (kbd "s-p") #'projectile-find-file)  ; like Cmd-P in Zed
  (global-set-key (kbd "s-F") #'consult-ripgrep))      ; like Cmd-Shift-F

;;;; ------------------------------------------------------------------
;;;; Look and feel
;;;; ------------------------------------------------------------------
(set-face-attribute 'default nil :family "Berkeley Mono" :height 180)  ; 18pt

;; Built-in, high-contrast themes: modus-vivendi (dark) by default.
;; Switch any time with M-x load-theme, or toggle light/dark with M-x modus-themes-toggle.
(setq modus-themes-italic-constructs t
      modus-themes-bold-constructs t
      modus-themes-to-toggle '(modus-vivendi modus-operandi))
(load-theme 'modus-vivendi t)

(global-display-line-numbers-mode 1)
(column-number-mode 1)
(global-hl-line-mode 1)
(pixel-scroll-precision-mode 1)
(setq-default indent-tabs-mode nil
              fill-column 100)
(setq ring-bell-function #'ignore
      use-short-answers t
      confirm-kill-emacs #'y-or-n-p           ; like Zed's confirm_quit
      scroll-margin 4
      scroll-conservatively 101)

;;;; ------------------------------------------------------------------
;;;; Sane file behavior
;;;; ------------------------------------------------------------------
(global-auto-revert-mode 1)        ; pick up changes from git checkout, rubocop -a, etc.
(save-place-mode 1)                ; reopen files where you left off
(recentf-mode 1)
(savehist-mode 1)
(electric-pair-mode 1)
(delete-selection-mode 1)
(setq make-backup-files nil        ; no foo.rb~ files in your repo
      create-lockfiles nil         ; no .#foo.rb files either
      auto-save-file-name-transforms
      `((".*" ,(locate-user-emacs-file "auto-save/") t)))
(make-directory (locate-user-emacs-file "auto-save/") t)
(add-hook 'before-save-hook #'delete-trailing-whitespace)

;;;; ------------------------------------------------------------------
;;;; Minibuffer: fuzzy finding everywhere (≈ Zed's command palette)
;;;; ------------------------------------------------------------------
(use-package vertico   :init (vertico-mode 1))
(use-package marginalia :init (marginalia-mode 1))
(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

(use-package consult
  :bind (("C-x b"   . consult-buffer)
         ("M-s l"   . consult-line)        ; search lines in buffer (C-s stays isearch)
         ("M-g i"   . consult-imenu)        ; jump to method/class in file
         ("M-s r"   . consult-ripgrep)))    ; project-wide search

;; Shows available keys after a prefix (built in since Emacs 30).
(which-key-mode 1)

;;;; ------------------------------------------------------------------
;;;; In-buffer completion popup
;;;; ------------------------------------------------------------------
(use-package corfu
  :custom
  (corfu-auto t)
  (corfu-auto-delay 0.15)
  (corfu-auto-prefix 2)
  (corfu-cycle t)
  :init (global-corfu-mode 1))

;;;; ------------------------------------------------------------------
;;;; Projects + Rails navigation
;;;; ------------------------------------------------------------------
(use-package projectile
  :demand t
  :init
  (setq projectile-project-search-path '(("~/Developer" . 2))
        projectile-enable-caching t)
  :config
  (add-to-list 'projectile-globally-ignored-file-suffixes ".rbi")  ; like Zed's file_scan_exclusions
  (projectile-mode 1)
  (keymap-set projectile-mode-map "C-c p" projectile-command-map))

;; Rails-aware jumps: model <-> controller <-> view <-> spec, routes, logs,
;; rails console/server/generate. Prefix: C-c r
(use-package projectile-rails
  :after projectile
  :config
  (projectile-rails-global-mode 1)
  (define-key projectile-rails-mode-map (kbd "C-c r") #'projectile-rails-command-map))

;;;; ------------------------------------------------------------------
;;;; Tree-sitter (fast, accurate highlighting; installs grammars on demand)
;;;; ------------------------------------------------------------------
(use-package treesit-auto
  :custom
  (treesit-auto-install t)          ; compile missing grammars automatically
  :config
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode 1))
(setq treesit-font-lock-level 4
      treesit-auto-install-grammar 'always)  ; Emacs 31's own installer: don't prompt

;;;; ------------------------------------------------------------------
;;;; Ruby
;;;; ------------------------------------------------------------------
(add-to-list 'auto-mode-alist
             '("\\(?:Gemfile\\|Rakefile\\|Guardfile\\|Capfile\\|\\.rake\\|\\.ru\\|\\.jbuilder\\|\\.builder\\)\\'"
               . ruby-ts-mode))
(setq ruby-insert-encoding-magic-comment nil)

;; IRB / rails console inside Emacs. In a Rails project: M-x inf-ruby-console-auto
(use-package inf-ruby
  :hook ((ruby-mode ruby-ts-mode) . inf-ruby-minor-mode)
  :config
  ;; Let `binding.irb` / `debugger` breakpoints in specs drop you into inf-ruby.
  (add-hook 'compilation-filter-hook #'inf-ruby-auto-enter))

;; Run specs from the file you're in. C-c , v = this file, C-c , s = spec at point,
;; C-c , a = all, C-c , r = rerun last, C-c , t = toggle spec <-> implementation.
(use-package rspec-mode
  :hook ((ruby-mode ruby-ts-mode) . rspec-mode)
  :custom
  (rspec-use-spring-when-possible nil)
  (compilation-scroll-output t))

;; Minitest projects: same idea, C-c , v / C-c , s
(use-package minitest
  :hook ((ruby-mode ruby-ts-mode) . minitest-enable-appropriate-mode))

;;;; ------------------------------------------------------------------
;;;; ERB / HTML views
;;;; ------------------------------------------------------------------
(use-package web-mode
  :mode ("\\.erb\\'" "\\.html?\\'")
  :custom
  (web-mode-markup-indent-offset 2)
  (web-mode-code-indent-offset 2)
  (web-mode-css-indent-offset 2)
  (web-mode-enable-auto-pairing t)
  (web-mode-enable-current-element-highlight t))

;;;; ------------------------------------------------------------------
;;;; LSP: ruby-lsp via eglot (built in), same options as Zed
;;;; ------------------------------------------------------------------
(use-package eglot
  :ensure nil
  :hook ((ruby-mode ruby-ts-mode) . eglot-ensure)
  :custom
  (eglot-autoshutdown t)
  (eglot-events-buffer-config '(:size 0))   ; skip JSON logging; much faster
  (eglot-confirm-server-edits nil)
  :config
  (add-to-list 'eglot-server-programs
               '((ruby-mode ruby-ts-mode)
                 . ("ruby-lsp"
                    :initializationOptions
                    (:formatter "standard"
                     :linters ["standard"]
                     :enabledFeatures (:diagnostics :json-false)))))
  :bind (:map eglot-mode-map
         ("C-c l a" . eglot-code-actions)
         ("C-c l r" . eglot-rename)
         ("C-c l f" . eglot-format-buffer)
         ("C-c l d" . eldoc-doc-buffer)))

;; Format on save in Ruby buffers (like Zed's format_on_save + language_server).
(defun my/eglot-format-on-save ()
  (add-hook 'before-save-hook #'eglot-format-buffer nil t))
(add-hook 'eglot-managed-mode-hook
          (lambda ()
            (when (derived-mode-p 'ruby-mode 'ruby-ts-mode)
              (my/eglot-format-on-save))))

;; Sticky "which method am I in" header, like Zed's sticky_scroll.
(add-hook 'prog-mode-hook #'which-function-mode)

;;;; ------------------------------------------------------------------
;;;; Git
;;;; ------------------------------------------------------------------
(use-package magit
  :bind ("C-x g" . magit-status))

(use-package diff-hl                 ; +/- markers in the gutter
  :hook ((after-init . global-diff-hl-mode)
         (magit-post-refresh . diff-hl-magit-post-refresh)))

;;;; ------------------------------------------------------------------
;;;; Learning aids
;;;; ------------------------------------------------------------------
;; Show recently used commands at the top of M-x, with their keybindings.
(setq suggest-key-bindings 5)
;; C-h k <key>  = what does this key do?     C-h f = describe function
;; C-h b        = every binding in this buffer  C-h C-q = quick reference card
;; C-h t        = the built-in tutorial (do this first!)
(global-set-key (kbd "M-o") #'other-window)   ; C-x o is a lot of keys to press

;;;; ------------------------------------------------------------------
;;;; Cheat sheet for the Rails-specific keys in this config
;;;; ------------------------------------------------------------------
;; C-c p f   find file in project       C-c p p   switch project
;; M-s r     ripgrep the project        C-x b     switch buffer
;; C-s       search forward (isearch)   M-s l     search lines (consult)
;; M-g i     jump to method in file     M-.  / M-,  go to definition / back
;; M-?       find references            C-c l a/r/f  code action / rename / format
;; C-c r m/c/v  find model/controller/view   C-c r r  rails console
;; C-c , t   toggle spec <-> code       C-c , v / s / r  run file / at point / rerun
;; C-x g     magit                      C-h m     everything the current modes offer

;;; init.el ends here
