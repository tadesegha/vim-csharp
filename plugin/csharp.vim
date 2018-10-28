" start omnisharp server
let bufferNumber = bufnr('%')
call term#asyncTerm('omni', 'powershell -noprofile -command "omni"')
execute 'buffer ' . bufferNumber
