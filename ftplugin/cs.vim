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
nnoremap <buffer> <LocalLeader>vsga :call csharp#goToAlternate()<cr><c-w>o:vs #<cr><c-w>p

nnoremap <buffer> <LocalLeader>rt :update \| call csharp#nunitTest(v:false)<cr>
nnoremap <buffer> <LocalLeader>rft :update \| call csharp#nunitTest(v:true)<cr>
nnoremap <buffer> <LocalLeader>rat :update \| call csharp#nunitTests()<cr>

" OmniSharp commands
command! -nargs=1 Rename :call OmniSharp#RenameTo("<args>")

" OmniSharp mappings
nnoremap <buffer> <LocalLeader>sh :OmniSharpSignatureHelp<cr>
nnoremap <buffer> <LocalLeader>j :OmniSharpNavigateDown<cr>
nnoremap <buffer> <LocalLeader>k :OmniSharpNavigateUp<cr>
nnoremap <buffer> <LocalLeader>ca :OmniSharpGetCodeActions<cr>
nnoremap <buffer> <LocalLeader>cf :OmniSharpCodeFormat<cr>
nnoremap <buffer> <LocalLeader>dc :OmniSharpDocumentation<cr>
nnoremap <buffer> <LocalLeader>fi :OmniSharpFindImplementations<cr>
nnoremap <buffer> <LocalLeader>fm :OmniSharpFindMembers<cr>
nnoremap <buffer> <LocalLeader>fs :OmniSharpFindSymbol<cr>
nnoremap <buffer> <LocalLeader>fu :OmniSharpFindUsages<cr>
nnoremap <buffer> <LocalLeader>fx :OmniSharpFixUsings<cr>
nnoremap <buffer> <LocalLeader>gd :OmniSharpGotoDefinition<cr>
nnoremap <buffer> <LocalLeader>sp :OmniSharpStopServer<cr>
nnoremap <buffer> <LocalLeader>ss :OmniSharpStartServer<cr>
nnoremap <buffer> <LocalLeader>th :OmniSharpHighlightTypes<cr>
nnoremap <buffer> <LocalLeader>tl :OmniSharpTypeLookup<cr>
nnoremap <buffer> <LocalLeader>rn :update \| OmniSharpRename<cr>
nnoremap <buffer> <LocalLeader>ri :update \| OmniSharpRename<cr>

xnoremap <buffer> <LocalLeader>ca :call OmniSharp#GetCodeActions('visual')<cr>

" Ale mappings
nnoremap <buffer> <LocalLeader><LocalLeader> :ALENextWrap<cr>
