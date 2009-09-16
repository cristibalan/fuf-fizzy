"=============================================================================
" Copyright (c) 2007-2009 Cristi Balan
"
" This file based on fuf/file.vim.
" 
" The only changes are the onInit and onComplete functions and the removal of 
" s:enumItems.
"
" Put this file in autoload/ and make sure your .vimrc g:fuf_modes mentions fizzy.
" let g:fuf_modes = ['fizzy', 'file', 'dir']
"
"=============================================================================
" LOAD GUARD {{{1

if exists('g:loaded_autoload_fuf_fizzy') || v:version < 702
  finish
endif
let g:loaded_autoload_fuf_fizzy = 1

" }}}1
"=============================================================================
" GLOBAL FUNCTIONS {{{1

"
function fuf#fizzy#createHandler(base)
  return a:base.concretize(copy(s:handler))
endfunction

"
function fuf#fizzy#renewCache()
endfunction

"
function fuf#fizzy#requiresOnCommandPre()
  return 0
endfunction

command! FizzyRenewCache ruby refresh_fizzy_finder

"
function fuf#fizzy#onInit()
ruby << RUBY
  begin
    require "#{ENV['HOME']}/.vim/ruby/fizzy"
  rescue LoadError
    begin
      require 'rubygems'
      require 'fizzy'
    rescue LoadError
      begin
        require 'evilchelu-fizzy'
      rescue LoadError
        echo 'Could not load fizzy. Get fizzy from http://github.com/evilchelu/fizzy'
      end
    end
  end

  def fizzy_finder
    @fizzy_finder ||= begin
      cmd = 'find -d . -type f -not -path "*.git*" -not -path "*vendor/*" -not -path "*public/a/*" -not -name .DS_Store -not -name "*.jpg" -not -name "*.png" -not -name "*.gif" | sed -e "s/^\.\///"'
      Fizzy.new(`#{cmd}`.map{|f|f.chomp})
    end
  end

  def refresh_fizzy_finder
    @fizzy_finder = nil
    fizzy_finder
    nil
  end
RUBY
  call fuf#defineLaunchCommand('FufFizzy', s:MODE_NAME, '""')
endfunction

" }}}1
"=============================================================================
" LOCAL FUNCTIONS/VARIABLES {{{1

let s:MODE_NAME = expand('<sfile>:t:r')

" }}}1
"=============================================================================
" s:handler {{{1

let s:handler = {}

"
function s:handler.getModeName()
  return s:MODE_NAME
endfunction

"
function s:handler.getPrompt()
  return g:fuf_file_prompt
endfunction

"
function s:handler.getPromptHighlight()
  return g:fuf_file_promptHighlight
endfunction

"
function s:handler.targetsPath()
  return 1
endfunction

"
function s:handler.onComplete(patternSet)
  let result = []
  ruby << RUBY
    pattern = VIM.evaluate("a:patternSet['raw']")
    res = fizzy_finder.fuf_find(pattern)
    res.each_with_index do |r, index|
      VIM.evaluate("add(result, { 'word': #{r[:word].inspect}, 'abbr': #{r[:abbr].inspect}, 'menu': #{r[:menu].inspect}, 'ranks': [#{index}] })")
    end
RUBY
  return result
endfunction

"
function s:handler.onOpen(expr, mode)
  call fuf#openFile(a:expr, a:mode, g:fuf_reuseWindow)
endfunction

"
function s:handler.onModeEnterPre()
endfunction

"
function s:handler.onModeEnterPost()
  let self.cache = {}
endfunction

"
function s:handler.onModeLeavePost(opened)
endfunction

" }}}1
"=============================================================================
" vim: set fdm=marker:

