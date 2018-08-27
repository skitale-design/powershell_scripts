function createFiles($number)
{
    1..$number | %{New-Item -Path "F:\Work\test" -Name $_'.txt' -ItemType File}
}

function createFolders($folder)
{
    1..2|%{
        if(!(Test-Path "$folder\$_"))
        {
            ni -Path $folder -Name $_ -ItemType Directory        
        }
    }
}

function countFilesIn($folder)
{
    $cuantity = 0
    foreach($_ in dir $folder)
    {
        if(!$_.PSisContainer)
        {
            $cuantity++;
        }
    }

    $cuantity    
}

function InTwoFolders($folder)
{
    $filesInFolder = countFilesIn $folder
    if((countFilesIn $folder) -ne 1)
    {
        createFolders $folder
    }

    "folder = $folder"
    $i = 1
    $half = (countFilesIn $folder)/2
    "half=$half"
    foreach($file in dir $folder)
    {
        if(!$file.PSisContainer)
        {
            $i
            
            if($i -le $half)
            {
                Copy-Item $file.FullName -Destination $folder'\1'   
            }
            else
            {
                Copy-Item $file.FullName -Destination $folder'\2'                   
            }
            $i++
        }
    }
    $folder1 = $folder+'\1'
    $folder2 = $folder+'\2'

    $filesIn1 = countFilesIn($folder1)
    $filesIn2 = countFilesIn($folder2)
        
    "В папке 1 файлов: $filesIn1"
    "В папке 2 файлов: $filesIn2"

    "Рекурсия"

    if($filesIn1 -ne 1)
    {
        InTwoFolders $folder1
    }

    if($filesIn2 -ne 1)
    {
        InTwoFolders $folder2
    }

}

function clearFolder($folder)
{
    dir $folder | %{Remove-Item $_.FullName -Force -Recurse}
}

function recurseFunc($folder)
{
    $i = countFilesIn $folder
    do
    {
       InTwoFolders $folder
       $folder
    }
    while ($i -ne 1)

}