unit MiniDelivery.View.AcompanharEntrega;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  MiniDelivery.View.Padrao, FMX.Controls.Presentation, FMX.Layouts;

type
  TfrmAcompanharEntrega = class(TfrmPadrao)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAcompanharEntrega: TfrmAcompanharEntrega;

implementation

{$R *.fmx}

initialization
   RegisterClass(TfrmAcompanharEntrega);

finalization
   UnRegisterClass(TfrmAcompanharEntrega);

end.
