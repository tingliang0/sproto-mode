# sproto-mode
Emacs major mode for sproto protocol

# support
* syntax highlight
* code indent

# how to use
Copy the `sproto-mode.el` to some directory on your computer. I put mine under `~/.emacs.d/site-lisp/`,
then add the following lines to any of your initialization files:
```
(add-to-list 'load-path "~/.emacs.d/site-lisp/")
(require 'sproto-mode)
```