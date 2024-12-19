" Disable coc startup warning
let g:coc_disable_startup_warning = 1

" Exit from insertion mode to normal mode by using 'jj'
imap jj <esc>

" Set absolute and relative line numbers
" The first time it is opened, it is set to absolute line number.
" When it changes from insertion mode to normal mode, it switches to relative line number
set nu
augroup relative_numbser
    autocmd!
    autocmd InsertEnter * :set norelativenumber
    autocmd InsertLeave * :set relativenumber
augroup END

" Set font and font size
set guifont=IBM\ Plex\ Mono:h12

" Load my plugins
try
    source ~/.vim_runtime/my_plugins/plug.vim
catch
endtry

" Plugins will be downloaded under the specified directory.
call plug#begin(has('nvim') ? stdpath('data') . '/plugged' : '~/.vim_runtime/my_plugins')

" Declare the list of plugins.
Plug 'ludovicchabant/vim-gutentags'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" List ends here. Plugins become visible to Vim after this call.
call plug#end()

" The flag for searching the project directory in gutentags stops recursion to 
" the higher-level directory when encountering these file/directory names
let g:gutentags_project_root = ['.root', '.svn', '.git', '.project']

" The name of the generated data file
let g:gutentags_ctags_tagfile = '.tags'

" Put all automatically generated tags files into the~/. cache/tags directory 
" to avoid contaminating the project directory
let s:vim_tags = expand('~/.cache/tags')
let g:gutentags_cache_dir = s:vim_tags

if !isdirectory(s:vim_tags)
   silent! call mkdir(s:vim_tags, 'p')
endif

" Configure parameters for ctags
let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extra=+q']
let g:gutentags_ctags_extra_args += ['--c++-kinds=+pxI']
let g:gutentags_ctags_extra_args += ['--c-kinds=+px']

"=================================================================================
"
"   Following file contains the commands on how to run the currently open code.
"   The default mapping is set to F5 like most code editors.
"   Change it as you feel comfortable with, keeping in mind that it does not
"   clash with any other keymapping.
"
"   NOTE: Compilers for different systems may differ. For example, in the case
"   of C and C++, we have assumed it to be gcc and g++ respectively, but it may
"   not be the same. It is suggested to check first if the compilers are installed
"   before running the code, or maybe even switch to a different compiler.
"
"   NOTE: Adding support for more programming languages
"
"   Just add another elseif block before the 'endif' statement in the same
"   way it is done in each case. Take care to add tabbed spaces after each
"   elseif block (similar to python). For example:
"
"   elseif &filetype == '<your_file_extension>'
"       exec '!<your_compiler> %'
"
"   NOTE: The '%' sign indicates the name of the currently open file with extension.
"         The time command displays the time taken for execution. Remove the
"         time command if you dont want the system to display the time
"
"=================================================================================

map <F5> :call CompileRun()<CR>
imap <F5> <Esc>:call CompileRun()<CR>
vmap <F5> <Esc>:call CompileRun()<CR>

func! CompileRun()
    exec "w"
    if &filetype == 'c'
        if has("win16") || has("win32")
            exec "!gcc % -o %<.exe"
            exec "!%<.exe"
        else
            exec "!gcc % -o %<"
            exec "!time ./%<"
        endif
    elseif &filetype == 'cpp'
        if has("win16") || has("win32")
            exec "!g++ % -o %<.exe"
            exec "!%<.exe"
        else
            exec "!g++ % -o %<"
            exec "!time ./%<"
        endif
    elseif &filetype == 'java'
        exec "!javac %"
        exec "!time java %"
    elseif &filetype == 'sh'
        exec "!time bash %"
    elseif &filetype == 'python'
        exec "!time python3 %"
    elseif &filetype == 'html'
        exec "!google-chrome % &"
    elseif &filetype == 'go'
        exec "!go build %<"
        exec "!time go run %"
    elseif &filetype == 'matlab'
        exec "!time octave %"
    endif
endfunc

map <C-F5> :call Debug()<CR>
" Define Debug function to debug programs
func! Debug()
    exec "w"
    " C
    if &filetype == 'c'
        if has("win16") || has("win32")
            exec "!gcc % -o %<.exe"
            exec "!gdb %<.exe"
        else
            exec "!gcc % -o %<"
            exec "!gdb ./%<"
        endif
    elseif &filetype == 'cpp'
        if has("win16") || has("win32")
            exec "!g++ % -g -o %<.exe"
            exec "!gdb %<.exe"
        else
            exec "!g++ % -g -o %<"
            exec "!gdb ./%<"
        endif
    " Java
    elseif &filetype == 'java'
        exec "!javac %"
        exec "!jdb %<"
    endif
endfunc
