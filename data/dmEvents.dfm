object dmEvents_: TdmEvents_
  OnCreate = DataModuleCreate
  Height = 480
  Width = 339
  object dsEvents: TDataSource
    DataSet = fQryEvents
    Left = 200
    Top = 24
  end
  object fQryEvents: TFDQuery
    Active = True
    Connection = dmServer_.FdServerConnection
    SQL.Strings = (
      'SELECT id,EventName,EventTypeId FROM [Events]')
    Left = 64
    Top = 24
  end
end
