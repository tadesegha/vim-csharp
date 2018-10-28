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

function! s:findCsproj(absolutePath)
  let components = split(a:absolutePath, '\')

  let parent = components[0]
  for component in components[1: ]
    let parent = parent . '\' . component
    let csproj = expand(parent . "\\*.csproj")
    if (filereadable(csproj))
      return csproj
    endif
  endfor

  throw "csproj not found"
endfunction

function! csharp#readCsproj(csproj)
  if (!filereadable(a:csproj))
    throw "csproj not found in path hierarchy"
  endif

  return readfile(a:csproj)
endfunction

function! csharp#writeCsproj(content, csproj)
  if (!filewritable(a:csproj))
    throw "csproj found but it can't be edited"
  endif

  call writefile(a:content, a:csproj)
endfunction

function! csharp#newItem()
  let csproj = s:findCsproj(expand('%:p'))
  let csprojDir = fnamemodify(csproj, ':p:h') . '\'

  let opt = { 'prompt': 'path: ', 'completion': 'file', 'default': csprojDir }
  let path = input(opt)

  call s:addToCsproj(path, csproj)
  execute 'edit ' . path
  write
endfunction

function! s:addToCsproj(path, ...)
  let csproj = a:0 ? a:1 : s:findCsproj(a:path)
  let csprojDir = fnamemodify(csproj, ':p:h') . '\'
  let relativePath = s:relativePath(a:path, csprojDir)

  let insertion = '    <Compile Include="' . relativePath . '" />'
  let insertionPattern = trim(s:toSearchPattern(insertion))
  let content = csharp#readCsproj(csproj)
  if s:findInList(content, insertionPattern) != -1
    throw 'csproj already contains file'
  endif

  let insertionIndex = s:findInList(content, '<Compile Include=".*" />')
  if insertionIndex == -1
    throw "could not find a line in csproj matching '<Compile Include=\".*\" />'. unable to determine where to add new file in csproj."
  endif

  call insert(content, insertion, insertionIndex)
  call csharp#writeCsproj(content, csproj)
endfunction

function! csharp#deleteItem()
  let csproj = s:findCsproj(expand('%:p'))
  let csprojDir = fnamemodify(csproj, ':p:h') . '\'
  let relativePath = s:relativePath(expand('%:p'), csprojDir)

  let content = csharp#readCsproj(csproj)
  let removalPattern = s:toSearchPattern('<Compile Include="' . relativePath . '"')
  let removalIndex = s:findInList(content, removalPattern)

  if removalIndex == -1
    throw 'did not find current file in csproj'
  endif

  call remove(content, removalIndex)
  call csharp#writeCsproj(content, csproj)
endfunction

function! csharp#moveItem()
  call csharp#deleteItem()
  call csharp#newItem()
endfunction

function! s:relativePath(absolutePath, directory)
  let pattern = substitute(a:directory, '\\', '\\\\', 'g')
  return substitute(a:absolutePath, pattern, "", "")
endfunction

function! s:toSearchPattern(str)
  return substitute(a:str, '\\', '\\\\', 'g')
endfunction

function! s:findInList(list, pattern)
  let index = 0

  for item in a:list
    if match(item, a:pattern) == -1
      let index = index + 1
      continue
    endif

    return index
  endfor

  return -1
endfunction
