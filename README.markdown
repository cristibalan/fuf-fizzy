fuf-fizzy
=========

Fuf-fizzy is a mode for [fuzzyfinder.vim](http://www.vim.org/scripts/script.php?script_id=1984).

It needs a vim compiled with ruby support and [fizzy](http://github.com/evilchelu/fizzy).

Installing
----------

First, install fuzzyfinder.vim.

    curl http://github.com/evilchelu/fuf-fizzy/raw/master/fizzy.vim > ~/.vim/autoload/fizzy.vim

Restart vim and use `:FufFizzy` to search for files in the current vim directory (`getcwd()`).

Use `:FizzyRenewCache` to refresh the file list (if you change the directory and want to rebase searches off the new directory, or if you add, remove or rename files).

Usage
-----

    

TODO
----

* keep pimpin

IDEAS
----

* maybe read the file list from .fizzy in the current directory
* [kicker][http://github.com/alloy/kicker] script to refresh the .fizzy file

Note on Patches/Pull Requests
-----------------------------
 
* Fork the project.
* Create a feature branch
* Make your feature addition or bug fix.
* Send me a pull request or add a github issue

Copyright
---------

Copyright (c) 2009 Cristi Balan.

Released under the [WTFPL](http://sam.zoy.org/wtfpl)
