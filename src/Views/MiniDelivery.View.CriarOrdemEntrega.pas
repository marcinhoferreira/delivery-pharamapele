unit MiniDelivery.View.CriarOrdemEntrega;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  MiniDelivery.View.Padrao, FMX.Controls.Presentation, FMX.Layouts,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView, FMX.TabControl, FMX.Edit, FMX.ComboEdit,
  MiniDelivery.Controller.Interfaces,
  MiniDelivery.Classe.Pedido, MiniDelivery.Classe.Entregador, Data.Bind.EngExt,
  Fmx.Bind.DBEngExt, System.Rtti, System.Bindings.Outputs, Data.Bind.Components,
  Data.Bind.DBScope, Data.DB, Data.Bind.Grid, Fmx.Bind.Grid, Fmx.Bind.Editors,
  FMX.Grid.Style, FMX.ScrollBox, FMX.Grid;

type
  TfrmCriarOrdemEntrega = class(TfrmPadrao)
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
    btnEditar: TSpeedButton;
    lytToolBarConfirmacao: TLayout;
    btnConfirmar: TSpeedButton;
    btnCancelar: TSpeedButton;
    BindingsList1: TBindingsList;
    LinkGridToDataSource1: TLinkGridToDataSource;
    dsPedidos: TDataSource;
    bsPedidos: TBindSourceDB;
    grdPedidos: TGrid;
    procedure FormCreate(Sender: TObject);
    procedure btnEditarClick(Sender: TObject);
    procedure tabctrlPedidosChange(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnConfirmarClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    fController: IController;
    fPedido: TPedido;
    fListaPedidos: TListaPedidos;
    procedure CarregaListaPedidos;
    procedure CarregaDetalhesPedido;
    procedure AddHeaderItensPedido;
    procedure CarregaListaItensPedido;
    procedure CarregaEntregadores;
    procedure StatusOnGetText(Sender: TField; var Text: string; DisplayText: Boolean);
    procedure StatusEntregaOnGetText(Sender: TField; var Text: string; DisplayText: Boolean);
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

procedure TfrmCriarOrdemEntrega.btnConfirmarClick(Sender: TObject);
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

procedure TfrmCriarOrdemEntrega.btnEditarClick(Sender: TObject);
begin
  inherited;
   with dsPedidos do
      fPedido := TModelEntidadePedido(fController
         .Entidades
            .Pedido)
               .GetPedido(DataSet
                  .FieldByName('id').AsInteger);
   CarregaDetalhesPedido;
   CarregaListaItensPedido;
   tabctrlPedidos.ActiveTab := tabitmDetalhes;
end;

procedure TfrmCriarOrdemEntrega.CarregaDetalhesPedido;
begin
   edtNumeroPedido.Text := fPedido.Id.ToString;
   edtNome.Text := fPedido.Nome;
   if fPedido.Status = TStatus.stDigitacao then
      edtSituacaoPedido.Text := 'Em digitação'
   else if fPedido.Status = TStatus.stFinalizado then
           edtSituacaoPedido.Text := 'Finalizado';
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

procedure TfrmCriarOrdemEntrega.CarregaListaItensPedido;
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
               .GetItensPedido(fPedido.Id);
      lstvwItensPedido.BeginUpdate;
      lstvwItensPedido.Items.Clear;
      AddHeaderItensPedido;
      for AItemPedido in AItensPedido.Items do
         begin
            AItem := lstvwItensPedido.Items.Add;
            with AItem do
               begin
                  Tag := AItemPedido.Produto.Id;
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
               end;
         end;
      lstvwItensPedido.EndUpdate;
   finally
      FreeAndNil(AItensPedido);
   end;
end;

procedure TfrmCriarOrdemEntrega.CarregaListaPedidos;
begin
   fListaPedidos := TModelEntidadePedido(fController.Entidades.Pedido).GetPedidos(TStatus.stFinalizado);

   fController
      .Entidades
         .Pedido
            .DataSet(dsPedidos)
               .Open('WHERE status = 2');

   with bsPedidos do
      begin
         DataSet.FieldByName('status').OnGetText := StatusOnGetText;
         DataSet.FieldByName('status_entrega').OnGetText := StatusEntregaOnGetText;
      end;
end;

procedure TfrmCriarOrdemEntrega.FormCreate(Sender: TObject);
begin
  inherited;
   tabctrlPedidos.TabPosition := TTabPosition.None;
   tabctrlPedidos.ActiveTab := tabitmPedidos;
   fController := TController.New;
   fListaPedidos := TListaPedidos.Create;
   fPedido := TPedido.Create;
   CarregaListaPedidos;
   CarregaEntregadores;
end;

procedure TfrmCriarOrdemEntrega.FormDestroy(Sender: TObject);
begin
  inherited;
   with dsPedidos do
      if DataSet.Active then
         DataSet.Close;
   FreeAndNil(fListaPedidos);
   FreeAndNil(fPedido);
end;

procedure TfrmCriarOrdemEntrega.StatusEntregaOnGetText(Sender: TField;
  var Text: string; DisplayText: Boolean);
begin
   case Sender.AsInteger of
      1: Text := 'Pendente';
      2: Text := 'Em andamento';
      3: Text := 'Entregue';
      else
         Text := 'Desconhecido';
   end;
end;

procedure TfrmCriarOrdemEntrega.StatusOnGetText(Sender: TField;
  var Text: string; DisplayText: Boolean);
begin
   case Sender.AsInteger of
      1: Text := 'Em digitação';
      2: Text := 'Finalizado';
      else
         Text := 'Desconhecido';
   end;
end;

procedure TfrmCriarOrdemEntrega.btnCancelarClick(Sender: TObject);
begin
  inherited;
   CarregaListaPedidos;
   tabctrlPedidos.ActiveTab := tabitmPedidos;
end;

procedure TfrmCriarOrdemEntrega.tabctrlPedidosChange(Sender: TObject);
begin
  inherited;
   btnEditar.Visible := TTabControl(Sender).ActiveTab = tabitmPedidos;
   lytToolBarConfirmacao.Visible := TTabControl(Sender).ActiveTab = tabitmDetalhes;
end;

initialization
   RegisterClass(TfrmCriarOrdemEntrega);

finalization
   UnRegisterClass(TfrmCriarOrdemEntrega);

end.
