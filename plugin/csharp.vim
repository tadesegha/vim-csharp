augroup cs
  autocmd!
  autocmd Filetype cs setlocal completeopt=longest,menuone
  autocmd Filetype cs setlocal makeprg=msbuild\ /nologo\ /v:q\ /property:GenerateFullPaths=true
  autocmd Filetype cs setlocal errorformat=\ %#%f(%l\\\,%c):\ %m

  autocmd Filetype cs packadd omnisharp-vim
  autocmd Filetype cs packadd ale
  autocmd Filetype cs packadd ultisnips

  autocmd Filetype cs setlocal shiftwidth=4
  autocmd Filetype cs setlocal tabstop=4

  autocmd FileType cs nnoremap <buffer> <Leader>rat :call csharp#nunit-tests()<cr>
  autocmd FileType cs nnoremap <buffer> <Leader>rt :call csharp#nunit-test()<cr>

  " The following commands are contextual, based on the cursor position.
  autocmd FileType cs nnoremap <buffer> gd :OmniSharpGotoDefinition<CR>
  autocmd FileType cs nnoremap <buffer> <Leader>fi :call setqflist([]) \| OmniSharpFindImplementations<CR>
  autocmd FileType cs nnoremap <buffer> <Leader>fs :OmniSharpFindSymbol<CR>
  autocmd FileType cs nnoremap <buffer> <Leader>fu :call setqflist([]) \| OmniSharpFindUsages<CR>

  " Finds members in the current buffer
  autocmd FileType cs nnoremap <buffer> <Leader>fm :OmniSharpFindMembers<CR>

  autocmd FileType cs nnoremap <buffer> <Leader>fx :OmniSharpFixUsings<CR>
  autocmd FileType cs nnoremap <buffer> <Leader>tt :OmniSharpTypeLookup<CR>
  autocmd FileType cs nnoremap <buffer> <Leader>dc :OmniSharpDocumentation<CR>
  autocmd FileType cs nnoremap <buffer> <C-\> :OmniSharpSignatureHelp<CR>
  autocmd FileType cs inoremap <buffer> <C-\> <C-o>:OmniSharpSignatureHelp<CR>

  " Navigate up and down by method/property/field
  autocmd FileType cs nnoremap <buffer> <C-k> :OmniSharpNavigateUp<CR>
  autocmd FileType cs nnoremap <buffer> <C-j> :OmniSharpNavigateDown<CR>

  " Contextual code actions (uses fzf, CtrlP or unite.vim when available)
  autocmd FileType cs nnoremap <buffer> <Leader>ca :OmniSharpGetCodeActions<CR>
  " Run code actions with text selected in visual mode to extract method
  autocmd FileType cs xnoremap <buffer> <Leader>ca :call OmniSharp#GetCodeActions('visual')<CR>

  " Rename with dialog
  autocmd FileType cs nnoremap <buffer> <Leader>rn :update \| OmniSharpRename<CR>
  " Rename without dialog - with cursor on the symbol to rename: `:Rename newname`
  autocmd FileType cs command! -nargs=1 Rename :call OmniSharp#RenameTo("<args>")

  autocmd FileType cs nnoremap <buffer> <Leader>cf :OmniSharpCodeFormat<CR>

  " Start the omnisharp server for the current solution
  autocmd FileType cs nnoremap <buffer> <Leader>ss :OmniSharpStartServer<CR>
  autocmd FileType cs nnoremap <buffer> <Leader>sp :OmniSharpStopServer<CR>

  " Add syntax highlighting for types and interfaces
  autocmd FileType cs nnoremap <buffer> <Leader>th :OmniSharpHighlightTypes<CR>
augroup END
