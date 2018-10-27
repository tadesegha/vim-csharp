let maplocalleader = ","

setlocal completeopt=longest,menuone
setlocal makeprg=msbuild\ /nologo\ /v:q\ /property:GenerateFullPaths=true
setlocal errorformat=\ %#%f(%l\\\,%c):\ %m

setlocal shiftwidth=4
setlocal tabstop=4

command! -nargs=1 Rename :call OmniSharp#RenameTo("<args>")

inoremap <buffer> <C-\> <C-o>:OmniSharpSignatureHelp<CR>

nnoremap <buffer> <C-\> :OmniSharpSignatureHelp<CR>
nnoremap <buffer> <C-j> :OmniSharpNavigateDown<CR>
nnoremap <buffer> <C-k> :OmniSharpNavigateUp<CR>
nnoremap <buffer> <LocalLeader>af :call csharp#addFileToCsproj()<cr>
nnoremap <buffer> <LocalLeader>ca :OmniSharpGetCodeActions<CR>
nnoremap <buffer> <LocalLeader>cf :OmniSharpCodeFormat<CR>
nnoremap <buffer> <LocalLeader>dc :OmniSharpDocumentation<CR>
nnoremap <buffer> <LocalLeader>fi :call setqflist([]) \| OmniSharpFindImplementations<CR>
nnoremap <buffer> <LocalLeader>fm :OmniSharpFindMembers<CR>
nnoremap <buffer> <LocalLeader>fs :OmniSharpFindSymbol<CR>
nnoremap <buffer> <LocalLeader>fu :call setqflist([]) \| OmniSharpFindUsages<CR>
nnoremap <buffer> <LocalLeader>fx :OmniSharpFixUsings<CR>
nnoremap <buffer> <LocalLeader>gd :OmniSharpGotoDefinition<CR>
nnoremap <buffer> <LocalLeader>mv :call csharp#moveFile()<cr>
nnoremap <buffer> <LocalLeader>rat :call csharp#nunitTests()<cr>
nnoremap <buffer> <LocalLeader>rn :update \| OmniSharpRename<CR>
nnoremap <buffer> <LocalLeader>rt :call csharp#nunitTest()<cr>
nnoremap <buffer> <LocalLeader>sp :OmniSharpStopServer<CR>
nnoremap <buffer> <LocalLeader>ss :OmniSharpStartServer<CR>
nnoremap <buffer> <LocalLeader>th :OmniSharpHighlightTypes<CR>
nnoremap <buffer> <LocalLeader>tt :OmniSharpTypeLookup<CR>
xnoremap <buffer> <LocalLeader>ca :call OmniSharp#GetCodeActions('visual')<CR>
