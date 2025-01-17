" Vim indent file
" Language:   Svelte 3 (HTML/JavaScript)
" Author:     Evan Lecklider <evan@lecklider.com>
" Maintainer: Evan Lecklide <evan@lecklider.com>
" URL:        https://github.com/evanleck/vim-svelte

if exists("b:did_indent")
  finish
endif

runtime! indent/html.vim
unlet! b:did_indent

let s:html_indent = &l:indentexpr
let b:did_indent = 1

setlocal indentexpr=GetSvelteIndent()
setlocal indentkeys=o,O,*<Return>,<>>,{,},0),0],!^F,;,=:else,=:then,=:catch,=/if,=/each,=/await

" Only define the function once.
if exists('*GetSvelteIndent')
  finish
endif

function! GetSvelteIndent()
  let current_line_number = v:lnum

  if current_line_number == 0
    return 0
  endif

  let current_line = getline(current_line_number)

  " Opening script and style tags should be all the way outdented.
  if current_line =~ '^\s*<\(script\|style\)'
    return 0
  endif

  let previous_line_number = prevnonblank(current_line_number - 1)
  let previous_line = getline(previous_line_number)
  let previous_line_indent = indent(previous_line_number)

  " The inside of scripts an styles should be indented.
  if previous_line =~ '^<\(script\|style\)'
    return shiftwidth()
  endif

  execute "let indent = " . s:html_indent

  " For some reason, the HTML CSS indentation keeps indenting the next line over
  " and over after each style declaration.
  if searchpair('<style>', '', '</style>', 'bW') && previous_line =~ ';$'
    return previous_line_indent
  endif

  " "#if" or "#each"
  if previous_line =~ '^\s*{\s*#\(if\|each\|await\)'
    return previous_line_indent + shiftwidth()
  endif

  " ":else" or ":then"
  if previous_line =~ '^\s*{\s*:\(else\|catch\|then\)'
    return previous_line_indent + shiftwidth()
  endif

  if synID(previous_line_number, match(previous_line, '\S') + 1, 0) == hlID('htmlTag')
    " Previous line looks like an HTML element, the current line hasn't been
    " indented, and the previous line is the start of a capitalized HTML element
    " or one with a colon in it e.g. "svelte:head".
    if indent == previous_line_indent && previous_line =~ '<\(\u\|\l\+:\l\+\)' && previous_line !~ '/>$'
      return previous_line_indent + shiftwidth()

    " Previous line looks like an HTML element, the current line _has_ been
    " indented, _and_ the previous line is a closing tag.
    "
    " This is necessary because the HTML indentation kinda goofs up with
    " self-closing custom or non-standard tags.
    elseif indent != previous_line_indent && previous_line =~ '/>$'
      return previous_line_indent
    endif
  endif

  " "/await" or ":catch" or ":then"
  if current_line =~ '^\s*{\s*\/await' || current_line =~ '^\s*{\s*:\(catch\|then\)'
    let await_start = searchpair('{\s*#await\>', '', '{\s*\/await\>', 'bW')

    if await_start
      return indent(await_start)
    endif
  endif

  " "/each"
  if current_line =~ '^\s*{\s*\/each'
    let each_start = searchpair('{\s*#each\>', '', '{\s*\/each\>', 'bW')

    if each_start
      return indent(each_start)
    endif
  endif

  " "/if"
  if current_line =~ '^\s*{\s*\/if'
    let if_start = searchpair('{\s*#if\>', '', '{\s*\/if\>', 'bW')

    if if_start
      return indent(if_start)
    endif
  endif

  " ":else" is tricky because it can match an opening "#each" _or_ an opening
  " "#if", so we try to be smart and look for the closest of the two.
  if current_line =~ '^\s*{\s*:else'
    let if_start = searchpair('{\s*#if\>', '', '{\s*\/if\>', 'bW')

    " If it's an "else if" then we know to look for an "#if"
    if current_line =~ '^\s*{\s*:else if' && if_start
      return indent(if_start)
    else
      " The greater line number will be closer to the cursor position because
      " we're searching backward.
      return indent(max([if_start, searchpair('{\s*#each\>', '', '{\s*\/each\>', 'bW')]))
    endif
  endif

  return indent
endfunction
