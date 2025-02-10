unit MiniDelivery.View.Pedido;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  MiniDelivery.View.Padrao, FMX.Controls.Presentation, FMX.Layouts,
  MiniDelivery.Controller.Interfaces,
  MiniDelivery.Classe.Produto, MiniDelivery.Classe.Pedido,
  Data.DB, Data.Bind.Components, Data.Bind.DBScope, FMX.Edit, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView,
  Data.Bind.EngExt, Fmx.Bind.DBEngExt, FMX.EditBox, FMX.NumberBox,
  FMX.TabControl, FMX.ListBox, FMX.ComboEdit, FMX.Objects, System.Rtti,
  FMX.Grid.Style, FMX.ScrollBox, FMX.Grid, Fmx.Bind.Grid,
  System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.Grid;

type
  TfrmPedido = class(TfrmPadrao)
    lstvwItensPedido: TListView;
    lytPedido: TLayout;
    chkProdutoControlado: TCheckBox;
    chkProdutoSensivel: TCheckBox;
    edProdutoArmazenamnto: TEdit;
    edtCodigo: TEdit;
    edtProdutoNome: TEdit;
    edtTipo: TEdit;
    lblCodigo: TLabel;
    lblProdutoArmazenamento: TLabel;
    lblProdutoNome: TLabel;
    lblQuantidade: TLabel;
    lblTipo: TLabel;
    nbQuantidade: TNumberBox;
    btnFinalizar: TSpeedButton;
    tabctrlPedido: TTabControl;
    tabitmDetalhes: TTabItem;
    tabitmEntrega: TTabItem;
    lytEntrega: TLayout;
    lblNome: TLabel;
    edtNome: TEdit;
    edtEnderecoCep: TEdit;
    lblEnderecoCep: TLabel;
    lblEnderecoRua: TLabel;
    edtEnderecoRua: TEdit;
    lblEnderecoNumero: TLabel;
    edtEnderecoNumero: TEdit;
    edtEnderecoBairro: TEdit;
    lblEnderecoBairro: TLabel;
    lblEnderecoPais: TLabel;
    lblEnderecoEstado: TLabel;
    lblEnderecoMunicipio: TLabel;
    cmbedtEnderecoPais: TComboEdit;
    cmbedtEnderecoEstado: TComboEdit;
    cmbedtEnderecoMunicipio: TComboEdit;
    lytToolBarConfirmacao: TLayout;
    btnConfirmar: TSpeedButton;
    btnCancelar: TSpeedButton;
    recInformacoes: TRectangle;
    lblTextoInformacoes: TLabel;
    tabitmPedidos: TTabItem;
    lytPedidos: TLayout;
    lytItens: TLayout;
    btnNovo: TSpeedButton;
    edtSituacaoPedido: TEdit;
    lblSituacao: TLabel;
    lblNumeroPedido: TLabel;
    edtNumeroPedido: TEdit;
    btnVoltar: TSpeedButton;
    lytToolBarDetalhes: TLayout;
    grdPedidos: TGrid;
    dsPedidos: TDataSource;
    bsPedidos: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkGridToDataSource1: TLinkGridToDataSource;
    lytToolBarPedidos: TLayout;
    btnEditar: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure edtCodigoKeyDown(Sender: TObject; var Key: Word;
      var KeyChar: WideChar; Shift: TShiftState);
    procedure edtCodigoChange(Sender: TObject);
    procedure edtCodigoEnter(Sender: TObject);
    procedure nbQuantidadeKeyDown(Sender: TObject; var Key: Word;
      var KeyChar: WideChar; Shift: TShiftState);
    procedure btnFinalizarClick(Sender: TObject);
    procedure tabctrlPedidoChange(Sender: TObject);
    procedure cmbedtEnderecoPaisChange(Sender: TObject);
    procedure cmbedtEnderecoEstadoChange(Sender: TObject);
    procedure btnConfirmarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure lstvwItensPedidoKeyDown(Sender: TObject; var Key: Word;
      var KeyChar: WideChar; Shift: TShiftState);
    procedure FormDestroy(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure btnVoltarClick(Sender: TObject);
    procedure btnEditarClick(Sender: TObject);
  private
    { Private declarations }
    fController: IController;
    fProduto: TProduto;
    fPedido: TPedido;
    fListaPedidos: TListaPedidos;
    procedure CarregaListaPedidos;
    procedure ControlesVisiveis(const Visivel: Boolean);
    procedure CarregaListaPaises;
    procedure CarregaListaEstados(const APaisId: Integer);
    procedure CarregaListaMunicipios(const AEstadoId: Integer);
    procedure Inicializa;
    function ValidaDadosPedido: Boolean;
    procedure DetalhaPedido;
    procedure CarregaListaItensPedido(const APedidoId: Integer);
    procedure HabilitaControles(const Habilita: Boolean = True);
    procedure DeletaItemPedido(const APedidoId: Integer; const AProdutoId: Integer);
    procedure StatusOnGetText(Sender: TField; var Text: string; DisplayText: Boolean);
    procedure StatusEntregaOnGetText(Sender: TField; var Text: string; DisplayText: Boolean);
  public
    { Public declarations }
  end;

var
  frmPedido: TfrmPedido;

implementation

uses
   MiniDelivery.Libraries,
   MiniDelivery.Classe.Endereco,
   MiniDelivery.Model.Entidades.Pais,
   MiniDelivery.Model.Entidades.Estado,
   MiniDelivery.Model.Entidades.Municipio,
   MiniDelivery.Model.Entidades.Produto,
   MiniDelivery.Model.Entidades.Pedido,
   MiniDelivery.Model.Entidades.ItemPedido,
   MiniDelivery.Controller;

{$R *.fmx}

{ TfrmCriarPedido }

procedure TfrmPedido.btnFinalizarClick(Sender: TObject);
begin
  inherited;
   if lstvwItensPedido.ItemCount = 0 then
      begin
         ShowMessage('Pedido ainda não possui nenhum item registrado!');
         Exit;
      end;
   tabctrlPedido.ActiveTab := tabitmEntrega;
   lytToolBarDetalhes.Visible := False;
   lytToolBarConfirmacao.Visible :=  True;
end;

procedure TfrmPedido.btnNovoClick(Sender: TObject);
begin
  inherited;
   fPedido := TModelEntidadePedido(fController.Entidades.Pedido).CriaPedido;
   DetalhaPedido;
end;

procedure TfrmPedido.btnVoltarClick(Sender: TObject);
begin
  inherited;
   tabctrlPedido.ActiveTab := tabitmPedidos;
end;

procedure TfrmPedido.edtCodigoChange(Sender: TObject);
begin
  inherited;
   if TEdit(Sender).Text = '' then
      ControlesVisiveis(False);
end;

procedure TfrmPedido.edtCodigoEnter(Sender: TObject);
begin
  inherited;
   TEdit(Sender).Text := '';
end;

procedure TfrmPedido.edtCodigoKeyDown(Sender: TObject;
  var Key: Word; var KeyChar: WideChar; Shift: TShiftState);
var
   AEncontrou: Boolean;
begin
  inherited;
   if Key = vkReturn then
      begin
         if Trim(TEdit(Sender).Text) <> '' then
            begin
               fProduto := TModelEntidadeProduto(fController
                  .Entidades
                     .Produto)
                        .GetProduto(TEdit(Sender).Text);
               AEncontrou := fProduto.Id > 0;
               if not AEncontrou then
                  begin
                     ShowMessage('Produto não Encontrado!');
                     Exit;
                  end;

               edtProdutoNome.Text := fProduto.Nome;
               edtTipo.Text := fProduto.Tipo.Descricao;
               chkProdutoControlado.IsChecked := fProduto.Controlado;
               chkProdutoSensivel.IsChecked := fProduto.Sensivel;
               edProdutoArmazenamnto.Text := fProduto.Armazenamento;
               ControlesVisiveis(AEncontrou);
               lblProdutoArmazenamento.Visible := chkProdutoSensivel.IsChecked;
               edProdutoArmazenamnto.Visible := chkProdutoSensivel.IsChecked;
               DeLayedSetFocus(nbQuantidade);
            end;
      end;
end;

procedure TfrmPedido.FormCreate(Sender: TObject);
begin
  inherited;
   tabctrlPedido.TabPosition := TTabPosition.None;
   tabctrlPedido.ActiveTab := tabitmPedidos;
   fController := TController.New;
   fListaPedidos := TListaPedidos.Create;
   CarregaListaPedidos;
   fPedido := TPedido.Create;
   fProduto := TProduto.Create;
   Inicializa;
   CarregaListaPaises;
   CarregaListaEstados(0);
   CarregaListaMunicipios(0);
end;

procedure TfrmPedido.FormDestroy(Sender: TObject);
begin
  inherited;
   with dsPedidos do
      if DataSet.Active then
         DataSet.Close;
   FreeAndNil(fProduto);
   FreeAndNil(fListaPedidos);
   FreeAndNil(fPedido);
end;

procedure TfrmPedido.HabilitaControles(const Habilita: Boolean);
begin
   edtCodigo.Enabled := Habilita;
end;

procedure TfrmPedido.Inicializa;
begin
   lytToolBarPedidos.Visible := True;
   lytToolBarDetalhes.Visible := False;
   lytToolBarConfirmacao.Visible := False;
end;

procedure TfrmPedido.lstvwItensPedidoKeyDown(Sender: TObject;
  var Key: Word; var KeyChar: WideChar; Shift: TShiftState);
begin
  inherited;
   if Key = vkDelete then
      DeletaItemPedido(fPedido.Id, TListView(Sender).Selected.Tag);
end;

procedure TfrmPedido.nbQuantidadeKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: WideChar; Shift: TShiftState);
var
   AAnotacoes: String;
begin
  inherited;
   if Key = vkReturn then
      begin
         if fProduto.Controlado Or fProduto.Sensivel then
            begin
               AAnotacoes := InputBox('Informações Específicas',
                                      'Este produto requer informações específicas',
                                      '');
               if Trim(AAnotacoes) = '' then
                  begin
                     MessageDlg('Registre as informações específicas para o produto', TMsgDlgType.mtError, [TMsgDlgBtn.mbOK], 0);
                     Exit;
                  end;
            end;

         TModelEntidadeItemPedido(fController
            .Entidades
               .ItemPedido)
            .RegistraItemPedido(fPedido.Id, fProduto, nbQuantidade.Value, '');

         CarregaListaItensPedido(fPedido.Id);

         DeLayedSetFocus(edtCodigo);
      end;
end;

procedure TfrmPedido.StatusEntregaOnGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
   case Sender.AsInteger of
      1: Text := 'Pendente';
      2: Text := 'Em andamento';
      3: Text := 'Entregue';
      else
         Text := 'Desconhecido';
   end;
end;

procedure TfrmPedido.StatusOnGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
   case Sender.AsInteger of
      1: Text := 'Em digitação';
      2: Text := 'Finalizado';
      else
         Text := 'Desconhecido';
   end;
end;

procedure TfrmPedido.btnCancelarClick(Sender: TObject);
begin
  inherited;
   tabctrlPedido.ActiveTab := tabitmDetalhes;
end;

procedure TfrmPedido.btnConfirmarClick(Sender: TObject);
var
   AMunicipioId: Integer;
begin
  inherited;
   if not ValidaDadosPedido then
      Exit;

   if MessageDlg('Confirma Finalização do Pedido?', TMsgDlgType.mtConfirmation,
                  [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], 0,
                  TMsgDlgBtn.mbYes) = mrYes then
      begin
         AMunicipioId := Integer(cmbedtEnderecoMunicipio.Items.Objects[cmbedtEnderecoMunicipio.ItemIndex]);
         fPedido.Nome := edtNome.Text;
         fPedido.Endereco.Cep := edtEnderecoCep.Text;
         fPedido.Endereco.Rua := edtEnderecoRua.Text;
         fPedido.Endereco.Numero := edtEnderecoNumero.Text;
         fPedido.Endereco.Bairro := edtEnderecoBairro.Text;
         fPedido.Endereco.Municipio := TModelEntidadeMunicipio(fController.Entidades.Municipio).GetMunicipio(AMunicipioId);
         TModelEntidadePedido(fController
            .Entidades
               .Pedido).FinalizaPedido(fPedido);
         tabctrlPedido.ActiveTab := tabitmPedidos;
      end;
end;

procedure TfrmPedido.btnEditarClick(Sender: TObject);
begin
  inherited;
   with bsPedidos do
      fPedido := TModelEntidadePedido(fController
         .Entidades
            .Pedido)
               .GetPedido(DataSet
                  .FieldByName('id').AsInteger);
   DetalhaPedido;
end;

procedure TfrmPedido.tabctrlPedidoChange(Sender: TObject);
begin
  inherited;
   lytToolBarPedidos.Visible := TTabControl(Sender).ActiveTab = tabitmPedidos;
   lytToolBarDetalhes.Visible := TTabControl(Sender).ActiveTab = tabitmDetalhes;
   lytToolBarConfirmacao.Visible := TTabControl(Sender).ActiveTab = tabitmEntrega;
   if TTabControl(Sender).ActiveTab = tabitmPedidos then
      CarregaListaPedidos
   else if TTabControl(Sender).ActiveTab = tabitmDetalhes then
           begin
              DeLayedSetFocus(edtCodigo);
           end
   else if TTabControl(Sender).ActiveTab = tabitmEntrega then
           DeLayedSetFocus(edtNome);
end;

function TfrmPedido.ValidaDadosPedido: Boolean;
begin
   Result := False;
   if Trim(edtNome.Text) = '' then
      begin
         ShowMessage('Preencha o nome do cliente!');
         DeLayedSetFocus(edtNome);
         Exit;
      end;

   if Trim(edtEnderecoCep.Text) = '' then
      begin
         ShowMessage('Preencha o CEP do endereço do cliente!');
         DeLayedSetFocus(edtEnderecoCep);
         Exit;
      end;

   if Trim(edtEnderecoRua.Text) = '' then
      begin
         ShowMessage('Preencha o rua do endereço do cliente!');
         DeLayedSetFocus(edtEnderecoRua);
         Exit;
      end;

   if Trim(edtEnderecoNumero.Text) = '' then
      begin
         ShowMessage('Preencha o número do endereço do cliente!');
         DeLayedSetFocus(edtEnderecoNumero);
         Exit;
      end;

   if Trim(edtEnderecoBairro.Text) = '' then
      begin
         ShowMessage('Preencha o bairro do endereço do cliente!');
         DeLayedSetFocus(edtEnderecoBairro);
         Exit;
      end;

   if cmbedtEnderecoPais.ItemIndex < 0 then
      begin
         ShowMessage('Selecione o país do endereço do cliente!');
         DeLayedSetFocus(cmbedtEnderecoPais);
         Exit;
      end;

   if cmbedtEnderecoEstado.ItemIndex < 0 then
      begin
         ShowMessage('Selecione o estado do endereço do cliente!');
         DeLayedSetFocus(cmbedtEnderecoEstado);
         Exit;
      end;

   if cmbedtEnderecoMunicipio.ItemIndex < 0 then
      begin
         ShowMessage('Selecione o município do endereço do cliente!');
         DeLayedSetFocus(cmbedtEnderecoMunicipio);
         Exit;
      end;

   Result := True;
end;

procedure TfrmPedido.CarregaListaEstados(const APaisId: Integer);
var
   AEstado: TEstado;
   AListaEstados: TListaEstados;
begin
   AListaEstados := TListaEstados.Create;
   try
      cmbedtEnderecoEstado.BeginUpdate;
      cmbedtEnderecoEstado.Items.Clear;
      AListaEstados := TModelEntidadeEstado(fController.Entidades.Estado).GetEstados(APaisId);
      for AEstado in AListaEstados.Items do
         begin
            cmbedtEnderecoEstado.Items.AddObject(AEstado.Nome, TObject(AEstado.Id));
         end;
      cmbedtEnderecoEstado.EndUpdate;
   finally
      FreeAndNil(AListaEstados);
   end;
end;

procedure TfrmPedido.CarregaListaItensPedido(const APedidoId: Integer);
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
               .GetItensPedido(APedidoId);
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

procedure TfrmPedido.CarregaListaPaises;
var
   APais: TPais;
   AListaPaises: TListaPaises;
begin
   AListaPaises := TListaPaises.Create;
   try
      cmbedtEnderecoPais.BeginUpdate;
      cmbedtEnderecoPais.Items.Clear;
      AListaPaises := TModelEntidadePais(fController.Entidades.Pais).GetPaises;
      for APais in AListaPaises.Items do
         begin
            cmbedtEnderecoPais.Items.AddObject(APais.Nome, TObject(APais.Id));
         end;
      cmbedtEnderecoPais.EndUpdate;
   finally
      FreeAndNil(AListaPaises);
   end;
end;

procedure TfrmPedido.CarregaListaPedidos;
var
   ACampo: TField;
begin
   fListaPedidos := TModelEntidadePedido(fController
      .Entidades
         .Pedido)
            .GetPedidos;

   fController
      .Entidades
         .Pedido
            .DataSet(dsPedidos)
               .Open('WHERE status_entrega = 1');

   with bsPedidos do
      begin
         DataSet.FieldByName('status').OnGetText := StatusOnGetText;
         DataSet.FieldByName('status_entrega').OnGetText := StatusEntregaOnGetText;
      end;
end;

procedure TfrmPedido.cmbedtEnderecoEstadoChange(Sender: TObject);
var
   AEstadoId: Integer;
begin
  inherited;
   if TComboEdit(Sender).ItemIndex >= 0 then
      begin
         AEstadoId := Integer(TComboEdit(Sender).Items.Objects[TComboEdit(Sender).ItemIndex]);
         CarregaListaMunicipios(AEstadoId);
      end;
end;

procedure TfrmPedido.cmbedtEnderecoPaisChange(Sender: TObject);
var
   APaisId: Integer;
begin
  inherited;
   if TComboEdit(Sender).ItemIndex >= 0 then
      begin
         APaisId := Integer(TComboEdit(Sender).Items.Objects[TComboEdit(Sender).ItemIndex]);
         CarregaListaEstados(APaisId);
      end;
end;

procedure TfrmPedido.CarregaListaMunicipios(const AEstadoId: Integer);
var
   AMunicipio: TMunicipio;
   AListaMunicipios: TListaMunicipios;
begin
   AListaMunicipios := TListaMunicipios.Create;
   try
      cmbedtEnderecoMunicipio.BeginUpdate;
      cmbedtEnderecoMunicipio.Items.Clear;
      AListaMunicipios := TModelEntidadeMunicipio(fController.Entidades.Municipio).GetMunicipios(AEstadoId);
      for AMunicipio in AListaMunicipios.Items do
         begin
            cmbedtEnderecoMunicipio.Items.AddObject(AMunicipio.Nome, TObject(AMunicipio.Id));
         end;
      cmbedtEnderecoMunicipio.EndUpdate;
   finally
      FreeAndNil(AListaMunicipios);
   end;
end;

procedure TfrmPedido.ControlesVisiveis(const Visivel: Boolean);
begin
   lblProdutoNome.Visible := Visivel;
   edtProdutoNome.Visible := Visivel;
   lblTipo.Visible := Visivel;
   edtTipo.Visible := Visivel;
   chkProdutoControlado.Visible := Visivel;
   chkProdutoSensivel.Visible := Visivel;
   lblProdutoArmazenamento.Visible := Visivel;
   edProdutoArmazenamnto.Visible := Visivel;
   lblQuantidade.Visible := Visivel;
   nbQuantidade.Visible := Visivel;
end;

procedure TfrmPedido.DeletaItemPedido(const APedidoId,
  AProdutoId: Integer);
begin
   if MessageDlg('Confirma Exclusão do Item do Pedido?', TMsgDlgType.mtConfirmation,
                  [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], 0,
                  TMsgDlgBtn.mbYes) = mrYes then
      begin
         TModelEntidadeItemPedido(fController.Entidades.ItemPedido).RemoveItemPedido(APedidoId, AProdutoId);
         CarregaListaItensPedido(APedidoId);
      end;
end;

procedure TfrmPedido.DetalhaPedido;
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
   CarregaListaItensPedido(fPedido.Id);
   lytToolBarDetalhes.Visible := False;
   ControlesVisiveis(False);
   tabctrlPedido.ActiveTab := tabitmDetalhes;
end;

initialization
   RegisterClass(TfrmPedido);

finalization
   UnRegisterClass(TfrmPedido);

end.
