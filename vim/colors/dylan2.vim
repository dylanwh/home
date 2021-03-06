" Vim color file
" Maintainer:   Dylan Hardison <dylanwh@gmail.com>
" Last Change:  2012-01-28.

" Load the syntax highlighting defaults, if it's enabled.
if exists("syntax_on")
    syntax reset
endif

let colors_name = "dylan2"
set bg=dark

hi StatusLine   cterm=none ctermbg=4 ctermfg=white
hi StatusLineNC cterm=none ctermbg=4 ctermfg=white
hi TabLine      ctermbg=4 ctermfg=7 cterm=none
hi TabLineFill  ctermbg=4 cterm=none
hi VertSplit    term=none cterm=none ctermbg=4
hi Directory    cterm=none ctermfg=4
hi Normal       cterm=none ctermfg=7
hi Statement    cterm=none ctermfg=3

hi Constant   cterm=none ctermfg=1
hi Title      ctermfg=3 cterm=none
hi Identifier cterm=none ctermfg=6
hi Type       cterm=none ctermfg=2
hi Special    cterm=none ctermfg=5

if &t_Co > 8
    hi Folded       cterm=none ctermbg=8 ctermfg=14
    hi LineNr       cterm=none ctermbg=8 ctermfg=14
    hi Comment      cterm=none ctermfg=14
else
    hi Folded       cterm=underline,bold ctermbg=0 ctermfg=6
    hi LineNr       cterm=underline,bold ctermbg=0 ctermfg=6
    hi Comment      cterm=bold ctermfg=6
endif

if 0
    "hi Operator ctermfg=45
    hi Identifier cterm=none ctermfg=23
    hi Title      cterm=none ctermfg=34
    hi Comment    cterm=none ctermfg=81
    hi LineNr     ctermfg=73 ctermbg=80
    hi Folded     cterm=none ctermfg=73 ctermbg=80
endif

hi clear PreProc
hi link PreProc Special

hi SpecialKey ctermfg=white ctermbg=5 cterm=none
