;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; refresh' after modifying this file!


;; These are used for a number of things, particularly for GPG configuration,
;; some email clients, file templates and snippets.
(setq user-full-name "zhong sheng"
      user-mail-address "nily.zhong@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; test
(setq doom-font (font-spec :family "monospace" :size 14)
      doom-variable-pitch-font (font-spec :family "monospace"))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. These are the defaults.
(setq doom-theme 'doom-one)

;; If you intend to use org, it is recommended you change this!
(setq org-directory "~/org/")

(setq yas-snippet-dirs '("~/.doom.d/yasnippets"))
;; If you want to change the style of line numbers, change this to `relative' or
;; `nil' to disable it:
(setq org-default-notes-file "~/Clouds/emacs/GTD/someday.org")
(setq org-agenda-files '("~/Clouds/emacs/GTD/someday.org"
                         "~/Clouds/emacs/GTD/gtd.org"
                         "~/Clouds/emacs/GTD/tickler.org"))
(setq org-capture-templates '(("t" "Todo [inbox]" entry
                               (file+headline "~/Clouds/emacs/GTD/inbox.org" "Tasks")
                               "* TODO %i%?")
                              ("T" "Tickler" entry
                               (file+headline "~/Clouds/emacs/GTD/tickler.org" "Tickler")
                               "* %i%? \n %U")))
(setq org-refile-targets '(("~/Clouds/emacs/GTD/gtd.org" :maxlevel . 3)
                           ("~/Clouds/emacs/GTD/someday.org" :level . 1)
                           ("~/Clouds/emacs/GTD/tickler.org" :maxlevel . 2)))

(setq display-line-numbers-type 'nil)
    (setq org-publish-project-alist
          '(("org-blog"
             ;; Path to your org files.
             :base-directory "~/blog/org/"
             :base-extension "org"

             ;; Path to your Jekyll project.
             :publishing-directory "~/blog/_posts/"
             :recursive t
             :publishing-function org-html-publish-to-html
             :headline-levels 3
             :html-extension "md"
             :body-only t ;; Only export section between <body> </body>
             )

            ("blog"
             :components ("org-blog")
             ;; :publishing-function git-commit
             )))



;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', where Emacs
;;   looks when you load packages with `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c g k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c g d') to jump to their definition and see how
;; they are implemented.

(defun save-and-evil ()
  "save buffer then go to evil mode"
  (interactive)
  (save-buffer)
  (evil-normal-state)
  )

(defun create-blog-file ()
  "Create org file for my blog"
  (interactive)
  (let ((title (read-from-minibuffer "Title: ")))
    (let ((orgfile_name (concat "~/blog/org/"
                                (format-time-string "%Y-%m-%d-")
                                (replace-regexp-in-string " " "-" title)
                                ".org")))
      (shell-command-to-string (concat "touch " orgfile_name))
      (find-file orgfile_name )
      (org-mode)
      (insert "#+TITLE: " title " \n<f")
      (yas-expand)
      )))

(defun publish-my-blog ()
  "publish to github"
  (interactive)
  (org-publish-current-file)
  (shell-command "../publish.sh -f")
  )

(global-set-key (kbd "<f12>") 'org-agenda-list)
(global-set-key (kbd "M-`") 'save-and-evil)
(global-set-key (kbd "C-c o") 'create-blog-file)
(global-set-key (kbd "C-c i") 'publish-my-blog)

(add-to-list 'load-path "~/.doom.d/el/")
(require 'htmlize)
