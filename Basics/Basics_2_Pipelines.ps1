#**************************************************
Write-Host ****************************************
Write-Host Pipelines and the Context Operator
Write-Host ****************************************
#**************************************************

#It's basically like LINQ or any other fluent API you've worked with

function Get-Letters{
    return @("a","b","c")
}

#gets called for each item in the collection returned by Get-Letters
Get-Letters | Write-Host 

# '%' allows you to assign a script block to execute for each
Get-Letters | % { Write-Host $_ } # $_ is the context operator. Think of it sort of like 'this'

#filter items from the pipeline and then pass it along again
Get-Letters | where { $_ -eq 'a' } | Write-Host 

#**************************************************
Write-Host ****************************************
Write-Host Practical Example
Write-Host ****************************************
#**************************************************

#Delete file from a temp directory that are more than a day old
Get-ChildItem -Path C:/Temp_Demo | where { $_.LastWriteTime -lt [System.DateTime]::Now.AddDays(-1) } | Remove-Item -Force #more detail on that weird System.DateTime syntax later...

#**************************************************
Write-Host ****************************************
Write-Host Writing your Own Pipeline Cmdlets
Write-Host ****************************************
#**************************************************

function Use-BadTechniquesForPipelineInput(
    #implicitly assign a variable from the pipeline context
    [Parameter(ValueFromPipeline=$true)][string]$letter
){
    #this function body only gets invoked once at the end of the pipeline with the LAST VALUE
    Write-Host $letter #writes only the last value????

    #you can use the $input var to access all the pipeline items at once
    for($i = 0; $i -lt $input.Length; $i++){
        Write-Host $input[$i]
    }
}

function Use-GoodTechniquesForPipelineInput(
    #implicitly assign a variable from the pipeline context
    [Parameter(ValueFromPipeline=$true)][string]$letter,
    [string]$prefix
){
    #the 'process' block is invoked for each input in the pipeline
    #the 'process' block must be the only thing in the function body
    process{
        Write-Host "$prefix $letter"
    }            
}

Get-Letters | Use-BadTechniquesForPipelineInput
Get-Letters | Use-GoodTechniquesForPipelineInput -Prefix "letter:"



