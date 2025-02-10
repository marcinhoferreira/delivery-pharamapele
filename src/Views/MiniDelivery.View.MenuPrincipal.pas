unit MiniDelivery.View.MenuPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.Controls.Presentation, FMX.MultiView, FMX.Objects, FMX.ListBox,
  FMX.StdCtrls,
  FMX.MultiView.CustomPresentation, System.ImageList, FMX.ImgList,
  FireDAC.UI.Intf, FireDAC.FMXUI.Wait, FireDAC.Stan.Intf, FireDAC.Comp.UI;

type
  TfrmMenuPrincipal = class(TForm)
    lytWorkArea: TLayout;
    mvwMenuPrincipal: TMultiView;
    recMenuPrincipal: TRectangle;
    recTituloMenuPrincipal: TRectangle;
    lblTituloMenuPrincipal: TLabel;
    lstMenuPrincipal: TListBox;
    lbiCriarPedido: TListBoxItem;
    lbiOrdemEntrega: TListBoxItem;
    lbiAcompanharEntrega: TListBoxItem;
    imglstMenuPrincipal: TImageList;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    procedure FormCreate(Sender: TObject);
    procedure lbiCriarPedidoClick(Sender: TObject);
    procedure lbiOrdemEntregaClick(Sender: TObject);
    procedure lbiAcompanharEntregaClick(Sender: TObject);
  private
    { Private declarations }
    fActiveForm: TForm;
  public
    { Public declarations }
    procedure SetActiveForm(const Value: TForm);
    procedure OpenForm(const AFormClass: TComponentClass);
  end;

var
  frmMenuPrincipal: TfrmMenuPrincipal;

implementation

uses
   MiniDelivery.View.Pedido,
   MiniDelivery.View.CriarOrdemEntrega,
   MiniDelivery.View.AcompanharEntrega;

{$R *.fmx}

{ TfrmMenuPrincipal }

procedure TfrmMenuPrincipal.FormCreate(Sender: TObject);
begin
   Caption := Application.Title;

   mvwMenuPrincipal.CustomPresentationClass := TMultiViewAlertPresentation;
   mvwMenuPrincipal.Mode := TMultiViewMode.Drawer;

   { Modifica a largura do ListBox para a mesma do formulário, pois o mesmo está como Align = None }
   lstMenuPrincipal.Width := Self.ClientWidth;
   lstMenuPrincipal.Position.X := -Self.ClientWidth;

   // Traz para frente o layout principal evitando sobreposição de listas
   lytWorkArea.BringToFront;

   OpenForm(TfrmPedido);
end;

procedure TfrmMenuPrincipal.lbiAcompanharEntregaClick(Sender: TObject);
begin
   OpenForm(TfrmAcompanharEntrega);
end;

procedure TfrmMenuPrincipal.lbiCriarPedidoClick(Sender: TObject);
begin
   OpenForm(TfrmPedido);
end;

procedure TfrmMenuPrincipal.lbiOrdemEntregaClick(Sender: TObject);
begin
   OpenForm(TfrmCriarOrdemEntrega);
end;

procedure TfrmMenuPrincipal.OpenForm(const AFormClass: TComponentClass);
var
   ABaseLayout,
   AMenuButton: TComponent;
begin
   if Assigned(fActiveForm) then
      begin
         if fActiveForm.ClassType = AFormClass then
            Exit
         else
            begin
               fActiveForm.DisposeOf;
               fActiveForm := Nil;
            end;
      end;

   // Cria o formulário
   Application.CreateForm(AFormClass, fActiveForm);

   // Localiza o layout da área de trabalho, no formulário ativo
   ABaseLayout := fActiveForm.FindComponent('lytWorkArea');

   if Assigned(ABaseLayout) then
      lytWorkArea.AddObject(TLayout(ABaseLayout));

   // Localiza o botão acionador do Menu, no formulário ativo
   AMenuButton := fActiveForm.FindComponent('btnMenu');

   // Se o botão existir, este deverá controlar a abertura do Menu
   if Assigned(AMenuButton) then
      mvwMenuPrincipal.MasterButton := TControl(AMenuButton);

   mvwMenuPrincipal.HideMaster;
end;

procedure TfrmMenuPrincipal.SetActiveForm(const Value: TForm);
begin
   fActiveForm := Value;
end;

end.
