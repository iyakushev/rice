;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!
(setq fancy-splash-image (concat doom-user-dir "doomEmacs.svg"))

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Ivan Yakushev"
      user-mail-address "iamaero7@quantumbrains.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

(add-to-list 'default-frame-alist '(undecorated . t))
(add-to-list 'default-frame-alist '(drag-internal-border . 10))
(add-to-list 'default-frame-alist '(internal-border-width . 10))
(set-frame-parameter (selected-frame) 'alpha '(95 95))
(add-to-list 'default-frame-alist '(alpha 95 95))


(setq doom-font (font-spec :family "Iosevka SS05 Extended" :size 18 :height 18 :weight 'bold))
;; (setq doom-font (font-spec :family "Courier" :size 15 :weight 'semibold))
;; (setq doom-font (font-spec :family "Hasklig" :size 15 :weight 'regular))
;; (setq doom-font (font-spec :family "FiraCode Nerd Font" :size 15 :weight 'regular))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-zenburn)

;; (setq hl-todo-keyword-faces
;;       '(("SAFETY" . "#C0FFEE")))

;; Org settings
(setq diary-file "~/.org/diary")
(setq org-id-locations-file "~/.org/.orgids")

;; For some reason it stopped working by default
(setq evil-escape-key-sequence "jk")

;; Allows vertico to open files in new side buffers
(defun cust/vsplit-open (f)
  (let ((evil-vsplit-window-right t))
    (+evil/window-vsplit-and-follow)
    (find-file f)))

(defun cust/split-open (f)
  (let ((evil-vsplit-window-right t))
    (+evil/window-split-and-follow)
    (find-file f)))

(defun my-vterm/split-right ()
  "Create a new vterm window to the right of the current one."
  (interactive)
  (let* ((ignore-window-parameters t)
         (dedicated-p (window-dedicated-p)))
    (split-window-horizontally)
    (other-window 1)
    (+vterm/here default-directory)))


(map! :after embark
      :map embark-file-map
      "O" #'cust/vsplit-open
      "V" #'cust/split-open)

(map! :leader
      :prefix ("o")
      "v" #'my-vterm/split-right)


;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)


;; set treemacs settings
;; (setq doom-themes-treemacs-theme "doom-colors")
(setq treemacs-git-mode 'extended)

;; disable popup ui docs
(setq lsp-ui-doc-enable 'nil)

;; set rust-analyzer as default
(setq rustic-lsp-server 'rust-analyzer)
(after! rustic
  (setq lsp-rust-server 'rust-analyzer))

;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(add-to-list 'default-frame-alist '(inhibit-double-buffering . t))

;; C++ clangd setup

(setq lsp-clangd-binary-path "/usr/bin/clangd")
(setq lsp-clients-clangd-args '("-j=8"
                                "--background-index"
                                "--clang-tidy"
                                "--query-driver=clang-19"
                                "--completion-style=detailed"
                                "--log=verbose"
                                "--header-insertion=never"
                                "--header-insertion-decorators=0"))
(after! lsp-clangd (set-lsp-priority! 'clangd 2))

;; (setq! lsp-enable-on-type-formatting nil)
;; (setq! format-all-mode :false)

;; C++ CCLS setup
;; (after! ccls
;;   (setq ccls-initialization-options '(:index (:comments 2) :completion (:detailedLabel t)))
;;   (set-lsp-priority! 'ccls 2)) ; optional as ccls is the default in Doom

;; CMake goodies
(use-package! cmake-mode
  :mode ("CMakeLists\\.txt\\'" "\\.cmake\\'")
  :hook (cmake-mode . lsp-deferred))

;; (setq debug-on-error t)

(after! dap-mode
  (setq dap-python-debugger 'debugpy))


(use-package! dap-mode
  :defer
  :custom
  (dap-auto-configure-mode t                           "Automatically configure dap.")
  (dap-auto-configure-features
   '(sessions locals breakpoints expressions tooltip)  "Remove the button panel in the top.")
                                        ; :hook (dap-stopped . (lambda (arg) (call-interactively #dap-hydra)))
  :config
  ;;; dap for c++
  (require 'dap-cpptools)

  ;;; set the debugger executable (c++)
  (setq dap-lldb-debug-program '("/opt/homebrew/opt/llvm/bin/lldb-vscode"))

  ;;; ask user for executable to debug if not specified explicitly (c++)
  (setq dap-lldb-debugged-program-function (lambda () (read-file-name "Select file to debug.")))

;;; default debug template for (c++)
  (dap-register-debug-template
   "C++ LLDB default dap"
   (list :type "lldb-vscode"
         :cwd nil
         :args nil
         :request "launch"
         :program nil))

  (defun dap-debug-create-or-edit-json-template ()
    "Edit the C++ debugging configuration or create + edit if none exists yet."
    (interactive)
    (let ((filename (concat (lsp-workspace-root) "/launch.json"))
          (default "~/.emacs.d/default-launch.json"))
      (unless (file-exists-p filename)
        (copy-file default filename))
      (find-file-existing filename))))


;; RG for project search
(map! :map search-map
      :leader
      :prefix ("s" . "search")
      :desc   "ripgrep"  "g" #'consult-ripgrep)


;; Setup debugger
(map! :map dap-mode-map
      :leader
      :prefix ("d" . "dap")
      ;; basics
      :desc "dap next"          "n" #'dap-next
      :desc "dap step in"       "i" #'dap-step-in
      :desc "dap step out"      "o" #'dap-step-out
      :desc "dap continue"      "c" #'dap-continue
      :desc "dap hydra"         "h" #'dap-hydra
      :desc "dap debug restart" "r" #'dap-debug-restart
      :desc "dap debug"         "s" #'dap-debug

      ;; UI
      :prefix("du" . "ui")
      :desc "dap show brkpoint" "b" #'dap-ui-breakpoints
      :desc "dap show sessions" "S" #'dap-ui-sessions
      :desc "dap show locals"   "l" #'dap-ui-locals
      :desc "dap show repl"     "r" #'dap-ui-repl
      :desc "dap show thread"   "t" #'dap-ui-thread-select

      ;; debug
      :prefix ("dd" . "Debug")
      :desc "dap debug recent"  "r" #'dap-debug-recent
      :desc "dap debug last"    "l" #'dap-debug-last
      :desc "dap disconnect"    "q" #'dap-disconnect

      ;; eval
      :prefix ("de" . "Eval")
      :desc "eval"                "e" #'dap-eval
      :desc "eval region"         "r" #'dap-eval-region
      :desc "eval thing at point" "s" #'dap-eval-thing-at-point
      :desc "add expression"      "a" #'dap-ui-expressions-add
      :desc "remove expression"   "d" #'dap-ui-expressions-remove

      :prefix ("db" . "Breakpoint")
      :desc "dap breakpoint toggle"      "b" #'dap-breakpoint-toggle
      :desc "dap breakpoint delete"      "d" #'dap-breakpoint-delete
      :desc "dap breakpoint delete all"  "A" #'dap-breakpoint-delete-all
      :desc "dap breakpoint condition"   "c" #'dap-breakpoint-condition
      :desc "dap breakpoint hit count"   "h" #'dap-breakpoint-hit-condition
      :desc "dap breakpoint log message" "l" #'dap-breakpoint-log-message)



;;(use-package cmake-font-lock
;;  :after (cmake-mode)

;; company completion map
(map! (:when (modulep! :completion company)
        (:map company-active-map "C-l"  #'company-complete-selection)))


(use-package! affe)
(map! :leader
      :prefix ("s" . "search")
      :desc "Fzf file in folder"  "f" (cmd!! #'affe-find)
      :desc "Fzf project grep" "p" (cmd!! #'affe-grep))



;; (use-package cmake-ide
;;   :after projectile
;;   :hook (c++-mode . my/cmake-ide-find-project)
;;   :preface
;;   (defun my/cmake-ide-find-project ()
;;     "Finds the directory of the project for cmake-ide."
;;     (with-eval-after-load 'projectile
;;       (setq cmake-ide-project-dir (projectile-project-root))
;;       (setq cmake-ide-build-dir (concat cmake-ide-project-dir "build")))
;;     (setq cmake-ide-compile-command
;;             (concat "cd " cmake-ide-build-dir " && cmake .. && make"))
;;     (cmake-ide-load-db))
;;
;;   (defun my/switch-to-compilation-window ()
;;     "Switches to the *compilation* buffer after compilation."
;;     (other-window 1))
;;   :bind ([remap comment-region] . cmake-ide-compile)
;;   :init (cmake-ide-setup)
;;   :config (advice-add 'cmake-ide-compile :after #'my/switch-to-compilation-window))

;; golden-ratio
;; (use-package! golden-ratio
;;   :ensure t
;;   :hook (after-init . golden-ratio-mode ))
;;   :custom (golden-ratio-exclude-mode '(occur-mode)))


(setq grip-mdopen-path "/Users/iy/.cargo/bin/mdopen")
(setq grip-use-mdopen :true)

(use-package! spacious-padding
  :ensure t
  :hook ( after-init . spacious-padding-mode )
  )

;; Pyright. STRICT PYTHON FOR MASSES

(setq lsp-pyright-multi-root nil)

(use-package! lsp-pyright
  :hook (python-mode . (lambda ()(require 'lsp-pyright)(lsp))))  ; or lsp-deferred

(after! lsp-pyright
  (setq lsp-pyright-langserver-command "basedpyright")
  (setq! lsp-pyright-typechecking-mode "strict"
         lsp-enable-file-watchers nil)
  )



(require 'ruff-format)
(add-hook 'python-mode-hook 'ruff-format-on-save-mode)
(setq lsp-ruff-advertize-organize-imports nil)

(after! apheleia
  (setf (alist-get 'python-mode apheleia-mode-alist)
        '(ruff-isort ruff))
  (setf (alist-get 'python-ts-mode apheleia-mode-alist)
        '(ruff-isort ruff))
  )
;; Override default balck formatter
(setq-hook! 'python-mode-hook +format-with 'ruff)

;; (setenv "PATH" (concat (getenv "PATH") ":/Users/iy/.ghcup/bin/haskell-language-server-9.2.8"))
;; (setq exec-path (append exec-path '("/Users/iy/.ghcup/bin/haskell-language-server-9.2.8")))
;; /Users/iy/.ghcup/bin/haskell-language-server-9.2.8

;; Org madness
(setq org-hide-emphasis-markers t)

;; increase max # of lines for errmsg
(after! lsp-ui
  (setq lsp-ui-sideline-diagnostic-max-lines 2))

;; `-` char replace for lists
(font-lock-add-keywords 'org-mode
                        '(("^ *\\([-]\\) "
                           (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))


(defcustom mac-animation-dur 0.2 "Duration for animation transitions")

(defvar mac-animation-locked-p nil)
(defun mac-animation-toggle-lock ()
  (setq mac-animation-locked-p (not mac-animation-locked-p)))

(defun animate-frame-fade-out (&rest args)
  (unless mac-animation-locked-p
    (mac-animation-toggle-lock)
    (mac-start-animation nil :type 'fade-out :duration mac-animation-dur)
    (run-with-timer mac-animation-dur nil 'mac-animation-toggle-lock)))

(advice-add 'set-window-buffer :before 'animate-frame-fade-out)
(advice-add 'split-window :before 'animate-frame-fade-out)
(advice-add 'delete-window :before 'animate-frame-fade-out)
(advice-add 'delete-other-windows :before 'animate-frame-fade-out)
(advice-add 'window-toggle-side-windows :before 'animate-frame-fade-out)
