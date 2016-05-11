object DM: TDM
  OldCreateOrder = False
  Left = 233
  Top = 205
  Height = 394
  Width = 618
  object connection: TADOConnection
    ConnectionString = 
      'Provider=MSDAORA.1;Password=securyti;User ID=securyti;Data Sourc' +
      'e=boss;Persist Security Info=True'
    LoginPrompt = False
    Provider = 'MSDAORA.1'
    Left = 24
    Top = 8
  end
  object CTLG_Q: TADOQuery
    Connection = connection
    Parameters = <>
    SQL.Strings = (
      'SELECT * FROM ACATALOG')
    Left = 80
    Top = 8
  end
  object persons: TADOQuery
    Connection = connection
    CursorType = ctStatic
    AfterOpen = personsAfterOpen
    Parameters = <>
    SQL.Strings = (
      'select * from dias_v_all_person')
    Left = 24
    Top = 64
  end
  object perons_s: TDataSource
    DataSet = persons
    Left = 80
    Top = 64
  end
  object PERSON_Q: TADOQuery
    Connection = connection
    Parameters = <>
    SQL.Strings = (
      'SELECT * FROM ACATALOG')
    Left = 168
    Top = 8
  end
  object ACCESS_T: TADOTable
    Connection = connection
    CursorType = ctStatic
    IndexFieldNames = 'PRN;FOR_WORKER'
    MasterFields = 'RN;IS_WORKER'
    MasterSource = perons_s
    TableName = 'dias_access'
    Left = 32
    Top = 128
  end
  object ACCESS_S: TDataSource
    DataSet = ACCESS_T
    Left = 96
    Top = 128
  end
  object cm: TADOQuery
    Connection = connection
    Parameters = <>
    Left = 328
    Top = 80
  end
end
