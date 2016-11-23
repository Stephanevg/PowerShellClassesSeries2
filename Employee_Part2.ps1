Class Employee {


    [ValidatePattern("^[a-zA-Z]+$")]
    [string]$FirstName
    [ValidatePattern("^[a-z A-Z]+$")]
    [string]$LastName

    hidden [string]$UserName

    [ValidateSet('Internal','External')]
    [string]
    $EmployeeType
    [ValidatePattern("^OU=")]
    [string]$OU

    hidden static [string]$DomainName = "DC=District,DC=Local"



}

$NewEmployee = [employee]::new()
$NewEmployee.FirstName = "Stephane"
$NewEmployee.LastName = "Van Gulick"
$NewEmployee.EmployeeType = "Internal"
$NewEmployee.OU = "OU=Internal,OU=Users,OU=HQ," + [employee]::DomainName 
$NewEmployee