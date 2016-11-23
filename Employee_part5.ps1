Enum EmployeeType{

  Internal
  External
  
}

Enum InternalBaseGroups{

  GG_WifiUsers
  GG_Acces_L1
  GG_Acces_L2
}


Enum ExternalBaseGroups{

  GG_ExternalUsers
  GG_Acces_L1
} 

Class Employee {


  [ValidatePattern("^[a-zA-Z]+$")]
  [string]$FirstName
  [ValidatePattern("^[a-z A-Z]+$")]
  [string]$LastName
  hidden [string]$UserName
  [EmployeeType]$EmployeeType
  [ValidatePattern('^OU=')]
  [string]$OU

  hidden static [string]$DomainName = 'DC=District,DC=Local'
  hidden [String]$BaseGroupsEnumName
  

  #Constructors

  Employee(){

    if ($this.GetType() -eq [Employee]){
        throw "This class cannot be used to create an instance. Please inherit from this class only."
    }
  }

  Employee ([String]$FirstName,[String]$Lastname,[EmployeeType]$EmployeeType){ 

    #Initialising variables
    $UserOU = ''

    #Setting properties
    $this.EmployeeType = $EmployeeType
    $this.FirstName = $FirstName
    $this.LastName = $Lastname

    #Notice the call to our static method
    $this.UserName = [Employee]::GetNewUserName($FirstName,$Lastname)

    #Notice the call to our static property
    $this.OU = "OU=$($EmployeeType)," + 'OU=Users,OU=HQ,' + [employee]::DomainName   
            
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
    -DisplayName ($this.FirstName + ' ' + $this.LastName) `
    -Description ($this.FirstName + ' ' + $this.LastName) `
    -Path $this.OU

    

    return $this
  } 


    
  hidden [void]AddGroupsFromEnum([String]$GroupList){

    $AllGroups = [System.Enum]::GetNames($GroupList)
    foreach ($group in $AllGroups){
      ([Employee]$this).AddToGroup($group)
    }
        
  
  }

  hidden [void]AddToGroup([string]$AdGroup){
    
    Add-ADGroupMember -Identity $Adgroup -Members (get-aduser $this.UserName)

  }

  [void]AddToBaseGroups(){
    
        $this.AddGroupsFromEnum($this.BaseGroupsEnumName)
    }

}

Class ExternalEmployee : Employee{
    
    ExternalEmployee([String]$FirstName,[String]$LastName){
        $this.BaseGroupsEnumName = "ExternalBaseGroups"
        $this.EmployeeType = [EmployeeType]::External
        $this.FirstName = $FirstName
        $this.LastName = $LastName  
        $this.UserName = [Employee]::GetNewUserName($FirstName,$LastName)
    
        #Notice the call to our static property
        $this.OU = "OU=$($This.EmployeeType)," + 'OU=Users,OU=HQ,' + [employee]::DomainName
  }


    
}


Class InternalEmployee : Employee{

    InternalEmployee([string]$FirstName,[string]$LastName){ 
    
        $this.BaseGroupsEnumName = "InternalBaseGroups"
        $this.EmployeeType = [EmployeeType]::Internal
        $this.FirstName = $FirstName
        $this.LastName = $LastName  
        $this.UserName = [Employee]::GetNewUserName($FirstName,$LastName)
    
        
        $this.OU = "OU=$($This.EmployeeType)," + 'OU=Users,OU=HQ,' + [employee]::DomainName
    }

}


$NewInternalEmployee = [InternalEmployee]::new('Stephane','Van Gulick')
$NewInternalEmployee.Create()
$NewInternalEmployee.AddToBaseGroups()

$NewExtEmployee = [ExternalEmployee]::new("Stephane","Van Gulick")
$NewExtEmployee.Create()
$NewExtEmployee.AddToBaseGroups() 

 
Function Add-UserToGroups {
    Param(
        [Employee]$User
    )
   
    $User.AddToBaseGroups()

}

Add-UserToGroups -User $NewInternalEmployee