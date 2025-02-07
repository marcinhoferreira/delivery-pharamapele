unit MiniDelivery.View.CriarPedido;

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
  FMX.TabControl, FMX.ListBox, FMX.ComboEdit, FMX.Objects;

type
  TfrmCriarPedido = class(TfrmPadrao)
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
    lytIdentificacao: TLayout;
    lblNumeroPedido: TLabel;
    edtNumeroPedido: TEdit;
    btnFinalizar: TSpeedButton;
    lblSituacao: TLabel;
    edtSituacaoPedido: TEdit;
    tabctrlPedido: TTabControl;
    tabitmPedido: TTabItem;
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
    lytConfirmacao: TLayout;
    btnConfirmar: TSpeedButton;
    btnCancelar: TSpeedButton;
    recInformacoes: TRectangle;
    lblTextoInformacoes: TLabel;
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
  private
    { Private declarations }
    fController: IController;
    fProduto: TProduto;
    fPedido: TPedido;
    procedure ControlesVisiveis(const Visivel: Boolean);
    procedure AtualizaDadosPedido;
    procedure AddHeaderItensPedido;
    procedure AtualizaListaItensPedido;
    procedure CarregaListaPaises;
    procedure CarregaListaEstados(const APaisId: Integer);
    procedure CarregaListaMunicipios(const AEstadoId: Integer);
    procedure Inicializa;
    procedure DeletaItemPedido(const APedidoId: Integer; const AProdutoId: Integer);
  public
    { Public declarations }
  end;

var
  frmCriarPedido: TfrmCriarPedido;

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

procedure TfrmCriarPedido.AddHeaderItensPedido;
var
  AItemHeader: TListViewItem;
begin
  AItemHeader := lstvwItensPedido.Items.Add;
  AItemHeader.Purpose := TListItemPurpose.Header;
  AItemHeader.Text := 'ITENS DO PEDIDO';
end;

procedure TfrmCriarPedido.AtualizaDadosPedido;
begin
   if fPedido.Id > 0 then
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
         edtSituacaoPedido.Text := fPedido.Situacao;
      end
   else
      begin
         edtNumeroPedido.Text := 'NOVO';
         edtNome.Text := '';
         edtEnderecoCep.Text := '';
         edtEnderecoRua.Text := '';
         edtEnderecoNumero.Text := '';
         edtEnderecoBairro.Text := '';
         cmbedtEnderecoPais.Text := 'Brasil';
         cmbedtEnderecoEstado.Text := '';
         cmbedtEnderecoMunicipio.Text := '';
         edtSituacaoPedido.Text := 'Em elaboração';
      end;
end;

procedure TfrmCriarPedido.AtualizaListaItensPedido;
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

procedure TfrmCriarPedido.btnFinalizarClick(Sender: TObject);
begin
  inherited;
   if lstvwItensPedido.ItemCount = 0 then
      begin
         ShowMessage('Pedido ainda não possui nenhum item registrado!');
         Exit;
      end;
   tabctrlPedido.ActiveTab := tabitmEntrega;
   lytConfirmacao.Visible :=  True;
   TSpeedButton(Sender).Visible := False;
end;

procedure TfrmCriarPedido.edtCodigoChange(Sender: TObject);
begin
  inherited;
   if TEdit(Sender).Text = '' then
      ControlesVisiveis(False);
end;

procedure TfrmCriarPedido.edtCodigoEnter(Sender: TObject);
begin
  inherited;
   TEdit(Sender).Text := '';
end;

procedure TfrmCriarPedido.edtCodigoKeyDown(Sender: TObject;
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

procedure TfrmCriarPedido.FormCreate(Sender: TObject);
begin
  inherited;
   tabctrlPedido.TabPosition := TTabPosition.None;
   tabctrlPedido.ActiveTab := tabitmPedido;
   fController := TController.New;
   fPedido := TPedido.Create;
   fProduto := TProduto.Create;
   Inicializa;
   CarregaListaPaises;
   CarregaListaEstados(0);
   CarregaListaMunicipios(0);
end;

procedure TfrmCriarPedido.Inicializa;
begin
   fPedido := TModelEntidadePedido(fController
      .Entidades
         .Pedido).GetPedidoElaboracao;
   AtualizaDadosPedido;
   AtualizaListaItensPedido;
   ControlesVisiveis(False);
   DeLayedSetFocus(edtCodigo);
end;

procedure TfrmCriarPedido.lstvwItensPedidoKeyDown(Sender: TObject;
  var Key: Word; var KeyChar: WideChar; Shift: TShiftState);
begin
  inherited;
   if Key = vkDelete then
      DeletaItemPedido(fPedido.Id, TListView(Sender).Selected.Tag);
end;

procedure TfrmCriarPedido.nbQuantidadeKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: WideChar; Shift: TShiftState);
begin
  inherited;
   if Key = vkReturn then
      begin
         TModelEntidadeItemPedido(fController
            .Entidades
               .ItemPedido)
            .RegistraItemPedido(fPedido.Id, fProduto, nbQuantidade.Value, '');

         AtualizaListaItensPedido;

         DeLayedSetFocus(edtCodigo);
      end;
end;

procedure TfrmCriarPedido.btnCancelarClick(Sender: TObject);
begin
  inherited;
   tabctrlPedido.ActiveTab := tabitmPedido;
end;

procedure TfrmCriarPedido.btnConfirmarClick(Sender: TObject);
var
   AMunicipioId: Integer;
begin
  inherited;
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
         Inicializa;
         tabctrlPedido.ActiveTab := tabitmPedido;
      end;
end;

procedure TfrmCriarPedido.tabctrlPedidoChange(Sender: TObject);
begin
  inherited;
   btnFinalizar.Visible := True;
   lytConfirmacao.Visible := False;
   if TTabControl(Sender).ActiveTab = tabitmPedido then
      DeLayedSetFocus(edtCodigo)
   else
      DeLayedSetFocus(edtNome);
end;

procedure TfrmCriarPedido.CarregaListaEstados(const APaisId: Integer);
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

procedure TfrmCriarPedido.CarregaListaPaises;
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

procedure TfrmCriarPedido.cmbedtEnderecoEstadoChange(Sender: TObject);
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

procedure TfrmCriarPedido.cmbedtEnderecoPaisChange(Sender: TObject);
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

procedure TfrmCriarPedido.CarregaListaMunicipios(const AEstadoId: Integer);
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

procedure TfrmCriarPedido.ControlesVisiveis(const Visivel: Boolean);
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

procedure TfrmCriarPedido.DeletaItemPedido(const APedidoId,
  AProdutoId: Integer);
begin
   if MessageDlg('Confirma Exclusão do Item do Pedido?', TMsgDlgType.mtConfirmation,
                  [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], 0,
                  TMsgDlgBtn.mbYes) = mrYes then
      begin
         TModelEntidadeItemPedido(fController.Entidades.ItemPedido).RemoveItemPedido(APedidoId, AProdutoId);
         AtualizaListaItensPedido;
      end;
end;

initialization
   RegisterClass(TfrmCriarPedido);

finalization
   UnRegisterClass(TfrmCriarPedido);

end.
