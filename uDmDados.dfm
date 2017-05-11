object dmDados: TdmDados
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 364
  Width = 608
  object FDConnection1: TFDConnection
    Params.Strings = (
      'Server=localhost'
      'DriverID=Mongo')
    Connected = True
    LoginPrompt = False
    Left = 176
    Top = 40
  end
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'FMX'
    Left = 32
    Top = 72
  end
  object FDPhysMongoDriverLink1: TFDPhysMongoDriverLink
    Left = 88
    Top = 144
  end
  object FDMongoQuery1: TFDMongoQuery
    FormatOptions.AssignedValues = [fvStrsTrim2Len]
    FormatOptions.StrsTrim2Len = True
    Connection = FDConnection1
    Left = 88
    Top = 24
  end
end
