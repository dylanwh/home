"-- Pretty folding.
setlocal foldtext=PerlFoldTextNoLines()
setlocal textwidth=120
setlocal expandtab
setlocal isfname=@,48-57,/,.,_,+,,,#,$,%,~,=,:

if $HOST == 'mani'
    setlocal expandtab
end

"-- Do not fold package-level things.
if expand("%:e") == 'pm'
    setlocal foldlevel=1
endif

"-- Do not highlight 'new'!
hi link perlStatementNew NONE

"-- toggle displaying numbers at the end.
map <silent> z; :silent call TogglePerlFold()<CR>
map <silent> z/ :silent setlocal foldtext<<CR>
iab mx MooseX

let tlist_perl_settings='perl;u:use;p:package;r:role;e:extends;c:constant;a:attribute;s:subroutine;l:label'
"let Tlist_Show_One_File = 1

"inoremap { { }<C-o>3h
"inoremap [ [ ]<C-o>3h

command! -range=% PerlTidy <line1>,<line2>!perltidy

function! TogglePerlFold()
    if &l:foldtext == "PerlFoldTextNoLines()"
        setlocal foldtext=PerlFoldText()
    else
        setlocal foldtext=PerlFoldTextNoLines()
    endif
endfunction

function! s:Repeat(nr, char)
    let nr = a:nr
    let s = ""
    while nr > 0
        let nr = nr - 1
        let s = s . a:char
    endwhile
    return s
endfunction

function! PerlFoldText()
    let txt = substitute(foldtext(), "{", "", "g")
    let result = substitute(txt, " *\\(\\d\\+ lines\\): \\(.\\+\\)\\s*$", " \\2#=#\\1", "g")
    let spaces = winwidth(0) - strlen(result) + 1
    return substitute(result, "\#=#", s:Repeat(spaces, " "), "g")
endfunction

function! PerlFoldTextNoLines()
    let txt = PerlFoldText()
    return substitute(txt, " \\+\\d\\+ lines$", "", "")
endfunction

function! s:RunShellCommand(cmdline)
    botright lwindow
    lexpr system(escape(a:cmdline,'%#'))
    lopen
    1
endfunction

command! -complete=file -nargs=+ Test call s:RunShellCommand('prove -v '.<q-args> )


