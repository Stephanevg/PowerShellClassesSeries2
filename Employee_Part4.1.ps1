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

    #Constructors

    Employee (){
    
    } 


    Employee ([String]$FirstName,[String]$Lastname,[String]$EmployeeType){

            #Initializing variables
                $UserOU = ""

            #Setting properties
                $this.EmployeeType = $EmployeeType
                $this.FirstName = $FirstName
                $this.LastName = $Lastname

            #Notice the call to our static method
                $this.UserName = [Employee]::GetNewUserName($FirstName,$Lastname)

            #Notice the call to our static property
                $this.OU = "OU=$($EmployeeType)," + "OU=Users,OU=HQ," + [employee]::DomainName   
            
    }

    #Methods

    [string]static GetNewUserName([string]$FirstName,[string]$LastName){

        $start = $LastName.replace(" ","").Substring(0,5)
        $end = $FirstName.Substring(0,2)
        
        
            $UName = ($start + $end).ToLower()
        
        
            $AllNames = Get-ADUser -Filter "SamaccountName -like '$UName*'"
            [int]$LastUsed = $AllNames | % {$_.SamAccountName.trim($Uname)} | select -Last 1
            $Next = $LastUsed+1
            $nextNumber = $Next.tostring().padleft(2,'0')
            $SamAccountName = $UName + $nextNumber
        return $SamAccountName
         
        
    } 

    [employee]Create(){
        
        New-ADUser -SamAccountName $this.UserName `
                   -GivenName $this.FirstName `
                   -Surname $this.LastName `
                   -Name $this.UserName `
                   -UserPrincipalName $this.UserName `
                    -DisplayName ($this.FirstName + " " + $this.LastName) `
                    -Description ($this.FirstName + " " + $this.LastName) `
                    -Path $this.OU

        return $this
    } 

} 

$NewEmployee = [employee]::new("Stephane","Van Gulick","Internal") 
$NewEmployee | Get-Member 

