call plug#begin()
Plug 'ElmCast/elm-vim'
Plug 'altercation/vim-colors-solarized'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-eunuch'
Plug 'shumphrey/fugitive-gitlab.vim'
Plug 'pangloss/vim-javascript'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'wesQ3/vim-windowswap'
Plug 'mhinz/vim-grepper'
Plug 'yssl/QFEnter'
Plug 'w0rp/ale'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'Konfekt/FastFold'
Plug 'sheerun/vim-polyglot'
Plug 'diepm/vim-rest-console'
Plug 'joshuavial/aider.nvim'
call plug#end()

" Turn off mouse
set mouse=

" use two spaces for indents, and make them actual spaces
set shiftwidth=2
set tabstop=2
set autoindent
set expandtab

set number
syntax enable
set background=light
" colorscheme paramount
colorscheme solarized
set nobackup
filetype indent on
filetype plugin on
set noincsearch

" try out syntax folding by default
let php_folding=2
set foldminlines=5
autocmd Syntax * setlocal foldmethod=syntax
autocmd Syntax * normal zR

" Set <Leader> key
let mapleader=','

" turn on vim-python/python-syntax
let g:python_highlight_all = 1

" reduce length of timeout waiting for rest of command
set timeoutlen=300 " ms

" Keep space around the cursor when scrolling
set scrolloff=8

" To encourage macro usage
nnoremap <Space> @q

" Shortcut for deleting into the null register ("_), to preserve clipboard
" contents
nnoremap -d "_d

" change split opening to bottom and right instead of top and left
set splitbelow
set splitright

" remap windowswap to a ctrl-w command
let g:windowswap_map_keys = 0 "prevent default bindings
nnoremap <silent> <C-W>y :call WindowSwap#EasyWindowSwap()<CR>

" fzf (assumes installed with homebrew)
set rtp+=/usr/local/opt/fzf
nnoremap <C-P> :FZF<CR>
let g:fzf_history_dir = '~/.local/share/fzf-history'
let g:fzf_layout = { 'down': '~30%' }
let $FZF_DEFAULT_COMMAND = 'ag -l --nocolor --hidden --ignore .git -g ""'

" The Silver Searcher
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor
endif

""""""""""""""""""""""""""""""""
" Grepper Configuration

let g:grepper = {}  " initialize g:grepper with empty dictionary

" Use Grepper to search for the word under the cursor using ag (replaces backwards identifier search)
nnoremap # :Grepper -cword -noprompt<CR>

" Use \ as a shortcut for :Grepper
nnoremap \ :Grepper<CR>

nmap gw <plug>(GrepperOperator)
xmap gw <plug>(GrepperOperator)

let g:grepper.tools =
  \ ['ag', 'git', 'ack']

" QFEnter configuration
let g:qfenter_keymap = {}
let g:qfenter_keymap.open = ['<C-CR>']
let g:qfenter_keymap.hopen_keep = ['<C-X>']
let g:qfenter_keymap.vopen_keep = ['<C-V>']
let g:qfenter_keymap.topen_keep = ['<C-T>']

" Escape in normal mode clears search result highlighting
set hlsearch
nnoremap <esc> :noh<return><esc>
nnoremap <esc>^[ <esc>^[

" simple session saving
set ssop-=options    " do not store global and local values in a session
command SS execute "mksession! ~/vim_session"
command LS execute "source ~/vim_session"

" json formatting, given that python is installed
command Json execute "%!python -m json.tool"

" xml formatting, given that tidy is installed
command Xml execute "%! tidy -miq -xml -wrap 0"

" TODO: what does this do?
set laststatus=2

" build a beautiful status line
set statusline=%t "tail of the filename
set statusline+=\ %#IncSearch#%{&modified?'\ MODIFIED\ ':''}%*
set statusline+=\ %#pandocStrikeoutDefinition#%{&modifiable?'':'\ READ\ ONLY\ '}%*

" set statusline+=[%{strlen(&fenc)?&fenc:'none'}, "file encoding
" set statusline+=%{&ff}] "file format
" set statusline+=%h      "help file flag
" set statusline+=%m      "modified flag
" set statusline+=%r      "read only flag
" set statusline+=%y      "filetype
set statusline+=%=      "left/right separator

set statusline+=\ %c,     "cursor column
set statusline+=\ %l/%L   "cursor line/total lines
" set statusline+=\ %P    "percent through file

" build a beautiful tabline
function CustomTabNumber(tab_number, selected, buflist)
  if a:selected
    let default_highlight = '%#TabLineSel#'
    let tab_number_highlight =  '%#TabLineSel#'
    let modified_highlight =  '%#MatchParen#'
  else
    let default_highlight = '%#TabLine#'
    let tab_number_highlight = '%#Folded#' 
    let modified_highlight =  '%#DiffDelete#'
  endif

  let any_buffers_modified = count(map(copy(a:buflist), {index, val -> getbufvar(val, "&mod")}), 1)
  if any_buffers_modified > 0
    let tab_number_string = modified_highlight . a:tab_number . default_highlight
  else
    let tab_number_string = tab_number_highlight . a:tab_number . default_highlight
  endif

  return tab_number_string
endfunction

function TruncatePath(path, width)
  let start_index = strchars(a:path) - a:width
  return strcharpart(a:path, start_index, a:width)
endfunction

function CustomTabLabel(tab_number, selected, allowed_width)
  let buflist = tabpagebuflist(a:tab_number)
  let num_windows = tabpagewinnr(a:tab_number, '$')
  let focused_window = tabpagewinnr(a:tab_number)

  let tab_number_string = CustomTabNumber(a:tab_number, a:selected, buflist)

  let path = pathshorten(bufname(buflist[focused_window - 1]))
  if (strchars(path) == 0)
    let path = '[No Name]'
  endif

  let extra_window_count = ''
  if num_windows > 1
    let extra_window_count .= '+' . (num_windows - 1)
  endif

  let whitespace_width = 4 " 2 for space between elements, 2 for space around
  let consumed_width = strchars(string(a:tab_number)) + strchars(extra_window_count) + whitespace_width 
  let truncated_path = TruncatePath(path, a:allowed_width - consumed_width)

  let elements = [tab_number_string, truncated_path]
  if (strchars(extra_window_count) > 0)
    let elements += [extra_window_count]
  endif

  return ' ' . join(elements, ' ') . ' '
endfunction

function CustomTabLine()
  let s = ''
  let num_tabs = tabpagenr('$')
  let columns_per_tab = &columns/num_tabs " integer division rounds down
  for i in range(num_tabs)
    " select the highlighting
    let is_selected_tab = i + 1 == tabpagenr()
    if is_selected_tab
      let current_highlight = '%#TabLineSel#'
    else
      let current_highlight = '%#TabLine#'
    endif

    let s .= current_highlight

    " set the tab page number (for mouse clicks)
    let s .= '%' . (i + 1) . 'T'

    " the label is made by MyTabLabel()
    let s .= CustomTabLabel(i + 1, is_selected_tab, columns_per_tab)
  endfor

  " after the last tab fill with TabLineFill and reset tab page nr
  let s .= '%#TabLineFill#%T'

  return s
endfunction

set tabline=%!CustomTabLine()

" ale configuration
let g:ale_lint_on_save = 1
let g:ale_lint_on_text_changed = 0
let g:ale_lint_on_insert_leave = 0
let g:ale_lint_on_enter = 0
let g:ale_linters = {
\  'javascript': ['eslint'],
\  'python': ['flake8'],
\}

function! ShandySqlFmtFixer(buffer) abort
    return {
    \   'command': 'sqlfmt -'
    \}
endfunction

execute ale#fix#registry#Add('shandy-sqlfmt', 'ShandySqlFmtFixer', ['sql'], 'sqlfmt fixer in place of standard')

let g:ale_fixers = {
\  'javascript': ['eslint', 'prettier'],
\  'python': ['black'],
\  'sql': ['shandy-sqlfmt'],
\}
let g:ale_javascript_eslint_suppress_eslintignore = 1
if filereadable('./.eslintrc-personal.js')
  let g:ale_javascript_eslint_options = '-c .eslintrc-personal.js'
endif

" enable jsx highlighting in .js files
let g:jsx_ext_required = 0

" cursorline in active window
augroup CursorLine
  au!
  au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  au WinLeave * setlocal nocursorline
augroup END

" cooperate with crontab editing
autocmd filetype crontab setlocal nobackup nowritebackup

" specify gitlab url for fugitive-gitlab
" let g:fugitive_gitlab_domains = ['https://gitlab.teamhologram.ninja']

" function for saving files to a scratchpad
function! SaveAsScratchFile(directory, filename, ...) range
    let l:directory = a:directory
    if len(l:directory) == 0
      let l:directory = '~/Documents/vim-scratch/'
    endif

    let l:filename = a:filename
    if len(l:filename) == 0
      let l:filename = 'scratch'
    endif

    let l:extension = '.' . fnamemodify( l:filename, ':e' )
    if len(l:extension) == 1
        let l:extension = a:0 >= 1 ? a:1 : '.txt'
    endif

    let l:filename = l:directory . strftime("%Y-%m-%d_%H%M_") . escape( fnamemodify(l:filename, ':r') . l:extension, ' ')

    execute "write " . l:filename
endfunction

let g:scratch_directory = '~/Documents/vim-scratch/'
" map scratchpad function to :SS
command! -nargs=? SS call SaveAsScratchFile(g:scratch_directory, <q-args>)

" mappings to open and save a new buffer
command! -nargs=? NS new | call SaveAsScratchFile(g:scratch_directory, <q-args>)
command! -nargs=? VS vnew | call SaveAsScratchFile(g:scratch_directory, <q-args>)

" command to browse scratch files
command! -nargs=0 EOS edit ~/Documents/vim-scratch/
command! -nargs=0 NOS sp ~/Documents/vim-scratch/
command! -nargs=0 VOS vs ~/Documents/vim-scratch/

let g:sql_directory = '/Users/ruperthologram/Documents/Hologram/DBeaver/Projects/Hologram/Scripts/'
" map scratchpad function to :SS
command! -nargs=? SSQL call SaveAsScratchFile(g:sql_directory, <q-args>, '.sql')

" mappings to open and save a new buffer
command! -nargs=? NSQL new | call SaveAsScratchFile(g:sql_directory, <q-args>, '.sql')
command! -nargs=? VSQL vnew | call SaveAsScratchFile(g:sql_directory, <q-args>, '.sql')

" command to browse scratch files
command! -nargs=0 EOSQL edit /Users/ruperthologram/Documents/Hologram/DBeaver/Projects/Hologram/Scripts/
command! -nargs=0 NOSQL sp /Users/ruperthologram/Documents/Hologram/DBeaver/Projects/Hologram/Scripts/
command! -nargs=0 VOSQL vs /Users/ruperthologram/Documents/Hologram/DBeaver/Projects/Hologram/Scripts/

command! Finder silent exe '!open -R ' . expand("%:p")

function! SGPTPrompt()
  let prompt_text = input('Enter prompt text: ')
  let command = 'sgpt --code "' . prompt_text . '"'
  let output = system(command)
  new
  call setline(1, split(output, "\n"))
endfunction

function! SGPTBuffer()
  let prompt_text = input('Enter prompt text: ')
  let command = 'sgpt --code "' . prompt_text . '"'
  let output = system(command, join(getline(1, '$'), "\n"))
  new
  call setline(1, split(output, "\n"))
endfunction

function! SGPTVisual(startline, endline)
  let prompt_text = input('Enter prompt text: ')
  let command = 'sgpt --code "' . prompt_text . '"'
  let visual_selection = join(getline(a:startline, a:endline), "\n")
  let output = system(command, visual_selection)
  new
  call setline(1, split(output, "\n"))
endfunction

command! SGPTPrompt call SGPTPrompt()
command! SGPTBuffer call SGPTBuffer()
command! -range SGPTVisual :call SGPTVisual(<line1>, <line2>)

tnoremap <Esc> <C-\><C-n>

lua << EOF
require('aider').setup({
  auto_manage_context = true,
  default_bindings = false,
  vim.api.nvim_set_keymap('n', '<leader>oa', ':AiderOpen --sonnet --no-auto-commits --no-gitignore<CR>', {noremap = true, silent = true})
})
EOF

