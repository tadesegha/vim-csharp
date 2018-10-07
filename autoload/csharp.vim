function! csharp#fqn()
  let save_cursor = getcurpos()

  call search('namespace \zs')
  let namespace = expand('<cWORD>')

  call search('class \zs')
  let class = expand('<cWORD>')

  call setpos('.', save_cursor)
  return namespace . '.' . class
endfunction

function! csharp#nunit-tests()
  execute "AsyncTermExecute run-nunit-tests.ps1"
endfunction

function! csharp#nunit-test()
  let fqn = csharp#fqn()
  execute "AsyncTermExecute run-nunit-tests.ps1 " . fqn
endfunction
