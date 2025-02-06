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
  FMX.TabControl;

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
    btnConfirmar: TButton;
    btnCancelar: TButton;
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
    procedure FormCreate(Sender: TObject);
    procedure edtCodigoKeyDown(Sender: TObject; var Key: Word;
      var KeyChar: WideChar; Shift: TShiftState);
    procedure edtCodigoChange(Sender: TObject);
    procedure edtCodigoEnter(Sender: TObject);
    procedure nbQuantidadeKeyDown(Sender: TObject; var Key: Word;
      var KeyChar: WideChar; Shift: TShiftState);
    procedure btnFinalizarClick(Sender: TObject);
    procedure btnConfirmarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure tabctrlPedidoChange(Sender: TObject);
  private
    { Private declarations }
    fController: IController;
    fProduto: TProduto;
    fPedido: TPedido;
    procedure ControlesVisiveis(const Visivel: Boolean);
    procedure AtualizaDadosPedido;
    procedure AtualizaListaItensPedido;
    procedure Inicializa;
  public
    { Public declarations }
  end;

var
  frmCriarPedido: TfrmCriarPedido;

implementation

uses
   MiniDelivery.Model.Entidades.Produto,
   MiniDelivery.Model.Entidades.Pedido,
   MiniDelivery.Model.Entidades.ItemPedido,
   MiniDelivery.Controller;

{$R *.fmx}

{ TfrmCriarPedido }

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
                        AItem.Height := 50;
                     end
                  else
                     AItem.Height := 25;
               end;
         end;
      lstvwItensPedido.EndUpdate;
   finally
      FreeAndNil(AItensPedido);
   end;
end;

procedure TfrmCriarPedido.btnCancelarClick(Sender: TObject);
begin
  inherited;
   tabctrlPedido.ActiveTab := tabitmPedido;
end;

procedure TfrmCriarPedido.btnConfirmarClick(Sender: TObject);
begin
  inherited;
   if MessageDlg('Confirma Finalização do Pedido?', TMsgDlgType.mtConfirmation,
                  [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], 0,
                  TMsgDlgBtn.mbYes) = mrYes then
      begin
         TModelEntidadePedido(fController
            .Entidades
               .Pedido).FinalizaPedido(fPedido);
         Inicializa;
         tabctrlPedido.ActiveTab := tabitmPedido;
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

procedure TfrmCriarPedido.nbQuantidadeKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: WideChar; Shift: TShiftState);
begin
  inherited;
   if Key = vkReturn then
      begin
         TModelEntidadeItemPedido(fController
            .Entidades
               .ItemPedido)
            .RegistraItemPedido(fPedido.Id, fProduto, nbQuantidade.Value);

         AtualizaListaItensPedido;

         DeLayedSetFocus(edtCodigo);
      end;
end;

procedure TfrmCriarPedido.tabctrlPedidoChange(Sender: TObject);
begin
  inherited;
   if TTabControl(Sender).ActiveTab = tabitmPedido then
      DeLayedSetFocus(edtCodigo)
   else
      DeLayedSetFocus(edtNome);
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

initialization
   RegisterClass(TfrmCriarPedido);

finalization
   UnRegisterClass(TfrmCriarPedido);

end.
