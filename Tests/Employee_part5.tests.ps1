

Describe 'Enums' {

  Context 'Checking presence' {
  
    it 'EmployeeType should be present'{
    
      {[EmployeeType]} | should not throw
    
    }
    
    it 'ExternalBaseGroups should be present'{
    
      {[ExternalBaseGroups]} | should not throw
    
    }
    
    it 'InternalBaseGroups should be present'{
    
      {[InternalBaseGroups]} | should not throw
    
    }
  
  }

}

Describe 'Class Employee'{

  $FirstName = 'Stephane'
  $LastName = 'van Gulick'

  Context 'Instantiation'{
  
    it 'Should be loaded' {
      {[Employee]} | should not throw
    }
  
    it 'Should not instantiate' {
      
      {[Employee]::New($FirstName,$LastName)} | should throw

    }
  
  }
  
  Context 'Static Properties and Methods'{
  
    it 'Static Property: DomainName' {
      [Employee]::DomainName | should not be nullOrEmpty
    }
    it 'Static Method: GetNewUserName' {
      $emp = [Employee]::GetNewUserName($FirstName,$LastName) 
      $emp | should not be nullOrEmpty
    }
  
  }

}

Describe 'ExternalEmployee Class' {

  $NewEmployee = [ExternalEmployee]::New($FirstName,$LastName)

  Context 'Instantiation - Constructors'{
    it 'Should Instantiate' {
      
      {[ExternalEmployee]::New($FirstName,$LastName)} | should not throw

    
    }
    
    It 'Should have correct values'{
    
      $NewEmployee.FirstName | should be $FirstName
      $NewEmployee.LastName | should be $LastName
      $NewEmployee.OU | should not be nullOrEmpty
      $NewEmployee.UserName | should not be nullOrEmpty
    
    }
    
  }
  
  Context 'Methods' {
  
    it 'Should Inherit from methods from Employee'{
       
    }
    
  }
  
    
      

}