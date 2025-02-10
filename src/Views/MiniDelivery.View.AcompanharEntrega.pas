unit MiniDelivery.View.AcompanharEntrega;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  MiniDelivery.View.Padrao, MiniDelivery.Controller.Interfaces,
  MiniDelivery.Classe.Pedido, MiniDelivery.Classe.Entregador,
  FMX.Controls.Presentation, FMX.Layouts, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView,
  FMX.TabControl, FMX.Edit, FMX.ComboEdit, FMX.ListBox, Data.Bind.EngExt,
  Fmx.Bind.DBEngExt, System.Rtti, System.Bindings.Outputs, Data.Bind.Components,
  Data.Bind.DBScope, Data.DB, Data.Bind.Grid, FMX.Grid.Style, Fmx.Bind.Grid,
  Fmx.Bind.Editors, FMX.ScrollBox, FMX.Grid;

type
  TfrmAcompanharEntrega = class(TfrmPadrao)
    btnEditar: TSpeedButton;
    tabctrlPedidos: TTabControl;
    tabitmPedidos: TTabItem;
    tabitmDetalhes: TTabItem;
    lytPedidos: TLayout;
    lytDetalhes: TLayout;
    lytPedido: TLayout;
    lblNumeroPedido: TLabel;
    edtNumeroPedido: TEdit;
    lblSituacao: TLabel;
    edtSituacaoPedido: TEdit;
    lstvwItensPedido: TListView;
    lblNome: TLabel;
    edtNome: TEdit;
    lblEnderecoCep: TLabel;
    edtEnderecoCep: TEdit;
    lblEnderecoRua: TLabel;
    edtEnderecoRua: TEdit;
    lblEnderecoNumero: TLabel;
    edtEnderecoNumero: TEdit;
    lblEnderecoBairro: TLabel;
    edtEnderecoBairro: TEdit;
    cmbedtEnderecoPais: TComboEdit;
    lblEnderecoPais: TLabel;
    lblEnderecoEstado: TLabel;
    cmbedtEnderecoEstado: TComboEdit;
    lblEnderecoMunicipio: TLabel;
    cmbedtEnderecoMunicipio: TComboEdit;
    btnConfirmar: TSpeedButton;
    lblEntregador: TLabel;
    lblSituacaoEntrega: TLabel;
    cmbedtEntregador: TComboEdit;
    cmbSituacaoEntrega: TComboBox;
    lytToolBarDetalhes: TLayout;
    btnCancelar: TSpeedButton;
    BindingsList1: TBindingsList;
    dsPedidos: TDataSource;
    bsPedidos: TBindSourceDB;
    grdPedidos: TGrid;
    LinkGridToDataSource1: TLinkGridToDataSource;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnEditarClick(Sender: TObject);
    procedure tabctrlPedidosChange(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnConfirmarClick(Sender: TObject);
  private
    { Private declarations }
    fController: IController;
    fPedido: TPedido;
    fListaPedidos: TListaPedidos;
    fListaEntregadores: TListaEntregadores;
    procedure CarregaListaPedidos;
    procedure CarregaListaEntregadores;
    procedure CarregaListaItensPedido;
    procedure DetalhaPedido;
    procedure StatusOnGetText(Sender: TField; var Text: string; DisplayText: Boolean);
    procedure StatusEntregaOnGetText(Sender: TField; var Text: string; DisplayText: Boolean);
  public
    { Public declarations }
  end;

var
  frmAcompanharEntrega: TfrmAcompanharEntrega;

implementation

uses
   MiniDelivery.Controller,
   MiniDelivery.Model.Entidades.Pedido,
   MiniDelivery.Model.Entidades.ItemPedido,
   MiniDelivery.Model.Entidades.Entregador;

{$R *.fmx}

procedure TfrmAcompanharEntrega.btnCancelarClick(Sender: TObject);
begin
  inherited;
   tabctrlPedidos.ActiveTab := tabitmPedidos;
end;

procedure TfrmAcompanharEntrega.btnConfirmarClick(Sender: TObject);
var
   AEntregador: TEntregador;
begin
  inherited;
   if cmbedtEntregador.Text <> '' then
      begin
         for AEntregador in fListaEntregadores.Items do
            if AEntregador.Nome = cmbedtEntregador.Text then
               begin
                  fPedido.Entregador := AEntregador;
                  Break;
               end;
      end;
  fPedido.StatusEntrega := TStatusEntrega(cmbSituacaoEntrega.ItemIndex);
  TModelEntidadePedido(fController.Entidades.Pedido).GravaPedido(fPedido);
  CarregaListaPedidos;
  tabctrlPedidos.ActiveTab := tabitmPedidos;
end;

procedure TfrmAcompanharEntrega.btnEditarClick(Sender: TObject);
begin
  inherited;
   with bsPedidos do
      fPedido := TModelEntidadePedido(fController
         .Entidades
            .Pedido)
               .GetPedido(DataSet
                  .FieldByName('id').AsInteger);

   fListaEntregadores := TModelEntidadeEntregador(fController.Entidades.Entregador).GetEntregadores;
   DetalhaPedido;
end;

procedure TfrmAcompanharEntrega.CarregaListaEntregadores;
var
   AEntregador: TEntregador;
begin
   cmbedtEntregador.BeginUpdate;
   cmbedtEntregador.Items.Clear;
   for AEntregador in fListaEntregadores.Items do
      begin
         cmbedtEntregador.Items.AddObject(AEntregador.Nome, TObject(AEntregador.Id));
      end;
   cmbedtEntregador.EndUpdate;
end;

procedure TfrmAcompanharEntrega.CarregaListaItensPedido;
   procedure AddHeaderItensPedido;
   var
     AItemHeader: TListViewItem;
   begin
     AItemHeader := lstvwItensPedido.Items.Add;
     AItemHeader.Purpose := TListItemPurpose.Header;
     AItemHeader.Text := 'ITENS DO PEDIDO';
   end;
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

procedure TfrmAcompanharEntrega.CarregaListaPedidos;
begin
   fListaPedidos := TModelEntidadePedido(fController.Entidades.Pedido).GetPedidosEntrega;

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

procedure TfrmAcompanharEntrega.DetalhaPedido;
begin
   edtNumeroPedido.Text := IntToStr(fPedido.Id);
   edtNome.Text := fPedido.Nome;
   edtEnderecoCep.Text := fPedido.Endereco.Cep;
   edtEnderecoRua.Text := fPedido.Endereco.Rua;
   edtEnderecoNumero.Text := fPedido.Endereco.Numero;
   edtEnderecoBairro.Text := fPedido.Endereco.Bairro;
   cmbedtEnderecoPais.Text := fPedido.Endereco.Municipio.Estado.Pais.Nome;
   cmbedtEnderecoEstado.Text := fPedido.Endereco.Municipio.Estado.Nome;
   cmbedtEnderecoMunicipio.Text := fPedido.Endereco.Municipio.Nome;
   if fPedido.Status = TStatus.stDigitacao then
      edtSituacaoPedido.Text := 'Em digitação'
   else if fPedido.Status = TStatus.stFinalizado then
           edtSituacaoPedido.Text := 'Finalizado';
   cmbedtEntregador.Text := fPedido.Entregador.Nome;
   if fPedido.StatusEntrega = TStatusEntrega.sePendente then
      cmbSituacaoEntrega.ItemIndex := 0
   else if fPedido.StatusEntrega = TStatusEntrega.seEmAndamento then
           cmbSituacaoEntrega.ItemIndex := 1
   else if fPedido.StatusEntrega = TStatusEntrega.seEntregue then
           cmbSituacaoEntrega.ItemIndex := 2;
   CarregaListaItensPedido;
   tabctrlPedidos.ActiveTab := tabitmDetalhes;
end;

procedure TfrmAcompanharEntrega.FormCreate(Sender: TObject);
begin
  inherited;
   tabctrlPedidos.TabPosition := TTabPosition.None;
   tabctrlPedidos.ActiveTab := tabitmPedidos;
   fController := TController.New;
   fListaPedidos := TListaPedidos.Create;
   fListaEntregadores := TListaEntregadores.Create;
   fPedido := TPedido.Create;
   CarregaListaPedidos;
end;

procedure TfrmAcompanharEntrega.FormDestroy(Sender: TObject);
begin
  inherited;
   with dsPedidos do
      begin
         if DataSet.Active then
            DataSet.Close;
      end;
   FreeAndNil(fListaEntregadores);
   FreeAndNil(fListaPedidos);
   FreeAndNil(fPedido);
end;

procedure TfrmAcompanharEntrega.StatusEntregaOnGetText(Sender: TField;
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

procedure TfrmAcompanharEntrega.StatusOnGetText(Sender: TField;
  var Text: string; DisplayText: Boolean);
begin
   case Sender.AsInteger of
      1: Text := 'Em digitação';
      2: Text := 'Finalizado';
      else
         Text := 'Desconhecido';
   end;
end;

procedure TfrmAcompanharEntrega.tabctrlPedidosChange(Sender: TObject);
begin
  inherited;
   btnEditar.Visible := TTabControl(Sender).ActiveTab = tabitmPedidos;
   lytToolBarDetalhes.Visible := TTabControl(Sender).ActiveTab = tabitmDetalhes;
   if TTabControl(Sender).ActiveTab = tabitmDetalhes then
      CarregaListaEntregadores;
end;

initialization
   RegisterClass(TfrmAcompanharEntrega);

finalization
   UnRegisterClass(TfrmAcompanharEntrega);

end.
