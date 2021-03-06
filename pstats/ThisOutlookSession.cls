VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END

Attribute VB_Name = "ThisOutlookSession"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
   
Private Type PROCESS_INFORMATION
         hProcess As Long
         hThread As Long
         dwProcessId As Long
         dwThreadId As Long
      End Type

Private Type STARTUPINFO
         cb As Long
         lpReserved As String
         lpDesktop As String
         lpTitle As String
         dwX As Long
         dwY As Long
         dwXSize As Long
         dwYSize As Long
         dwXCountChars As Long
         dwYCountChars As Long
         dwFillAttribute As Long
         dwFlags As Long
         wShowWindow As Integer
         cbReserved2 As Integer
         lpReserved2 As Long
         hStdInput As Long
         hStdOutput As Long
         hStdError As Long
      End Type

Private Declare Function CreateProcess Lib "kernel32" _
         Alias "CreateProcessA" _
         (ByVal lpApplicationName As String, _
         ByVal lpCommandLine As String, _
         lpProcessAttributes As Any, _
         lpThreadAttributes As Any, _
         ByVal bInheritHandles As Long, _
         ByVal dwCreationFlags As Long, _
         lpEnvironment As Any, _
         ByVal lpCurrentDriectory As String, _
         lpStartupInfo As STARTUPINFO, _
         lpProcessInformation As PROCESS_INFORMATION) As Long

Private Declare Function WaitForSingleObject Lib "kernel32.dll" _
         (ByVal hHandle As Long, _
         ByVal dwMilliseconds As Long) As Long

Private Declare Function GetLastError Lib "kernel32.dll" _
         () As Long
         
Private Declare Function GetExitCodeProcess Lib "kernel32.dll" _
         (ByVal hProcess As Long, _
         lpExitCode As Long) As Long
         

      Const SYNCHRONIZE = 1048576
      Const NORMAL_PRIORITY_CLASS = &H20&
Sub DeleteFile(filename)
   If (Dir(filename) <> "") Then
    Kill (filename)
   End If
End Sub
Function GetErrorDesc(err) As String
Select Case err
  Case 0
    GetErrorDesc = "�������� ������� ���������"
  Case 1
    GetErrorDesc = "�������� ���������"
  Case 2
    GetErrorDesc = "��� ������ �����"
  Case 3
    GetErrorDesc = "�� ������� ������� ����"
  Case 4
    GetErrorDesc = "�� ������� ������� ����"
  Case 5
    GetErrorDesc = "������ ����"
  Case 6
    GetErrorDesc = "���� �� ��������"
  Case 7
    GetErrorDesc = "�� ������� ������� ���� �����������"
  Case 8
    GetErrorDesc = "�� ������� ��������� ����"
  Case 9
    GetErrorDesc = "����������� ������"
  Case 10
    GetErrorDesc = "�� ������� �������� ��� ���������� �������� ���������"
  End Select
End Function

Sub PercoStatsMail(item As Outlook.MailItem)
  'On Error GoTo Release
  
  If item.Class <> olMail Then
   GoTo Release
  End If
  
  If item.Attachments.Count = 0 Then
   GoTo Release
  End If
  
  Dim MailMsg As MailItem
  Dim BaseMsg As MailItem
  
  
  '�������������� ��������� ������
  Set BaseMsg = item.Reply
  For i = BaseMsg.recipients.Count To 1 Step -1
    BaseMsg.recipients.Remove (i)
  Next i
  BaseMsg.subject = "RE: " & item.subject
  'BaseMsg.subject = "RE: on test"
  
  For Each Attach In item.Attachments
    result = ""
    Dim xlsPos As Integer
    xlsPos = InStr(UCase(Attach.filename), ".XLS")
    If (xlsPos <> 0) Then
        DeleteFile ("d:\temp\perco\" + Attach.filename)
    
        Attach.SaveAsFile ("d:\temp\perco\" + Attach.filename)
        cmd = "d:\temp\perco\pstats.exe " + """" + "d:\temp\perco\" + Attach.filename + """"
    
        Dim pInfo As PROCESS_INFORMATION
        Dim sInfo As STARTUPINFO
        Dim sNull As String
        Dim lSuccess As Long
        Dim lRetValue As Long

        sInfo.cb = Len(sInfo)
        sInfo.dwFlags = 1
        sInfo.wShowWindow = 0
           
        lSuccess = CreateProcess(sNull, cmd, ByVal 0&, ByVal 0&, 1&, NORMAL_PRIORITY_CLASS, ByVal 0&, sNull, sInfo, pInfo)
    
        Set MailMsg = BaseMsg.Copy
    
        If (lSuccess <> 0) Then
            ret = WaitForSingleObject(pInfo.hProcess, 120000)
            If (ret <> &HFFFFFFFF) Then
                Dim EP As Long
                EP = GetExitCodeProcess(pInfo.hProcess, ret)
                If EP <> 1 Then
                    ret = 10
                End If
                    
                If (ret = 0) Then
                    result = "���� " & Attach.filename & " ��������� " & vbCrLf
                    '���� ���������� � ������ ���������� ������ (���������, ��� � �����������) � ���� �� ������ �����
                    MailMsg.recipients.Add ("mymail@mymailserver.ru")
                    MailMsg.recipients.Add (item.Sender)
                    Dim TestPos As Integer
                    '���������� ���������� ������ ������ �����
                    TestPos = InStr(UCase(Attach.filename), "����� � ����� �����") + InStr(UCase(Attach.filename), "����� ����� � ����� �����")
                    If (TestPos > 0) Then
                        MailMsg.recipients.Add ("BOSS@mymailserver.ru")
                        MailMsg.recipients.Add ("ZAMBOSS@mymailserver.ru")
                    End If
                Else
                    result = "�� ������� ���������� ���� " & Attach.filename & ". ������: " & GetErrorDesc(ret) & vbCrLf
                    '���� ���������� � ������ ������
                    MailMsg.recipients.Add ("mymail@mymailserver.ru")
                End If
            Else
              result = "�� ��������� ���������� ���������" & vbCrLf
            End If
        Else
            result = "�� ������� ��������� �����������"
            MailMsg.recipients.Add ("mymail@mymailserver.ru")
        End If
    
        MailMsg.subject = BaseMsg.subject & "(" & Attach.filename & ")"
        MailMsg.HTMLBody = result & vbCrLf & MailMsg.HTMLBody
        MailMsg.Attachments.Add ("d:\temp\perco\" + Attach.filename)
        MailMsg.Send
        DeleteFile ("d:\temp\perco\" + Attach.filename)
    End If
  Next Attach
Release:

  Set BaseMsg = Nothing
  Set MailMsg = Nothing
  
  
End Sub
