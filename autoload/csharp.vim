function! csharp#fqn()
  let save_cursor = getcurpos()

  call search('namespace \zs')
  let namespace = expand('<cWORD>')

  call search('class \zs')
  let class = expand('<cWORD>')

  call setpos('.', save_cursor)
  return namespace . '.' . class
endfunction

function! csharp#nunitTests()
  execute "AsyncTermExecute run-nunit-tests.ps1"
endfunction

function! csharp#nunitTest()
  let fqn = csharp#fqn()
  execute "AsyncTermExecute run-nunit-tests.ps1 " . fqn
endfunction

function! csharp#moveFile()
  let filename = input({ 'prompt': 'enter filename: ',
    \ 'completion': 'file',
    \ 'default': expand('%')
    \ })

  execute 'write ' . filename
  call nvim_buf_set_lines(bufnr('%'), 0, -1, v:true, [])
  write
  call system('rm ' . expand('%'))
  Sayonara!
  execute 'edit ' . filename
endfunction
