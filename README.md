# vim-svelte

Vim syntax highlighting and indentation for [Svelte 3](https://svelte.dev)
components.

This is mostly just HTML syntax highlighting with some keywords added and all
expressions inside of `{` and `}` highlighted as JavaScript.

Highlighting includes:

- HTML attributes with a colon like `on:click` or `transition:fade` highlighted
    as `Keyword`.
- `#if`, `/if`, `:else`, and `:else if` highlighted as `Conditional`.
- `#await`, `/await`, `:catch`, `:then`, and `@html` highlighted as `Keyword`.
- `#each` and `/each` highlighted as `Repeat`.


## Dependencies

The JavaScript highlighting depends on
[pangloss/vim-javascript](https://github.com/pangloss/vim-javascript). That
ships with [sheerun/vim-polyglot](https://github.com/sheerun/vim-polyglot) so if
you're already using that then you should be set.


## Installation

1. Install [Pathogen](https://github.com/tpope/vim-pathogen),
   [Vundle](https://github.com/VundleVim/Vundle.vim),
   [NeoBundle](https://github.com/Shougo/neobundle.vim), or
   [Plug](https://github.com/junegunn/vim-plug) package manager for Vim.
2. Use this repository as submodule or package.

For example when using [Plug](https://github.com/junegunn/vim-plug):

```
Plug 'evanleck/vim-svelte'
```


## Alternatives

1. [burner/vim-svelte](https://github.com/burner/vim-svelte)


## Todo

1. Write some tests using [Vader](https://github.com/junegunn/vader.vim).
