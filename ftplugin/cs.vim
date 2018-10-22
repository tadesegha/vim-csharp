let maplocalleader = ","

setlocal completeopt=longest,menuone
setlocal makeprg=msbuild\ /nologo\ /v:q\ /property:GenerateFullPaths=true
setlocal errorformat=\ %#%f(%l\\\,%c):\ %m

setlocal shiftwidth=4
setlocal tabstop=4

nnoremap <buffer> <LocalLeader>rat :call csharp#nunitTests()<cr>
nnoremap <buffer> <LocalLeader>rt :call csharp#nunitTest()<cr>

" The following commands are contextual, based on the cursor position.
nnoremap <buffer> <LocalLeader>gd :OmniSharpGotoDefinition<CR>
nnoremap <buffer> <LocalLeader>fi :call setqflist([]) \| OmniSharpFindImplementations<CR>
nnoremap <buffer> <LocalLeader>fs :OmniSharpFindSymbol<CR>
nnoremap <buffer> <LocalLeader>fu :call setqflist([]) \| OmniSharpFindUsages<CR>

" Finds members in the current buffer
nnoremap <buffer> <LocalLeader>fm :OmniSharpFindMembers<CR>

nnoremap <buffer> <LocalLeader>fx :OmniSharpFixUsings<CR>
nnoremap <buffer> <LocalLeader>tt :OmniSharpTypeLookup<CR>
nnoremap <buffer> <LocalLeader>dc :OmniSharpDocumentation<CR>
nnoremap <buffer> <C-\> :OmniSharpSignatureHelp<CR>
inoremap <buffer> <C-\> <C-o>:OmniSharpSignatureHelp<CR>

" Navigate up and down by method/property/field
nnoremap <buffer> <C-k> :OmniSharpNavigateUp<CR>
nnoremap <buffer> <C-j> :OmniSharpNavigateDown<CR>

" Contextual code actions (uses fzf, CtrlP or unite.vim when available)
nnoremap <buffer> <LocalLeader>ca :OmniSharpGetCodeActions<CR>
" Run code actions with text selected in visual mode to extract method
xnoremap <buffer> <LocalLeader>ca :call OmniSharp#GetCodeActions('visual')<CR>

" Rename with dialog
nnoremap <buffer> <LocalLeader>rn :update \| OmniSharpRename<CR>
" Rename without dialog - with cursor on the symbol to rename: `:Rename newname`
command! -nargs=1 Rename :call OmniSharp#RenameTo("<args>")

nnoremap <buffer> <LocalLeader>cf :OmniSharpCodeFormat<CR>

" Start the omnisharp server for the current solution
nnoremap <buffer> <LocalLeader>ss :OmniSharpStartServer<CR>
nnoremap <buffer> <LocalLeader>sp :OmniSharpStopServer<CR>

" Add syntax highlighting for types and interfaces
nnoremap <buffer> <LocalLeader>th :OmniSharpHighlightTypes<CR>

nnoremap <buffer> <LocalLeader>mv :call csharp#moveFile()<cr>
