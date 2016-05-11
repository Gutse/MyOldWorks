Option Explicit

Dim adoADCommand, adoADConnection, strBase, strFilter, strAttributes
Dim objRootDSE, strDNSDomain, strQuery, adoADRecordset
Dim strsAMAccountName, strdisplayname, strmail, strtelephoneNumber, strphysicalDeliveryOfficeName
Dim intCount


' Setup ADO objects.
Set adoADCommand = CreateObject("ADODB.Command")
Set adoADConnection = CreateObject("ADODB.Connection")
adoADConnection.Provider = "ADsDSOObject"
adoADConnection.Open "Active Directory Provider"
adoADCommand.ActiveConnection = adoADConnection

' Search entire Active Directory domain.
Set objRootDSE = GetObject("LDAP://RootDSE")

strDNSDomain = "OU=yours OU,DC=yours dc,DC=ru"

strBase = "<LDAP://" & strDNSDomain & ">"

' Filter on all user objects.
 strFilter = "(&(objectCategory=person)(objectClass=user))"

' Comma delimited list of attribute values to retrieve.
 strAttributes = "sAMAccountName, displayname, mail, telephoneNumber, physicalDeliveryOfficeName"

' Construct the LDAP syntax query.
 strQuery = strBase & ";" & strFilter & ";" & strAttributes &  ";subtree"
 adoADCommand.CommandText = strQuery
 adoADCommand.Properties("Page Size") = 100
 adoADCommand.Properties("Timeout") = 30
 adoADCommand.Properties("Cache Results") =  False

' Run the query on Active Directory.
Set adoADRecordset = adoADCommand.Execute

Dim fso, f
Set fso = CreateObject("Scripting.FileSystemObject")
Set f = fso.CreateTextFile("d:\node\adq.txt", true, true)


' Enumerate the resulting recordset.
Do Until adoADRecordset.EOF
     ' Retrieve values.
     strsAMAccountName = adoADRecordset.Fields("sAMAccountName").Value
     'WScript.Echo (strsAMAccountName)

     strdisplayname = adoADRecordset.Fields("displayname").Value
     strmail = adoADRecordset.Fields("mail").Value
     strtelephoneNumber = adoADRecordset.Fields("telephoneNumber").Value
     strphysicalDeliveryOfficeName= adoADRecordset.Fields("physicalDeliveryOfficeName").Value
     f.WriteLine(strsAMAccountName&";"&strdisplayname&";"&strmail&";"&strtelephoneNumber&";"&strphysicalDeliveryOfficeName&";")

     ' Move to the next record in the recordset of AD users.
     adoADRecordset.MoveNext
Loop

' Clean up.
 f.Close
 adoADRecordset.Close
 adoADConnection.Close
