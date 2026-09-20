object dmBaseData_: TdmBaseData
  OnCreate = DataModuleCreate
  Height = 200
  Width = 300
  object fQryTherapists: TFDQuery
    SQL.Strings = (
      'SELECT * FROM Therapists ORDER BY FirstName, LastName')
    Left = 64
    Top = 40
    object fQryTherapistsId: TFDAutoIncField
      FieldName = 'Id'
      Origin = 'Id'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = True
    end
    object fQryTherapistsFirstName: TWideStringField
      FieldName = 'FirstName'
      Origin = 'FirstName'
      Required = True
      Size = 100
    end
    object fQryTherapistsLastName: TWideStringField
      FieldName = 'LastName'
      Origin = 'LastName'
      Required = True
      Size = 100
    end
    object fQryTherapistsBirthYear: TIntegerField
      FieldName = 'BirthYear'
      Origin = 'BirthYear'
    end
    object fQryTherapistsBirthMonth: TIntegerField
      FieldName = 'BirthMonth'
      Origin = 'BirthMonth'
    end
    object fQryTherapistsBirthDay: TIntegerField
      FieldName = 'BirthDay'
      Origin = 'BirthDay'
    end
    object fQryTherapistsPhone: TWideStringField
      FieldName = 'Phone'
      Origin = 'Phone'
      Size = 20
    end
    object fQryTherapistsAddress: TWideStringField
      FieldName = 'Address'
      Origin = 'Address'
      Size = 250
    end
    object fQryTherapistsSpecialtyId: TIntegerField
      FieldName = 'SpecialtyId'
      Origin = 'SpecialtyId'
    end
  end
  object dsTherapists: TDataSource
    DataSet = fQryTherapists
    Left = 192
    Top = 40
  end
end
