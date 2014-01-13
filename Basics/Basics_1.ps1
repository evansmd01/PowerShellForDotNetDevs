#**************************************************
Write-Host ****************************************
Write-Host Variables
Write-Host ****************************************
#**************************************************

$UpperCamelCase = 'is the naming convention'

$DynamicallyTypedVariables = 1234
$DynamicallyTypedVariables = "can be changed"

[int]$StronglyTypedVariables = "can't"


#**************************************************
Write-Host ****************************************
Write-Host Strings
Write-Host ****************************************
#**************************************************

$StrVariable = "double" + ' or single'
$Concatentation = "$strvariable quotes"

#notice it's not case sensitive
Write-Host $concatentation 

#The String is acutally a System.String
Write-Host $Concatentation.Length 
Write-Host $Concatentation.ToUpper() 
Write-Host $Concatentation.Substring("double or ".Length) 



#**************************************************
Write-Host ****************************************
Write-Host Comparison Operators
Write-Host ****************************************
#**************************************************

#Operators are a little goofy...

# (1 < 2)
Write-Host (1 -lt 2) 

# (1 >= 2)
Write-Host (1 -ge 2) 

# (1 == 2)
Write-Host (1 -eq 2) 

# (1 != 2)
Write-Host (1 -ne 2) 

# !(1 == 2)
Write-Host (-not (1 -eq 2)) 



#**************************************************
Write-Host ****************************************
Write-Host Booleans and Nulls
Write-Host ****************************************
#**************************************************


#PowerShell doesn't have keywords for 'null' 'true' or 'false'
#But it does have global variables defined

if($true){
    Write-Host 'It was true'
}

if(-not $false){
    Write-Host 'It was false'
}

if("string" -ne $null){
    Write-Host 'not null'
}


#**************************************************
Write-Host ****************************************
Write-Host Cmdlet Naming
Write-Host ****************************************
#**************************************************

#Cmdlets (Pronounced: Command lets) are basically just global function
#The naming conventions is expected to be Verb-Noun. This is used by the Get-Command Cmdlet to allow searching by verb and/or noun. Very handy. 

function Test-Help{ }
Get-Command -Verb Test -Noun Help 


#**************************************************
Write-Host ****************************************
Write-Host Cmdlet Params
Write-Host ****************************************
#**************************************************

function Do-Stuff(
    [string]$ExplicitlyTypedString, #Must be a string
    $DynamicallyTypedWithDefault = 5, #Default is Int32 with value of 5, but could be replaced by a different type
    [switch]$SayHello #bool-like flag value
)
{
    Write-Host "Num = $DynamicallyTypedWithDefault, Str = $ExplicitlyTypedString"
    if($SayHello){
        Write-Host hello world
    }
}

Do-Stuff -ExplicitlyTypedString hello 
Do-Stuff -ExplicitlyTypedString hello -DynamicallyTypedWithDefault "I'm not an int, what were you expecting???" 
Do-Stuff -SayHello

#**************************************************
Write-Host ****************************************
Write-Host Cmdlet Param Validation
Write-Host ****************************************
#**************************************************

function Do-MoreStuff(
    [string]$SuperMandatory = $(Throw "Parameter -SuperMandatory was not supplied"), #allows null or empty, throws error if not supplied
    [Parameter(Mandatory=$true)][string]$Message, #prompts user for a value if not supplied, throws errror if null or empty  
    [ValidateSet("a","b","c")][string]$Letter,
    [ValidateRange(1,10)][int]$OneThroughTen
){
    $concat = $letter + $oneThroughTen + ":"
    Write-Host "$concat $message"
}

#**************************************************
Write-Host ****************************************
Write-Host Exception Handling
Write-Host ****************************************
#**************************************************

Do-MoreStuff -SuperMandatory '' -Message hello -Letter "a" -OneThroughTen "1" #$notice the string value 1 is implicitly cast to an int and validates
Do-MoreStuff -SuperMandatory '' -Message hello -Letter "d" -OneThroughTen "1" -ErrorAction Continue
Do-MoreStuff -SuperMandatory '' -Message hello -Letter "a" -OneThroughTen "11" -ErrorAction Continue
Do-MoreStuff -Message '' -ErrorAction Continue

try{
    Do-MoreStuff -Message ' ' -ErrorAction Continue # -ErrorAction Continue doesn't work since we explicitly threw the error, it will break the script unless we catch it
}
catch{
    Write-Host $_ #We'll get into this context variable in more detail later, for now it happens to be the exception
}

Write-Host hello world

#**************************************************
Write-Host ****************************************
Write-Host Interpretation and Execution order
Write-Host ****************************************
#**************************************************

#This is an interpreted language, it loads one line at a time and executes as it goes
#So be sure to define your Cmdlets before you try to use them

Do-OtherStuff #: Error (Unless you already ran the script in the same instance of powershell once before)

function Do-OtherStuff(){ Write-Host "did it work?" }

Do-OtherStuff #: did it work?


#**************************************************
Write-Host ****************************************
Write-Host Script Blocks 
Write-Host ****************************************
#**************************************************

[ScriptBlock]$Sb = {
    Write-Host "Anonymous functions are boss."
}

function Use-ScriptBlock(
    [ScriptBlock]$TheBlock
){
    .$TheBlock
}

#use the dot operator to call it
Use-ScriptBlock $sb #notice I don't need to supply the param name if the order and type match up






