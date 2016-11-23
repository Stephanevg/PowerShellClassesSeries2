
Class Employee {


    [ValidatePattern("^[a-z]$")]
    [string]$FirstName
    [ValidatePattern("^[a-z]$")]
    [string]$LastName

    hidden [string]$UserName

    [ValidateSet('Internal','External')]
    [string]
    $EmployeeType
    [ValidatePattern("^OU=")]
    [string]$OU

    hidden static [string]$DomainName = "DC=District,DC=Local"

}


#Instantiating a class way n°1

    $employee = [Employee]::new()
    $employee

#Instantiating a class way n°2
    New-Object Employee

#region Hidden Attribute

    $employee = [Employee]::new()
    $employee | get-member -MemberType Properties

    $employee | get-member -MemberType Properties -Force

#endregion

#Static properties
    $employee | Get-Member -MemberType Property -Static -Force
    [employee]::DomainName