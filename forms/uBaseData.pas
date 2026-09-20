unit uBaseData;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.TabControl, FMX.Controls.Presentation, FMX.StdCtrls,
  FMX.Layouts, FMX.ScrollBox, FMX.Memo, FMX.Edit, FMX.Memo.Types,
  Data.DB, Data.Bind.Components, Data.Bind.DBScope, Data.Bind.EngExt,
  FMX.Bind.DBEngExt, FMX.Bind.Editors, Data.Bind.Controls,
  FMX.Bind.Navigator, System.Bindings.Outputs, System.Actions,
  FMX.ActnList;

type
  TfBaseData = class(TForm)
    tcMain: TTabControl;
    tbTherapists: TTabItem;
    btnClose: TButton;
    // --- Therapist fields ---
    lblFName: TLabel;
    eFName: TEdit;
    lblLName: TLabel;
    eLName: TEdit;
    lblPhone: TLabel;
    ePhone: TEdit;
    lblBirth: TLabel;
    eBirthYear: TEdit;
    eBirthMonth: TEdit;
    eBirthDay: TEdit;
    lblAddress: TLabel;
    mAddress: TMemo;
    // --- Navigator & bindings ---
    NavigatorTherapists: TBindNavigator;
    BindSourceTherapists: TBindSourceDB;
    BindingsList1: TBindingsList;
    ActionList1: TActionList;
    actInsert: TFMXBindNavigateInsert;
    actDelete: TFMXBindNavigateDelete;
    actEdit: TFMXBindNavigateEdit;
    actPost: TFMXBindNavigatePost;
    actCancel: TFMXBindNavigateCancel;
    // --- Buttons ---
    btnAdd: TButton;
    btnEdit: TButton;
    btnSave: TButton;
    btnDelete: TButton;
    btnCancel: TButton;
    // --- LiveBinding links ---
    lnkFName: TLinkControlToField;
    lnkLName: TLinkControlToField;
    lnkPhone: TLinkControlToField;
    lnkBirthYear: TLinkControlToField;
    lnkBirthMonth: TLinkControlToField;
    lnkBirthDay: TLinkControlToField;
    lnkAddress: TLinkControlToField;
    dsTherapists: TDataSource;
    procedure FormCreate(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure dsTherapistsStateChange(Sender: TObject);
  private
    procedure SetInputsEnabled(AEnabled: Boolean);
  end;

var
  fBaseData: TfBaseData;

implementation

{$R *.fmx}

uses dmBaseData, dmServer, dmTherapy;

procedure TfBaseData.FormCreate(Sender: TObject);
begin
  dmBaseData_ := TdmBaseData.Create(Self);
  BindSourceTherapists.DataSet := dmBaseData_.fQryTherapists;
  dsTherapists.DataSet         := dmBaseData_.fQryTherapists;
  SetInputsEnabled(False);
end;

procedure TfBaseData.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfBaseData.dsTherapistsStateChange(Sender: TObject);
begin
  if dsTherapists.State = dsBrowse then
  begin
    dmTherapy_.fQryTherapists.Close;
    dmTherapy_.fQryTherapists.Open;
  end;
  SetInputsEnabled(dsTherapists.State in [dsEdit, dsInsert]);
end;

procedure TfBaseData.SetInputsEnabled(AEnabled: Boolean);
begin
  eFName.Enabled      := AEnabled;
  eLName.Enabled      := AEnabled;
  ePhone.Enabled      := AEnabled;
  eBirthYear.Enabled  := AEnabled;
  eBirthMonth.Enabled := AEnabled;
  eBirthDay.Enabled   := AEnabled;
  mAddress.Enabled    := AEnabled;
end;

end.
