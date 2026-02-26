#pegar o diretório atual

$scriptDirectory = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent

#Arquivo de saída com todos sql

$outputFile = Join-Path -Path $scriptDirectory -ChildPath "migration.sql"
#Path é pra ver o caminho do arquivo.
#verificar se o arquivo já existe, se existir, apagar

if (Test-Path -Path $outputFile) {
    Remove-Item -Path $outputFile
}

#pegar o conteudo dos arquivos

$sqlFiles = Get-ChildItem -Path $scriptDirectory -Filter "*.sql" -File | Sort-Object Name
#getchilditem é pra pegar os arquivos, filter é pra filtrar somente os arquivos com extensão .sql e -file é pra pegar somente arquivos, não pastas
#Se é Filter é pra filtrar os arquivos, se é File é pra pegar somente arquivos, não pastas

#Concatena arquivos
foreach ($file in $sqlFiles) {
    Get-Content -Path $file.FullName | Out-File -FilePath $outputFile -Append #get-content é pra pegar o conteúdo do arquivo, add-content é pra adicionar o conteúdo no arquivo de saída, o fullName é pra pegar o caminho completo do arquivo;
    "GO" | Out-File  -Append -FilePath $outputFile #adiciona o comando GO no final de cada arquivo, pra separar os comandos SQL.
}
#append é pra adicionar o conteúdo no arquivo de saída, se não usar append, ele vai sobrescrever o arquivo a cada iteração do loop.

Write-Host "Todos os arquivos SQL foram concatenados em $outputFile"