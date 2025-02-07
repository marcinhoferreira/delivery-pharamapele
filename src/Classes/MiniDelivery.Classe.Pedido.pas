unit MiniDelivery.Classe.Pedido;

interface

uses
   SysUtils, Classes, Generics.Collections,
   MiniDelivery.Classe.Produto,
   MiniDelivery.Classe.Endereco,
   MiniDelivery.Classe.Entregador;

type
   TItemPedido = class(TObject)
   private
      { Private declarations }
      fProduto: TProduto;
      fQuantidade: Double;
      fAnotacoes: String;
      function GetProduto: TProduto;
      function GetQuantidade: Double;
      procedure SetProduto(const Value: TProduto);
      procedure SetQuantidade(const Value: Double);
    function GetAnotacoes: String;
    procedure SetAnotacoes(const Value: String);
   protected
      { Protected declarations }
   public
      { Public declarations }
      constructor Create;
      destructor Destroy; override;
      property Produto: TProduto Read GetProduto Write SetProduto;
      property Quantidade: Double Read GetQuantidade Write SetQuantidade;
      property Anotacoes: String Read GetAnotacoes Write SetAnotacoes;
   end;

   TArrayItensPedido = Array Of TItemPedido;

   TItensPedido = class(TObject)
   private
      { Private declarations }
      fItems: TArrayItensPedido;
   protected
      { Protected declarations }
   public
      { Public declarations }
      function Tamanho: Integer;
      function Add(AIemPedido: TItemPedido): Integer;
      property Items: TArrayItensPedido Read fItems Write fItems;
   end;

   TPedido = class(TObject)
   private
      { Private declarations }
      fId: Integer;
      fNome: String;
      fEndereco: TEndereco;
      fSituacao: String;
      fEntregador: TEntregador;
      function GetId: Integer;
      function GetNome: String;
      procedure SetId(const Value: Integer);
      procedure SetNome(const Value: String);
      function GetEndereco: TEndereco;
      function GetSituacao: String;
      procedure SetEndereco(const Value: TEndereco);
      procedure SetSituacao(const Value: String);
      function GetEntregador: TEntregador;
      procedure SetEntregador(const Value: TEntregador);
   protected
      { Protected declarations }
   public
      { Public declarations }
      constructor Create;
      destructor Destroy; override;
      property Id: Integer Read GetId Write SetId;
      property Nome: String Read GetNome Write SetNome;
      property Endereco: TEndereco Read GetEndereco Write SetEndereco;
      property Situacao: String Read GetSituacao Write SetSituacao;
      property Entregador: TEntregador Read GetEntregador Write SetEntregador;
   end;

   TArrayPedidos = Array Of TPedido;

   TListaPedidos = class(TObject)
   private
      { Private declarations }
      fItems: TArrayPedidos;
   protected
      { Protected declarations }
   public
      { Public declarations }
      function Tamanho: Integer;
      function Add(APedido: TPedido): Integer;
      property Items: TArrayPedidos Read fItems Write fItems;
   end;

implementation

{ TPedido }

constructor TPedido.Create;
begin
   fEndereco := TEndereco.Create;
   fEntregador := TEntregador.Create;
end;

destructor TPedido.Destroy;
begin
   FreeAndNil(fEndereco);
   FreeAndNil(fEntregador);
  inherited;
end;

function TPedido.GetEndereco: TEndereco;
begin
   Result := fEndereco;
end;

function TPedido.GetEntregador: TEntregador;
begin
   Result := fEntregador;
end;

function TPedido.GetId: Integer;
begin
   Result := fId;
end;

function TPedido.GetNome: String;
begin
   Result := fNome;
end;

function TPedido.GetSituacao: String;
begin
   Result := fSituacao;
end;

procedure TPedido.SetEndereco(const Value: TEndereco);
begin
   fEndereco := Value;
end;

procedure TPedido.SetEntregador(const Value: TEntregador);
begin
   fEntregador := Value;
end;

procedure TPedido.SetId(const Value: Integer);
begin
   if Value <> fId then
      fId := Value;
end;

procedure TPedido.SetNome(const Value: String);
begin
   if Value <> fNome then
      fNome := Value;
end;

procedure TPedido.SetSituacao(const Value: String);
begin
   if Value <> fSituacao then
      fSituacao := Value;
end;

{ TListaPedidos }

function TListaPedidos.Add(APedido: TPedido): Integer;
begin
   SetLength(fItems, Tamanho + 1);
   fItems[High(fItems)] := APedido;
   Result := High(fItems);
end;

function TListaPedidos.Tamanho: Integer;
begin
   Result := Length(fItems);
end;

{ TItemPedido }

constructor TItemPedido.Create;
begin
   fProduto := TProduto.Create;
end;

destructor TItemPedido.Destroy;
begin
   FreeAndNil(fProduto);
  inherited;
end;

function TItemPedido.GetAnotacoes: String;
begin
   Result := fAnotacoes;
end;

function TItemPedido.GetProduto: TProduto;
begin
   Result := fProduto;
end;

function TItemPedido.GetQuantidade: Double;
begin
   Result := fQuantidade;
end;

procedure TItemPedido.SetAnotacoes(const Value: String);
begin
   if Value <> fAnotacoes then
      fAnotacoes := Value;
end;

procedure TItemPedido.SetProduto(const Value: TProduto);
begin
   fProduto := Value;
end;

procedure TItemPedido.SetQuantidade(const Value: Double);
begin
   if Value <> fQuantidade then
      fQuantidade := Value;
end;


{ TItensPedido }

function TItensPedido.Add(AIemPedido: TItemPedido): Integer;
begin
   SetLength(fItems, Tamanho + 1);
   fItems[High(fItems)] := AIemPedido;
   Result := High(fItems);
end;

function TItensPedido.Tamanho: Integer;
begin
   Result := Length(fItems);
end;

end.
