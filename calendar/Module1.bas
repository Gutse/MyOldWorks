Attribute VB_Name = "Module1"
Declare Function SetTimer Lib "user32" (ByVal hwnd As Long, ByVal nIDEvent As Long, ByVal uElapse As Long, ByVal lpTimerfunc As Long) As Long
Declare Function KillTimer Lib "user32" (ByVal hwnd As Long, ByVal nIDEvent As Long) As Long
Public TimerID As Long 'Need a timer ID to eventually turn off the timer. If the timer ID <> 0 then the timer is running

Dim fso As Object
Dim oFile As Object
Dim LastError As String

Const ErrorsRecipient As String = "coder@domain.ru"
Const SharedUserName As String = "birthday@domain.ru"
Const SyncUserList As String = "user1@domain.ru;user2@domain.ru;user3@domain.ru;user4@domain.ru;"

Const ScanIntervalLeft As Integer = 14
Const ScanIntervalRight As Integer = 14
Const LogFile As String = "d:\birthdays.log"


Sub LogMsg(Msg As String)
    On Error GoTo LogMsg_Error
    If Not (oFile Is Nothing) Then
        oFile.WriteLine Msg
    End If
    Exit Sub
LogMsg_Error:
    Exit Sub
End Sub

Public Sub ActivateTimer(ByVal nMinutes As Long)
  On Error GoTo ActivateTimer_Error
  Set fso = CreateObject("Scripting.FileSystemObject")
  Set oFile = fso.OpenTextFile(LogFile, 8, True)
  oFile.WriteLine "Log file opened: " & CStr(Now())
  nMinutes = nMinutes * 1000 * 60 'The SetTimer call accepts milliseconds, so convert to minutes
  If TimerID <> 0 Then Call DeactivateTimer 'Check to see if timer is running before call to SetTimer
  TimerID = SetTimer(0, 0, nMinutes, AddressOf TriggerTimer)
  If TimerID = 0 Then
    LogMsg ("The timer failed to activate.")
  End If
  Exit Sub
ActivateTimer_Error:
  Exit Sub
End Sub
Public Sub DeactivateTimer()
Dim lSuccess As Long
  lSuccess = KillTimer(0, TimerID)
  If lSuccess = 0 Then
    MsgBox "The timer failed to deactivate."
  Else
    TimerID = 0
  End If
  oFile.Close
  Set fso = Nothing
  Set oFile = Nothing
End Sub
Public Function GetFolder(ByVal FolderPath As String) As Outlook.Folder
    Dim TestFolder As Outlook.Folder
    Dim FoldersArray As Variant
    Dim i As Integer
    On Error GoTo GetFolder_Error
    If Left(FolderPath, 2) = "\\" Then
        FolderPath = Right(FolderPath, Len(FolderPath) - 2)
    End If
    'Convert folderpath to array
    FoldersArray = Split(FolderPath, "\")
    Set TestFolder = Application.Session.Folders.Item(FoldersArray(0))
    If Not TestFolder Is Nothing Then
        For i = 1 To UBound(FoldersArray, 1)
            Dim SubFolders As Outlook.Folders
            Set SubFolders = TestFolder.Folders
            Set TestFolder = SubFolders.Item(FoldersArray(i))
            If TestFolder Is Nothing Then
                Set GetFolder = Nothing
            End If
        Next
    End If
    'Return the TestFolder
    Set GetFolder = TestFolder
    Exit Function
GetFolder_Error:
    Set GetFolder = Nothing
    LogMsg ("error in GetFolder: " & Err & ": " & Error(Err))
    Exit Function
End Function
Function GetUserCalendar(user As String) As Outlook.Folder
    On Error GoTo GetUserCalendar_Error
    
    Set NS = Application.GetNamespace("MAPI")
    Set objUser = NS.CreateRecipient(user)
    objUser.Resolve
    If objUser.Resolved Then
        Set GetUserCalendar = NS.GetSharedDefaultFolder(objUser, olFolderCalendar)
    Else
        Set GetUserCalendar = Nothing
    End If
    Exit Function
GetUserCalendar_Error:
    LastError = Err.Description
    Set GetUserCalendar = Nothing
End Function
Function GetCalendarItems(Calendar As Outlook.Folder, filter As String) As Outlook.Items
    Dim CurrentCalItems As Outlook.Items
    
    On Error GoTo GetCalendarItems_Error
    
    Set CurrentCalItems = Calendar.Items
    CurrentCalItems.Sort "[Start]", False
    CurrentCalItems.IncludeRecurrences = True
    Set GetCalendarItems = CurrentCalItems.Restrict(filter)
    Exit Function
GetCalendarItems_Error:
    LastError = Err.Description
    Set GetCalendarItems = Nothing
End Function
Function UpdateCalendarItem(Src As Outlook.AppointmentItem, Dst As Outlook.AppointmentItem) As String
    Dim Flag As Boolean
   
    On Error GoTo UpdateCalendarItem_Error
    
    If Not Dst.ReminderSet Then 'если ReminderSet = false это значит что пользователь отменил событие и его не надо трогать что бы не надоедать пользователю
        UpdateCalendarItem = ""
        Exit Function
    End If
    
    Flag = False
    If Dst.Subject <> Src.Subject Then
        Dst.Subject = Src.Subject
        Flag = True
    End If
    If Dst.Start <> Src.Start Then
        Dst.Start = Src.Start
        Flag = True
    End If
    If Dst.Duration <> Src.Duration Then
        Dst.Duration = Src.Duration
        Flag = True
    End If
    If Dst.Location <> Src.Location Then
        Dst.Location = Src.Location
        Flag = True
    End If
    If Dst.Body <> Src.Body Then
        Dst.Body = Src.Body
        Flag = True
    End If
    If Dst.ReminderMinutesBeforeStart <> Src.ReminderMinutesBeforeStart Then
        Dst.ReminderMinutesBeforeStart = Src.ReminderMinutesBeforeStart
        Flag = True
    End If
    ' сохран€ем только если изменилс€ хот€ бы один параметр
    If (Flag) Then
        Dst.Save
    End If
    UpdateCalendarItem = ""
    Exit Function
UpdateCalendarItem_Error:
    UpdateCalendarItem = Err & ": " & Error(Err)
End Function

Function CreateItemInCalendar(Item As Outlook.AppointmentItem, Calendar As Outlook.Folder) As String
    Dim NewItem As AppointmentItem
    
    On Error GoTo CreateItemInCalendar_Error
    
    Set NewItem = Application.CreateItem(olAppointmentItem)
    With NewItem
        .Subject = Item.Subject
        .Start = Item.Start
        .Duration = Item.Duration
        .Location = Item.Location
        .Body = Item.Body
        .ReminderMinutesBeforeStart = Item.ReminderMinutesBeforeStart
        .ReminderSet = True
    End With
    Set NewItem = NewItem.Move(Calendar)
    NewItem.Save
    CreateItemInCalendar = ""
    Exit Function
CreateItemInCalendar_Error:
    CreateItemInCalendar = Err & ": " & Error(Err)
End Function
Sub SyncEvents()
    Dim synclist() As String
    Dim SharedCalendar As Outlook.Folder
    Dim UserCalendar As Outlook.Folder
    Dim strFilter As String
    Dim CurrentUser As Variant
    Dim ret As String
    Dim SharedCalendarItems As Outlook.Items
    Dim UserCalendarItems  As Outlook.Items
    Dim SharedCalendarItem As Outlook.AppointmentItem
    Dim UserCalendarItem As Outlook.AppointmentItem
    Dim NewCalendarItem  As Outlook.AppointmentItem
    Dim DDiff As Integer
    Dim UpdateFlag As Boolean
    Dim ErrorsList As Collection
    
    
    Set ErrorsList = New Collection
    
    Set SharedCalendar = GetUserCalendar(SharedUserName)
    If SharedCalendar Is Nothing Then
        LogMsg ("Ќе удалось открыть общий календарь " & LastError)
        ErrorsList.Add ("Ќе удалось открыть общий календарь " & LastError)
        GoTo ProcessErrors
    End If
    
    strFilter = "[Start]<= '" & CStr(DateValue(DateAdd("d", ScanIntervalRight, Now()))) & "' AND [Start] >= '" & CStr(DateValue(DateAdd("d", -ScanIntervalLeft, Now()))) & "'"
    
    Set SharedCalendarItems = GetCalendarItems(SharedCalendar, strFilter)
    
    If (SharedCalendarItems Is Nothing) Then
        LogMsg ("Ќе удалось получить событи€ в общем календаре " & LastError)
        ErrorsList.Add ("Ќе удалось получить событи€ в общем календаре " & LastError)
        GoTo ProcessErrors
    End If
    If (SharedCalendarItems Is Nothing) Or (SharedCalendarItems.Count = 0) Then
        LogMsg ("¬ общем календаре нет событий за указанный период")
        Exit Sub
    End If
    
    synclist = Split(SyncUserList, ";")
    
    For Each CurrentUser In synclist
        Set UserCalendar = GetUserCalendar(CStr(CurrentUser))
        If UserCalendar Is Nothing Then
            LogMsg ("Ќе удалось открыть календарь пользовател€ " & CurrentUser & " по причине: " & LastError)
            ErrorsList.Add ("Ќе удалось открыть календарь пользовател€ " & CurrentUser & " по причине: " & LastError)
            GoTo NextUser
        End If
        Set UserCalendarItems = GetCalendarItems(UserCalendar, strFilter)
        If (UserCalendarItems Is Nothing) Then
            LogMsg ("Ќе удалось получить событи€ пользовател€ " & CurrentUser & " по причине: " & LastError)
            ErrorsList.Add ("Ќе удалось получить событи€ пользовател€ " & CurrentUser & " по причине: " & LastError)
            GoTo NextUser
        End If
        
        For Each SharedCalendarItem In SharedCalendarItems
            UpdateFlag = False
            
            For Each UserCalendarItem In UserCalendarItems
                DDiff = DateDiff("d", SharedCalendarItem.Start, UserCalendarItem.Start)
                If (SharedCalendarItem.Subject = UserCalendarItem.Subject) And (DDiff = 0) Then
                    'мы нашли событие которое уже есть в календаре пользовател€. надо проверить изменилось ли оно и не отменил ли его уже пользователь
                    UpdateFlag = True
                    ret = UpdateCalendarItem(SharedCalendarItem, UserCalendarItem)
                    If ret <> "" Then
                        LogMsg ("ќшибка при обновлении событи€ " & UserCalendarItem & " в календаре пользовател€ " & CurrentUser & ": " & ret)
                        ErrorsList.Add ("ќшибка при обновлении событи€ " & UserCalendarItem & " в календаре пользовател€ " & CurrentUser & ": " & ret)
                    End If
                    Exit For
                End If
            Next
            
            If Not UpdateFlag Then
                ret = CreateItemInCalendar(SharedCalendarItem, UserCalendar)
                If ret <> "" Then
                    LogMsg ("ќшибка при добавлении событи€ " & SharedCalendarItem & " в календаре пользовател€ " & CurrentUser & ": " & ret)
                    ErrorsList.Add ("ќшибка при добавлении событи€ " & SharedCalendarItem & " в календаре пользовател€ " & CurrentUser & ": " & ret)
                End If
            End If
        Next
NextUser:
    Next
ProcessErrors:
    If ErrorsList.Count > 0 Then
        Call SendErrorReport(ErrorsList)
    End If
End Sub
Sub SendErrorReport(list As Collection)


    Dim olApp As Outlook.Application
    Dim objMail As Outlook.MailItem
    Dim MsgBody As String
    Set olApp = Outlook.Application
    MsgBody = ""
    For Each itm In list
        MsgBody = MsgBody & itm & vbCrLf
    Next
    
    Set objMail = olApp.CreateItem(olMailItem)
    
    With objMail
        .Subject = "ќшибки при синхронизации календарей"
        .Body = MsgBody
        .To = ErrorsRecipient
        .Send
    End With
End Sub

Public Sub TriggerTimer(ByVal hwnd As Long, ByVal uMsg As Long, ByVal idevent As Long, ByVal Systime As Long)
    SyncEvents
End Sub

