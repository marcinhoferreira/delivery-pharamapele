unit MiniDelivery.View.CriarOrdemEntrega;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  MiniDelivery.View.Padrao, FMX.Controls.Presentation, FMX.Layouts;

type
  TfrmCriarOrdemEntrega = class(TfrmPadrao)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCriarOrdemEntrega: TfrmCriarOrdemEntrega;

implementation

{$R *.fmx}

initialization
   RegisterClass(TfrmCriarOrdemEntrega);

finalization
   UnRegisterClass(TfrmCriarOrdemEntrega);

end.
