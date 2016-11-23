$Properties = @{
  “FirstName” = “Stéphane”
  “LastName” = “van Gulick”
  “WebSite” = “www.powershelldistrict.com”
}
$Object = New-object -TypeName psobject -Property $properties
$Object

Class Author {

    $FirstName = 'Stéphane'
    $LastName = "van Gulick"
    $WebSite = 'www.powershelldistrict.Com'

}

New-Object Author

[Author]::new()
