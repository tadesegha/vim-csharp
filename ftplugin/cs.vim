setlocal completeopt=longest,menuone
setlocal makeprg=msbuild\ /nologo\ /v:q\ /property:GenerateFullPaths=true
setlocal errorformat=\ %#%f(%l\\\,%c):\ %m

setlocal shiftwidth=4
setlocal tabstop=4

nnoremap <buffer> <Leader>rat :call csharp#nunitTests()<cr>
nnoremap <buffer> <Leader>rt :call csharp#nunitTest()<cr>

" The following commands are contextual, based on the cursor position.
nnoremap <buffer> gd :OmniSharpGotoDefinition<CR>
nnoremap <buffer> <Leader>fi :call setqflist([]) \| OmniSharpFindImplementations<CR>
nnoremap <buffer> <Leader>fs :OmniSharpFindSymbol<CR>
nnoremap <buffer> <Leader>fu :call setqflist([]) \| OmniSharpFindUsages<CR>

" Finds members in the current buffer
nnoremap <buffer> <Leader>fm :OmniSharpFindMembers<CR>

nnoremap <buffer> <Leader>fx :OmniSharpFixUsings<CR>
nnoremap <buffer> <Leader>tt :OmniSharpTypeLookup<CR>
nnoremap <buffer> <Leader>dc :OmniSharpDocumentation<CR>
nnoremap <buffer> <C-\> :OmniSharpSignatureHelp<CR>
inoremap <buffer> <C-\> <C-o>:OmniSharpSignatureHelp<CR>

" Navigate up and down by method/property/field
nnoremap <buffer> <C-k> :OmniSharpNavigateUp<CR>
nnoremap <buffer> <C-j> :OmniSharpNavigateDown<CR>

" Contextual code actions (uses fzf, CtrlP or unite.vim when available)
nnoremap <buffer> <Leader>ca :OmniSharpGetCodeActions<CR>
" Run code actions with text selected in visual mode to extract method
xnoremap <buffer> <Leader>ca :call OmniSharp#GetCodeActions('visual')<CR>

" Rename with dialog
nnoremap <buffer> <Leader>rn :update \| OmniSharpRename<CR>
" Rename without dialog - with cursor on the symbol to rename: `:Rename newname`
command! -nargs=1 Rename :call OmniSharp#RenameTo("<args>")

nnoremap <buffer> <Leader>cf :OmniSharpCodeFormat<CR>

" Start the omnisharp server for the current solution
nnoremap <buffer> <Leader>ss :OmniSharpStartServer<CR>
nnoremap <buffer> <Leader>sp :OmniSharpStopServer<CR>

" Add syntax highlighting for types and interfaces
nnoremap <buffer> <Leader>th :OmniSharpHighlightTypes<CR>
