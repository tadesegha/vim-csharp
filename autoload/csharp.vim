if has('win32') || has('win64')
  let s:pathSeparator = '\'

  function! s:removeFromCsproj(path, ...)
    let csproj = a:0 ? a:1 : s:findCsproj(a:path)
    let csprojDir = fnamemodify(csproj, ':p:h') . s:pathSeparator
    let relativePath = s:relativePath(a:path, csprojDir)

    let content = s:readCsproj(csproj)
    let removalPattern = s:toSearchPattern('<Compile Include="' . relativePath . '"')
    let removalIndex = s:findInList(content, removalPattern)

    if removalIndex == -1
      throw 'did not find current file in csproj'
    endif

    call remove(content, removalIndex)
    call s:writeCsproj(content, csproj)
  endfunction

  function! s:addToCsproj(path)
    let csproj = s:findCsproj(a:path)
    let csprojDir = fnamemodify(csproj, ':p:h') . s:pathSeparator
    let relativePath = s:relativePath(a:path, csprojDir)

    let insertion = '    <Compile Include="' . relativePath . '" />'
    let insertionPattern = trim(s:toSearchPattern(insertion))
    let content = s:readCsproj(csproj)
    if s:findInList(content, insertionPattern) != -1
      throw 'csproj already contains file'
    endif

    let insertionIndex = s:findInList(content, '<Compile Include=".*" />')
    if insertionIndex == -1
      throw "could not find a line in csproj matching '<Compile Include=\".*\" />'. unable to determine where to add new file in csproj."
    endif

    call insert(content, insertion, insertionIndex)
    call s:writeCsproj(content, csproj)
  endfunction
else
  let s:pathSeparator = '/'

  function! s:removeFromCsproj(path, ...)
  endfunction

  function! s:addToCsproj(path)
  endfunction
endif

function! csharp#goToAlternate()
  let path = expand('%')
  if (s:match(path, 'Test'))
    call s:goToCode()
  else
    call s:goToTest()
  endif
endfunction

function! s:goToCode()
  let name = expand('%:t')
  let testPattern = substitute(name, 'Tests\?\.', '.', '')
  let command = "/usr/bin/find . -name " . testPattern . " -type f"
  let result = system('bash -c "' . command . '"')
  if result == ''
    echo 'no code file found'
  else
    execute 'edit ' . system('bash -c "' . command . '"')
  endif
endfunction

function! s:goToTest()
  let name = expand('%:t:r')
  let extension = expand('%:e')
  let testPattern = name . 'Test*.' . extension
  let command = "/usr/bin/find . -name " . testPattern . " -type f -path '*Test*'"
  let result = system('bash -c "' . command . '"')
  if result == ''
    echo 'no code file found'
  else
    execute 'edit ' . system('bash -c "' . command . '"')
  endif
endfunction

function! csharp#openFile()
  let temp = $FZF_DEFAULT_COMMAND

  try
    let indexOfFirstSpace = match(temp, ' ')
    let program = temp[: indexOfFirstSpace]
    let params = temp[indexOfFirstSpace :]
    let $FZF_DEFAULT_COMMAND = program . '--csharp' . params

    FZF
  finally
    let $FZF_DEFAULT_COMMAND = temp
  endtry
endfunction

function! csharp#namespace()
  let path = expand('%:p')
  let csproj = s:findCsproj(path)
  let csprojDir = fnamemodify(csproj, ':p:h')
  let relativePath = s:relativePath(path, csprojDir)

  let suffix = fnamemodify(relativePath, ':h:r')
  let suffix = (suffix == s:pathSeparator) ? '' : substitute(suffix, s:pathSeparator, '.', 'g')
  return fnamemodify(csprojDir, ':t') . suffix
endfunction

function! csharp#fqn()
  let class = expand('%:t:r')
  return csharp#namespace() . '.' . class
endfunction

function! csharp#nunitTests(...)
  let csproj = s:findCsproj(expand('%:p'))
  if !(s:match(csproj, 'Test'))
    throw 'could not find a test csproj file'
  endif

  call csharp#build()

  let csprojDir = fnamemodify(csproj, ':p:h') . s:pathSeparator
  let csprojFilename = fnamemodify(csproj, ':t:r')
  let testAssembly = findfile(csprojFilename . '.dll', csprojDir . "bin/debug/**")

  let command = 'if [[ $? -eq 0 ]] ; then nunit-console.exe ' . s:toBashPath(fnamemodify(testAssembly, ':p'))
  if (a:0)
    let command = command . ' //run=' . a:1
  endif
  let command = command . '; fi'

  call term#executeInTerm('shell', command)
  call term#defaultTerm()
endfunction

function! csharp#nunitTest(runAllInFile)
  let cursorPosition = getcurpos()
  OmniSharpNavigateUp

  let testName = '.' . expand('<cword>')
  if a:runAllInFile || testName == ('.' . expand('%:t:r')) || s:match(testName, '^.using$') || s:match(testName, '^.Setup$')
    let testName = ''
  endif

  call setpos('.', cursorPosition)

  let fqn = csharp#fqn() . testName
  call csharp#nunitTests(fqn)
endfunction

function! csharp#newItem()
  let opt = {
        \'prompt': 'new item: ',
        \'completion': 'file',
        \'default': expand('%:p:h') . s:pathSeparator
        \}
  let path = input(opt)
  if (path == '')
    echo 'new item cancelled'
    return
  endif

  if !s:endsWith(path, '.cs')
    let path = path . '.cs'
  endif

  call s:addToCsproj(path)
  execute 'edit ' . path
  write
endfunction

function! csharp#deleteItem(...)
  let confirmDeletion = a:0 ? a:1 : v:true
  let path = expand('%:p')

  if (confirmDeletion)
    let opt = {
          \'prompt': 'delete item: ',
          \'completion': 'file',
          \'default': path
          \}
    let confirmation = input(opt)
    if (confirmation == '')
      echo 'delete item cancelled'
      return
    endif
  endif

  call s:removeFromCsproj(path)
  " omnisharp needs buffer to be emptied so it cleans up
  execute ':%d'
  call delete(path)
  bd!
endfunction

function! csharp#moveItem()
  let opt = {
        \'prompt': 'move item: ',
        \'completion': 'file',
        \'default': expand('%:p:h') . s:pathSeparator
        \}
  let path = input(opt)
  if (path == '')
    echo 'move item cancelled'
    return
  endif

  if !s:endsWith(path, '.cs')
    let path = path . '.cs'
  endif

  let content = readfile(expand('%'), 'b')
  call writefile(content, path, 'b')

  call csharp#deleteItem(v:false)
  call s:addToCsproj(path)
  execute 'edit ' . path
endfunction

function! csharp#build()
  if (!executable('msbuild.exe'))
    throw 'could not find msbuild.exe'
  endif

  let csproj = s:findCsproj(expand('%:p'))
  call term#executeInTerm('shell', 'msbuild.exe //v:q ' . s:toBashPath(csproj))
  call term#defaultTerm()
endfunction

function! s:findPattern(absolutePath, pattern)
  let keepEmpty = 1
  let components = split(a:absolutePath, s:pathSeparator, keepEmpty)

  let parent = components[0]
  for component in components[1: ]
    let parent = parent . s:pathSeparator . component
    let file = expand(parent . s:pathSeparator . a:pattern)
    if (filereadable(file))
      return file
    endif
  endfor

  throw "file matching pattern not found. pattern: " . pattern . " | path: " . absolutePath
endfunction

function! s:findSln(absolutePath)
  return s:findPattern(a:absolutePath, '*.sln')
endfunction

function! s:findCsproj(absolutePath)
  return s:findPattern(a:absolutePath, '*.csproj')
endfunction

function! s:readCsproj(csproj)
  if (!filereadable(a:csproj))
    throw "csproj not found in path hierarchy"
  endif

  return readfile(a:csproj, 'b')
endfunction

function! s:writeCsproj(content, csproj)
  if (!filewritable(a:csproj))
    throw "csproj found but it can't be edited"
  endif

  call writefile(a:content, a:csproj, 'b')
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
    if !(s:match(item, a:pattern))
      let index = index + 1
      continue
    endif

    return index
  endfor

  return -1
endfunction

function! s:toBashPath(path)
  let bashPath = '/' . substitute(a:path, '\', '/', 'g')
  return substitute(bashPath, '/c:/', '/c/', '')
endfunction

function! s:match(str, pattern)
  return match(a:str, s:toSearchPattern(a:pattern)) != -1
endfunction

function! s:endsWith(str, pattern)
  return s:match(a:str, a:pattern . '$')
endfunction
