unit MiniDelivery.View.CriarOrdemEntrega;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  MiniDelivery.View.Padrao, FMX.Controls.Presentation, FMX.Layouts,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView, FMX.TabControl, FMX.Edit, FMX.ComboEdit,
  MiniDelivery.Controller.Interfaces,
  MiniDelivery.Classe.Pedido, MiniDelivery.Classe.Entregador;

type
  TfrmCriarOrdemEntrega = class(TfrmPadrao)
    lstvwPedidos: TListView;
    tabctrlPedidos: TTabControl;
    tabitmPedidos: TTabItem;
    tabitmDetalhes: TTabItem;
    lytPedidos: TLayout;
    lytDetalhes: TLayout;
    lblNumeroPedido: TLabel;
    edtNumeroPedido: TEdit;
    lblSituacao: TLabel;
    edtSituacaoPedido: TEdit;
    lblNome: TLabel;
    edtNome: TEdit;
    lytPedidoDetalhes: TLayout;
    lstvwItensPedido: TListView;
    lblEntregador: TLabel;
    cmbedtEntregador: TComboEdit;
    btnConfirma: TButton;
    procedure FormCreate(Sender: TObject);
    procedure lstvwPedidosItemClick(const Sender: TObject;
      const AItem: TListViewItem);
    procedure btnConfirmaClick(Sender: TObject);
  private
    { Private declarations }
    fController: IController;
    fPedido: TPedido;
    procedure CarregaListaPedidos;
    procedure CarregaDetalhesPedido;
    procedure AddHeaderItensPedido;
    procedure CarregaListaItensPedido(const APedidoId: Integer);
    procedure CarregaEntregadores;
  public
    { Public declarations }
  end;

var
  frmCriarOrdemEntrega: TfrmCriarOrdemEntrega;

implementation

uses
   MiniDelivery.Libraries,
   MiniDelivery.Controller,
   MiniDelivery.Model.Entidades.Pedido,
   MiniDelivery.Model.Entidades.ItemPedido,
   MiniDelivery.Model.Entidades.Entregador;

{$R *.fmx}

{ TfrmCriarOrdemEntrega }

procedure TfrmCriarOrdemEntrega.AddHeaderItensPedido;
var
  AItemHeader: TListViewItem;
begin
  AItemHeader := lstvwItensPedido.Items.Add;
  AItemHeader.Purpose := TListItemPurpose.Header;
  AItemHeader.Text := 'ITENS DO PEDIDO';
end;

procedure TfrmCriarOrdemEntrega.btnConfirmaClick(Sender: TObject);
var
   AEntregadorId: Integer;
   AEntregador: TEntregador;
begin
  inherited;
   if cmbedtEntregador.ItemIndex < 0 then
      begin
         ShowMessage('Selecione o entredagor do pedido!');
         DeLayedSetFocus(cmbedtEntregador);
         Exit;
      end;

   if MessageDlg('Confirma Entregador do Pedido?', TMsgDlgType.mtConfirmation,
                  [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], 0,
                  TMsgDlgBtn.mbYes) = mrYes then
      begin
         AEntregador := TEntregador.Create;
         try
            AEntregadorId := Integer(cmbedtEntregador.Items.Objects[cmbedtEntregador.ItemIndex]);
            AEntregador := TModelEntidadeEntregador(fController.Entidades.Entregador).GetEntregador(AEntregadorId);
            TModelEntidadePedido(fController.Entidades.Pedido).AtribuiEntregador(fPedido.Id, AEntregador);
            CarregaListaPedidos;
            tabctrlPedidos.ActiveTab := tabitmPedidos;
         finally
            FreeAndNil(AEntregador);
         end;
      end;
end;

procedure TfrmCriarOrdemEntrega.CarregaDetalhesPedido;
begin
   edtNumeroPedido.Text := fPedido.Id.ToString;
   edtNome.Text := fPedido.Nome;
   edtSituacaoPedido.Text := fPedido.Situacao;
end;

procedure TfrmCriarOrdemEntrega.CarregaEntregadores;
var
   AEntregador: TEntregador;
   AListaEntregadores: TListaEntregadores;
begin
   AListaEntregadores := TListaEntregadores.Create;
   try
      cmbedtEntregador.BeginUpdate;
      cmbedtEntregador.Items.Clear;
      AListaEntregadores := TModelEntidadeEntregador(fController.Entidades.Entregador).GetEntregadores;
      for AEntregador in AListaEntregadores.Items do
         begin
            cmbedtEntregador.Items.AddObject(AEntregador.Nome, TObject(AEntregador.Id));
         end;
      cmbedtEntregador.EndUpdate;
   finally
      FreeAndNil(AListaEntregadores);
   end;
end;

procedure TfrmCriarOrdemEntrega.CarregaListaItensPedido(
  const APedidoId: Integer);
var
   AItemPedido: TItemPedido;
   AItensPedido: TItensPedido;
   AItem: TListViewItem;
begin
   AItensPedido := TItensPedido.Create;
   try
      AItensPedido := TModelEntidadeItemPedido(fController
         .Entidades
            .ItemPedido)
               .GetItensPedido(APedidoId);
      lstvwItensPedido.BeginUpdate;
      lstvwItensPedido.Items.Clear;
      AddHeaderItensPedido;
      for AItemPedido in AItensPedido.Items do
         begin
            AItem := lstvwItensPedido.Items.Add;
            with AItem do
               begin
                  TListItemText(Objects.FindDrawable('txtItemPedidoCodigo')).Text := AItemPedido.Produto.Codigo;
                  TListItemText(Objects.FindDrawable('txtItemPedidoNome')).Text := AItemPedido.Produto.Nome;
                  TListItemText(Objects.FindDrawable('txtItemPedidoQuantidade')).Text := Format('%15.3f', [AItemPedido.Quantidade]);
                  TListItemText(Objects.FindDrawable('txtItemPedidoArmazenamento')).Visible := AItemPedido.Produto.Sensivel;
                  if AItemPedido.Produto.Sensivel then
                     begin
                        TListItemText(Objects.FindDrawable('txtItemPedidoArmazenamento')).Text := 'Condições de armazenamento: ' + AItemPedido.Produto.Armazenamento;
                        TListItemText(Objects.FindDrawable('txtItemPedidoArmazenamento')).Font.Style := [TFontStyle.fsBold];
                        Height := 50;
                     end
                  else
                     Height := 25;
                  Tag := AItemPedido.Produto.Id;
               end;
         end;
      lstvwItensPedido.AlternatingColors := True;
      lstvwItensPedido.EndUpdate;
   finally
      FreeAndNil(AItensPedido);
   end;
end;

procedure TfrmCriarOrdemEntrega.CarregaListaPedidos;
var
   APedido: TPedido;
   AListaPedidos: TListaPedidos;
   AItem: TListViewItem;
begin
   AListaPedidos := TListaPedidos.Create;
   try
      AListaPedidos := TModelEntidadePedido(fController.Entidades.Pedido).GetPedidos(2);
      lstvwPedidos.BeginUpdate;
      lstvwPedidos.Items.Clear;
      for APedido in AListaPedidos.Items do
         begin
            AItem := lstvwPedidos.Items.Add;
            with AItem do
               begin
                  TListItemText(Objects.FindDrawable('txtPedidoNumero')).Text := APedido.Id.ToString;
                  TListItemText(Objects.FindDrawable('txtPedidoNome')).Text := APedido.Nome;
                  TListItemText(Objects.FindDrawable('txtPedidoSituacao')).Text := APedido.Situacao;
                  Tag := APedido.Id;
               end;
         end;
      lstvwPedidos.AlternatingColors := True;
      lstvwPedidos.EndUpdate;
   finally
      FreeAndNil(AListaPedidos);
   end;
end;

procedure TfrmCriarOrdemEntrega.FormCreate(Sender: TObject);
begin
  inherited;
   tabctrlPedidos.TabPosition := TTabPosition.None;
   tabctrlPedidos.ActiveTab := tabitmPedidos;
   fController := TController.New;
   CarregaListaPedidos;
   CarregaEntregadores;
end;

procedure TfrmCriarOrdemEntrega.lstvwPedidosItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
  inherited;
   fPedido := TModelEntidadePedido(fController.Entidades.Pedido).GetPedido(AItem.Tag);
   CarregaDetalhesPedido;
   CarregaListaItensPedido(AItem.Tag);
   tabctrlPedidos.ActiveTab := tabitmDetalhes;
end;

initialization
   RegisterClass(TfrmCriarOrdemEntrega);

finalization
   UnRegisterClass(TfrmCriarOrdemEntrega);

end.
