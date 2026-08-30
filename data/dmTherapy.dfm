object dmTherapy_: TdmTherapy_
  OnCreate = DataModuleCreate
  Height = 431
  Width = 406
  object fQryTherapySessions: TFDQuery
    Active = True
    Connection = dmServer_.FdServerConnection
    SQL.Strings = (
      'select * from vw_TherapySessionsReport')
    Left = 48
    Top = 8
    object fQryTherapySessionsId: TIntegerField
      FieldName = 'Id'
      Origin = 'Id'
      Required = True
      Visible = False
    end
    object fQryTherapySessionsTherapyName: TWideStringField
      FieldName = 'TherapyName'
      Origin = 'TherapyName'
      Size = 30
    end
    object fQryTherapySessionsTherapistName: TWideStringField
      FieldName = 'TherapistName'
      Origin = 'TherapistName'
      ReadOnly = True
    end
    object fQryTherapySessionsPatientName: TWideStringField
      FieldName = 'PatientName'
      Origin = 'PatientName'
      ReadOnly = True
    end
    object fQryTherapySessionsSessionDate: TWideStringField
      FieldName = 'SessionDate'
      Origin = 'SessionDate'
      ReadOnly = True
    end
    object fQryTherapySessionsStartTime: TTimeField
      FieldName = 'StartTime'
      Origin = 'StartTime'
    end
    object fQryTherapySessionsEndDate: TTimeField
      FieldName = 'EndDate'
      Origin = 'EndDate'
    end
  end
  object dsThrapySessions: TDataSource
    DataSet = fQryTherapySessions
    Left = 184
    Top = 8
  end
  object dsTherapists: TDataSource
    DataSet = fQryTherapists
    Left = 184
    Top = 72
  end
  object fQryTherapists: TFDQuery
    Connection = dmServer_.FdServerConnection
    SQL.Strings = (
      
        'SELECT Id,FirstName+'#39' '#39'+LastName AS FullName,SpecialtyId FROM Th' +
        'erapists'
      'ORDER BY FirstName,LastName')
    Left = 48
    Top = 72
    object fQryTherapistsId: TFDAutoIncField
      FieldName = 'Id'
      Origin = 'Id'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = True
    end
    object fQryTherapistsFullName: TWideStringField
      FieldName = 'FullName'
      Origin = 'FullName'
      ReadOnly = True
      Required = True
      Size = 201
    end
    object fQryTherapistsSpecialtyId: TIntegerField
      FieldName = 'SpecialtyId'
      Origin = 'SpecialtyId'
    end
  end
  object dsTherapyTypes: TDataSource
    DataSet = fQryTherapyTypes
    Left = 184
    Top = 136
  end
  object fQryTherapyTypes: TFDQuery
    Active = True
    Connection = dmServer_.FdServerConnection
    SQL.Strings = (
      'SELECT [Id]'
      '      ,[Title]'
      '  FROM [AutiSys].[dbo].[TherapyTypes]')
    Left = 48
    Top = 136
    object fQryTherapyTypesId: TFDAutoIncField
      FieldName = 'Id'
      Origin = 'Id'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = True
    end
    object fQryTherapyTypesTitle: TWideStringField
      FieldName = 'Title'
      Origin = 'Title'
      Size = 100
    end
  end
  object dsSessions: TDataSource
    DataSet = fQrySessions
    Left = 184
    Top = 200
  end
  object fQrySessions: TFDQuery
    Connection = dmServer_.FdServerConnection
    SQL.Strings = (
      'SELECT * FROM [AutiSys].[dbo].[Sessions]'
      'ORDER BY SessionDate,StartTime')
    Left = 48
    Top = 200
    object fQrySessionsId: TFDAutoIncField
      FieldName = 'Id'
      Origin = 'Id'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = True
    end
    object fQrySessionsPatientId: TIntegerField
      FieldName = 'PatientId'
      Origin = 'PatientId'
    end
    object fQrySessionsClassId: TIntegerField
      FieldName = 'ClassId'
      Origin = 'ClassId'
      Required = True
    end
    object fQrySessionsTherapyTypeId: TIntegerField
      FieldName = 'TherapyTypeId'
      Origin = 'TherapyTypeId'
    end
    object fQrySessionsStartTime: TTimeField
      FieldName = 'StartTime'
      Origin = 'StartTime'
    end
    object fQrySessionsEndTime: TTimeField
      FieldName = 'EndTime'
      Origin = 'EndTime'
    end
    object fQrySessionsTherapistId: TIntegerField
      FieldName = 'TherapistId'
      Origin = 'TherapistId'
    end
    object fQrySessionsTasks: TWideMemoField
      FieldName = 'Tasks'
      Origin = 'Tasks'
      BlobType = ftWideMemo
      Size = 2147483647
    end
    object fQrySessionsHomeWorks: TWideMemoField
      FieldName = 'HomeWorks'
      Origin = 'HomeWorks'
      BlobType = ftWideMemo
      Size = 2147483647
    end
    object fQrySessionsNotes: TWideMemoField
      FieldName = 'Notes'
      Origin = 'Notes'
      BlobType = ftWideMemo
      Size = 2147483647
    end
  end
  object fQryRooms: TFDQuery
    Connection = dmServer_.FdServerConnection
    SQL.Strings = (
      'SELECT * FROM [AutiSys].[dbo].[Rooms]')
    Left = 48
    Top = 272
    object fQryRoomsid: TFDAutoIncField
      FieldName = 'id'
      Origin = 'id'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = True
    end
    object fQryRoomsRoomName: TWideStringField
      FieldName = 'RoomName'
      Origin = 'RoomName'
      Size = 100
    end
  end
  object fQryPriodicalTests: TFDQuery
    Connection = dmServer_.FdServerConnection
    SQL.Strings = (
      'SELECT * FROM [AutiSys].[dbo].[PriodicalTests]')
    Left = 184
    Top = 280
    object fQryPriodicalTestsid: TIntegerField
      FieldName = 'id'
      Origin = 'id'
    end
    object fQryPriodicalTestsPatinetId: TIntegerField
      FieldName = 'PatinetId'
      Origin = 'PatinetId'
    end
    object fQryPriodicalTestsTherapistId: TIntegerField
      FieldName = 'TherapistId'
      Origin = 'TherapistId'
    end
    object fQryPriodicalTestsDateYear: TIntegerField
      FieldName = 'DateYear'
      Origin = 'DateYear'
    end
    object fQryPriodicalTestsDateMonth: TIntegerField
      FieldName = 'DateMonth'
      Origin = 'DateMonth'
    end
    object fQryPriodicalTestsDateDay: TIntegerField
      FieldName = 'DateDay'
      Origin = 'DateDay'
    end
    object fQryPriodicalTestsGrade: TIntegerField
      FieldName = 'Grade'
      Origin = 'Grade'
    end
    object fQryPriodicalTestsNotes: TWideMemoField
      FieldName = 'Notes'
      Origin = 'Notes'
      BlobType = ftWideMemo
      Size = 2147483647
    end
  end
  object fQryPatientsRep: TFDQuery
    Connection = dmServer_.FdServerConnection
    SQL.Strings = (
      'SELECT s.Id'
      '      ,p.FirstName + '#39' '#39'+p.LastName as PatientFullname'
      '      ,r.RoomName as ClassName'
      '      ,tt.Title as therapyName'
      '      ,SessionDate'
      
        '      ,FORMAT(SessionDate, '#39'yyyy/MM/dd'#39', '#39'fa-IR'#39') as SessionDate' +
        '_fa'
      '      ,StartTime'
      '      ,EndTime'
      '      ,t.FirstName + '#39' '#39'+t.LastName as TherapistFullName'
      '      ,Tasks'
      '      ,HomeWorks'
      '      ,s.Notes'
      '  FROM AutiSys.[dbo].[Sessions] s'
      '  left join Patients p on s.PatientId = p.id '
      '  left join Therapists t on s.TherapistId = t.id'
      '  left join Rooms r on s.ClassId = r.id'
      '  left join TherapyTypes tt on s.TherapyTypeId = tt.id'
      'ORDER BY p.FirstName ,p.LastName')
    Left = 64
    Top = 360
    object fQryPatientsRepId: TFDAutoIncField
      FieldName = 'Id'
      Origin = 'Id'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = True
      Visible = False
    end
    object fQryPatientsRepPatientFullname: TWideStringField
      DisplayLabel = #1606#1575#1605' '#1578#1608#1575#1606#1580#1608
      DisplayWidth = 20
      FieldName = 'PatientFullname'
      Origin = 'PatientFullname'
      ReadOnly = True
      Size = 201
    end
    object fQryPatientsRepClassName: TWideStringField
      DisplayLabel = #1605#1581#1604' '#1576#1585#1711#1586#1575#1585#1740
      DisplayWidth = 20
      FieldName = 'ClassName'
      Origin = 'ClassName'
      Size = 100
    end
    object fQryPatientsReptherapyName: TWideStringField
      DisplayLabel = #1606#1575#1605' '#1580#1604#1587#1607
      DisplayWidth = 20
      FieldName = 'therapyName'
      Origin = 'therapyName'
      Size = 100
    end
    object fQryPatientsRepSessionDate: TDateField
      DisplayWidth = 15
      FieldName = 'SessionDate'
      Origin = 'SessionDate'
      Visible = False
    end
    object fQryPatientsRepSessionDate_fa: TWideStringField
      DisplayLabel = #1578#1575#1585#1740#1582
      DisplayWidth = 15
      FieldName = 'SessionDate_fa'
      Origin = 'SessionDate_fa'
      ReadOnly = True
      Size = 4000
    end
    object fQryPatientsRepStartTime: TTimeField
      DisplayLabel = #1587#1575#1593#1578' '#1588#1585#1608#1593
      DisplayWidth = 15
      FieldName = 'StartTime'
      Origin = 'StartTime'
    end
    object fQryPatientsRepEndTime: TTimeField
      DisplayLabel = #1587#1575#1593#1578' '#1582#1575#1578#1605#1607
      DisplayWidth = 15
      FieldName = 'EndTime'
      Origin = 'EndTime'
    end
    object fQryPatientsRepTherapistFullName: TWideStringField
      DisplayLabel = #1606#1575#1605' '#1583#1585#1605#1575#1606#1711#1585
      DisplayWidth = 20
      FieldName = 'TherapistFullName'
      Origin = 'TherapistFullName'
      ReadOnly = True
      Size = 201
    end
    object fQryPatientsRepTasks: TWideMemoField
      DisplayLabel = #1705#1575#1585#1607#1575#1740' '#1575#1606#1580#1575#1605' '#1588#1583#1607
      FieldName = 'Tasks'
      Origin = 'Tasks'
      Visible = False
      BlobType = ftWideMemo
      Size = 2147483647
    end
    object fQryPatientsRepHomeWorks: TWideMemoField
      FieldName = 'HomeWorks'
      Origin = 'HomeWorks'
      Visible = False
      BlobType = ftWideMemo
      Size = 2147483647
    end
    object fQryPatientsRepNotes: TWideMemoField
      FieldName = 'Notes'
      Origin = 'Notes'
      Visible = False
      BlobType = ftWideMemo
      Size = 2147483647
    end
  end
end
