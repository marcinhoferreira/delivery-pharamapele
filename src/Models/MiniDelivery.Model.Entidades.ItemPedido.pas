unit MiniDelivery.Model.Entidades.ItemPedido;

interface

uses
   SysUtils, Data.DB,
   MiniDelivery.Conexao.Interfaces,
   MiniDelivery.Entidades.Interfaces,
   MiniDelivery.Classe.Produto,
   MiniDelivery.Classe.Pedido;

type
   TModelEntidadeItemPedido = class(TInterfacedObject, IModelEntidade)
   private
      { Private declarations }
      fTipoConexao: TTipoConexao;
      fQuery: IModelQuery;
   public
      { Public declarations }
      constructor Create(const ATipoConexao: TTipoConexao = tcFireDAC);
      destructor Destroy; override;
      class function New(const ATipoConexao: TTipoConexao = tcFireDAC): IModelEntidade;
      function DataSet(const Value: TDataSource): IModelEntidade; overload;
      function DataSet(const Value: TDataSet): IModelEntidade; overload;
      procedure Open(const AWhere: String = '');
      function GetItemPedido(const PedidoId: Integer; const ItemId: Integer): TItemPedido;
      function GetItensPedido(const PedidoId: Integer): TItensPedido;
      procedure RegistraItemPedido(const PedidoId: Integer; const AProduto: TProduto; const AQuantidade: Double; const AAnotacoes: String);
      procedure RemoveItemPedido(const PedidoId: Integer; const ProdutoId: Integer);
   end;

implementation

uses
   MiniDelivery.Model.Conexao.Factory,
   MiniDelivery.Model.Entidades.Factory,
   MiniDelivery.Model.Entidades.Produto;

{ TModelEntidadeItemPedido }

constructor TModelEntidadeItemPedido.Create(const ATipoConexao: TTipoConexao);
begin
   fTipoConexao := ATipoConexao;
   fQuery := TModelConexaoFactory.New(fTipoConexao).Query;
end;

function TModelEntidadeItemPedido.DataSet(
  const Value: TDataSet): IModelEntidade;
begin
   Result := Self;
   Value.Assign(fQuery.Query);
end;

function TModelEntidadeItemPedido.DataSet(
  const Value: TDataSource): IModelEntidade;
begin
   Result := Self;
   Value.DataSet := fQuery.Query;
end;

destructor TModelEntidadeItemPedido.Destroy;
begin

  inherited;
end;

function TModelEntidadeItemPedido.GetItemPedido(const PedidoId: Integer; const ItemId: Integer): TItemPedido;
var
   AProdutoModel: IModelEntidade;
begin
   Result := TItemPedido.Create;
   Open('WHERE pedido_id = ' + IntToStr(PedidoId) + ' AND produto_id = ' + IntToStr(ItemId));
   with fQuery do
      begin
         if not Query.IsEmpty then
            begin
               Query.First;
               AProdutoModel := TModelEntidadesFactory.New(fTipoConexao).Produto;
               while not Query.Eof do
                  begin
                     Result := TItemPedido.Create;
                     Result.Produto := TModelEntidadeProduto(AProdutoModel).GetProduto(Query.FieldByName('produto_id').AsInteger);
                     Result.Quantidade := Query.FieldByName('quantidade').AsFloat;
                     Result.Anotacoes := Query.FieldByName('anotacoes').AsString;
                     Query.Next;
                  end;
            end;
      end;
end;

function TModelEntidadeItemPedido.GetItensPedido(const PedidoId: Integer): TItensPedido;
var
   AItemPedido: TItemPedido;
   AProdutoModel: IModelEntidade;
begin
   Result := TItensPedido.Create;
   Open('WHERE pedido_id = ' + IntToStr(PedidoId));
   with fQuery do
      begin
         if not Query.IsEmpty then
            begin
               Query.First;
               AProdutoModel := TModelEntidadesFactory.New(fTipoConexao).Produto;
               while not Query.Eof do
                  begin
                     AItemPedido := TItemPedido.Create;
                     AItemPedido.Produto := TModelEntidadeProduto(AProdutoModel).GetProduto(Query.FieldByName('produto_id').AsInteger);
                     AItemPedido.Quantidade := Query.FieldByName('quantidade').AsFloat;
                     AItemPedido.Anotacoes := Query.FieldByName('anotacoes').AsString;
                     Result.Add(AItemPedido);
                     Query.Next;
                  end;
            end;
      end;
end;

class function TModelEntidadeItemPedido.New(
  const ATipoConexao: TTipoConexao): IModelEntidade;
begin
    Result := Self.Create(ATipoConexao);
end;

procedure TModelEntidadeItemPedido.Open(const AWhere: String);
var
   ASQL: String;
begin
   ASQL := '';
   ASQL := ASQL + 'SELECT pedido_id, produto_id, quantidade, anotacoes ';
   ASQL := ASQL + 'FROM itens_pedido ';
   if AWhere <> '' then
      ASQL := ASQL + ' ' + AWhere;
   fQuery.Open(ASQL);
end;

procedure TModelEntidadeItemPedido.RegistraItemPedido(const PedidoId: Integer;
  const AProduto: TProduto; const AQuantidade: Double; const AAnotacoes: String);
begin
   Open(Format('WHERE pedido_id = %d AND produto_id = %d', [PedidoId, AProduto.Id]));
   with fQuery do
      begin
         if Query.IsEmpty then
            Query.Append
         else
            Query.Edit;
         Query.FieldByName('pedido_id').AsInteger := PedidoId;
         Query.FieldByName('produto_id').AsInteger := AProduto.Id;
         Query.FieldByName('quantidade').AsFloat := Query.FieldByName('quantidade').AsFloat + AQuantidade;
         Query.FieldByName('anotacoes').AsString := AAnotacoes;
         Query.Post;
      end;
end;

procedure TModelEntidadeItemPedido.RemoveItemPedido(const PedidoId,
  ProdutoId: Integer);
begin
   Open(Format('WHERE pedido_id = %d AND produto_id = %d', [PedidoId, ProdutoId]));
   with fQuery do
      begin
         if not Query.IsEmpty then
            Query.Delete;
      end;
end;

end.
