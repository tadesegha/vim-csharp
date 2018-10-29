function! csharp#runOmni()
  call system('start powershell.exe -noprofile -noexit -command omnisharp.exe -s c:/dev/gcts/transcanada.gcts.sln')
endfunction

function! csharp#namespace()
  let path = expand('%:p')
  let csproj = s:findCsproj(path)
  let csprojDir = fnamemodify(csproj, ':p:h')
  let relativePath = s:relativePath(path, csprojDir)

  let other = substitute(relativePath, '\', '.', 'g')
  return fnamemodify(csprojDir, ':t') . fnamemodify(other, ':r:r')
endfunction

function! csharp#fqn()
  return csharp#namespace() . '.' . class
endfunction

function! csharp#nunitTests(...)
  let csproj = s:findCsproj(expand('%:p'))
  if match(csproj, 'Test') == -1
    echoerr 'could not find a test csproj file'
  endif

  call csharp#build()

  let csprojDir = fnamemodify(csproj, ':p:h') . '\'
  let csprojFilename = fnamemodify(csproj, ':t:r')
  let testAssembly = findfile(csprojFilename . '.dll', "bin/debug/**")

  let command = 'if [[ $? -eq 0 ]] ;'
  let command = command . ' then powershell -noprofile -command'
  let command = command . ' "nunit-console.exe ' . fnamemodify(testAssembly, ':p')
  if (a:0)
    let command = command . ' /run=' . a:1
  endif
  let command = command . '"; fi'

  call term#executeInTerm('shell', command)
  call term#defaultTerm()
endfunction

function! csharp#nunitTest()
  OmniSharpNavigateUp

  let testName = '.' . expand('<cword>')
  if testName == ('.' . expand('%:t:r'))
    let testName = ''
  endif

  let fqn = csharp#fqn() . testName
  call csharp#nunitTests(fqn)
endfunction

function! csharp#newItem(...)
  if (a:0)
    let path = a:1
    let csproj = s:findCsproj(path)
  else
    let csproj = s:findCsproj(expand('%:p'))
    let csprojDir = fnamemodify(csproj, ':p:h') . '\'

    let opt = {
          \'prompt': 'new item: ',
          \'completion': 'file',
          \'default': csprojDir
          \}
    let path = input(opt)
    if (path == '')
      echo 'new item cancelled'
      return
    endif
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
  call delete(path)
  bd!
endfunction

function! csharp#moveItem()
  let opt = {
        \'prompt': 'move item: ',
        \'completion': 'file',
        \'default': expand('%:p')
        \}
  let path = input(opt)
  if (path == '')
    echo 'move item cancelled'
    return
  endif

  let content = readfile(expand('%'), 'b')
  call writefile(content, path, 'b')

  call csharp#deleteItem(v:false)
  call s:addToCsproj(path)
  execute 'edit ' . path
endfunction

function! csharp#build()
  if (!executable('msbuild.exe'))
    echoerr 'could not find msbuild.exe'
  endif

  let sln = s:findSln(expand('%:p'))
  call term#executeInTerm('shell', 'powershell -noprofile -command "msbuild.exe /v:q ' . sln . '"')
  call term#defaultTerm()
endfunction

function! s:findPattern(absolutePath, pattern)
  let components = split(a:absolutePath, '\')

  let parent = components[0]
  for component in components[1: ]
    let parent = parent . '\' . component
    let file = expand(parent . '\' . a:pattern)
    if (filereadable(file))
      return file
    endif
  endfor

  echoerr "file matching pattern not found. pattern: " . pattern . " | path: " . absolutePath
endfunction

function! s:findSln(absolutePath)
  return s:findPattern(a:absolutePath, '*.sln')
endfunction

function! s:findCsproj(absolutePath)
  return s:findPattern(a:absolutePath, '*.csproj')
endfunction

function! s:readCsproj(csproj)
  if (!filereadable(a:csproj))
    echoerr "csproj not found in path hierarchy"
  endif

  return readfile(a:csproj, 'b')
endfunction

function! s:writeCsproj(content, csproj)
  if (!filewritable(a:csproj))
    echoerr "csproj found but it can't be edited"
  endif

  call writefile(a:content, a:csproj, 'b')
endfunction

function! s:addToCsproj(path)
  let csproj = s:findCsproj(a:path)
  let csprojDir = fnamemodify(csproj, ':p:h') . '\'
  let relativePath = s:relativePath(a:path, csprojDir)

  let insertion = '    <Compile Include="' . relativePath . '" />'
  let insertionPattern = trim(s:toSearchPattern(insertion))
  let content = s:readCsproj(csproj)
  if s:findInList(content, insertionPattern) != -1
    echoerr 'csproj already contains file'
  endif

  let insertionIndex = s:findInList(content, '<Compile Include=".*" />')
  if insertionIndex == -1
    echoerr "could not find a line in csproj matching '<Compile Include=\".*\" />'. unable to determine where to add new file in csproj."
  endif

  call insert(content, insertion, insertionIndex)
  call s:writeCsproj(content, csproj)
endfunction

function! s:removeFromCsproj(path, ...)
  let csproj = a:0 ? a:1 : s:findCsproj(a:path)
  let csprojDir = fnamemodify(csproj, ':p:h') . '\'
  let relativePath = s:relativePath(a:path, csprojDir)

  let content = s:readCsproj(csproj)
  let removalPattern = s:toSearchPattern('<Compile Include="' . relativePath . '"')
  let removalIndex = s:findInList(content, removalPattern)

  if removalIndex == -1
    echoerr 'did not find current file in csproj'
  endif

  call remove(content, removalIndex)
  call s:writeCsproj(content, csproj)
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
