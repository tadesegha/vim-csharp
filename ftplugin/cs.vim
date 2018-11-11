let maplocalleader = ","

setlocal completeopt=longest,menuone
setlocal makeprg=msbuild\ /nologo\ /v:q\ /property:GenerateFullPaths=true
setlocal errorformat=\ %#%f(%l\\\,%c):\ %m

setlocal shiftwidth=4
setlocal tabstop=4

" Custom mappings
nnoremap <buffer> <LocalLeader>ni :call csharp#newItem()<cr>
nnoremap <buffer> <LocalLeader>mi :call csharp#moveItem()<cr>
nnoremap <buffer> <LocalLeader>di :call csharp#deleteItem()<cr>
nnoremap <buffer> <LocalLeader>b :call csharp#build()<cr>
nnoremap <buffer> <LocalLeader>e :call csharp#openFile()<cr>
nnoremap <buffer> <LocalLeader>ga :call csharp#goToAlternate()<cr>

nnoremap <buffer> <LocalLeader>rat :w \| call csharp#nunitTests()<cr>
nnoremap <buffer> <LocalLeader>rt :w \| call csharp#nunitTest()<cr>

" OmniSharp commands
command! -nargs=1 Rename :call OmniSharp#RenameTo("<args>")

" OmniSharp mappings
inoremap <buffer> <C-\> <C-o>:OmniSharpSignatureHelp<CR>
nnoremap <buffer> <C-\> :OmniSharpSignatureHelp<CR>
nnoremap <buffer> <C-j> :OmniSharpNavigateDown<CR>
nnoremap <buffer> <C-k> :OmniSharpNavigateUp<CR>
nnoremap <buffer> <LocalLeader>ca :OmniSharpGetCodeActions<CR>
nnoremap <buffer> <LocalLeader>cf :OmniSharpCodeFormat<CR>
nnoremap <buffer> <LocalLeader>dc :OmniSharpDocumentation<CR>
nnoremap <buffer> <LocalLeader>fi :call setqflist([]) \| OmniSharpFindImplementations<CR>
nnoremap <buffer> <LocalLeader>fm :OmniSharpFindMembers<CR>
nnoremap <buffer> <LocalLeader>fs :OmniSharpFindSymbol<CR>
nnoremap <buffer> <LocalLeader>fu :call setqflist([]) \| OmniSharpFindUsages<CR>
nnoremap <buffer> <LocalLeader>fx :OmniSharpFixUsings<CR>
nnoremap <buffer> <LocalLeader>gd :OmniSharpGotoDefinition<CR>
nnoremap <buffer> <LocalLeader>rn :update \| OmniSharpRename<CR>
nnoremap <buffer> <LocalLeader>ri :update \| OmniSharpRename<CR>
nnoremap <buffer> <LocalLeader>sp :OmniSharpStopServer<CR>
nnoremap <buffer> <LocalLeader>ss :OmniSharpStartServer<CR>
nnoremap <buffer> <LocalLeader>th :OmniSharpHighlightTypes<CR>
nnoremap <buffer> <LocalLeader>tt :OmniSharpTypeLookup<CR>
xnoremap <buffer> <LocalLeader>ca :call OmniSharp#GetCodeActions('visual')<CR>
