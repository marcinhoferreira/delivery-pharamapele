unit MiniDelivery.Model.Entidades.Produto;

interface

uses
   SysUtils, Data.DB, System.Json, REST.Json,
   MiniDelivery.Conexao.Interfaces,
   MiniDelivery.Entidades.Interfaces,
   MiniDelivery.Classe.Produto;

type
   TModelEntidadeTipoProduto = class(TInterfacedObject, IModelEntidade)
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
      function GetTipoProduto(const Id: Integer): TTipoProduto;
   end;

   TModelEntidadeProduto = class(TInterfacedObject, IModelEntidade)
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
      function GetProduto(const Id: Integer): TProduto; overload;
      function GetProduto(const Codigo: String): TProduto; overload;
      function GetProdutos: TListaProdutos;
   end;

implementation

uses
   MiniDelivery.Classe.UnidadeMedida,
   MiniDelivery.Model.Conexao.Factory,
   MiniDelivery.Model.Entidades.Factory,
   MiniDelivery.Model.Entidades.UnidadeMedida;

{ TModelEntidadeProduto }

constructor TModelEntidadeProduto.Create(const ATipoConexao: TTipoConexao = tcFireDAC);
begin
   fTipoConexao := ATipoConexao;
   fQuery := TModelConexaoFactory.New(fTipoConexao).Query;
end;

function TModelEntidadeProduto.DataSet(const Value: TDataSet): IModelEntidade;
begin
   Result := Self;
   Value.Assign(fQuery.Query);
end;

function TModelEntidadeProduto.DataSet(const Value: TDataSource): IModelEntidade;
begin
   Result := Self;
   Value.DataSet := fQuery.Query;
end;

destructor TModelEntidadeProduto.Destroy;
begin

  inherited;
end;

function TModelEntidadeProduto.GetProduto(const Id: Integer): TProduto;
var
   ATipoProdutoModel,
   AUnidadeMedidaModel: IModelEntidade;
begin
   Result := TProduto.Create;
   Open(Format('WHERE id = %d', [Id]));
   with fQuery do
      if not Query.IsEmpty then
         begin
            ATipoProdutoModel := TModelEntidadesFactory.New(fTipoConexao).TipoProduto;
            AUnidadeMedidaModel := TModelEntidadesFactory.New(fTipoConexao).UnidadeMedida;
            Result.Id := Query.FieldByName('id').AsInteger;
            Result.Tipo := TModelEntidadeTipoProduto(ATipoProdutoModel).GetTipoProduto(Query.FieldByName('tipo_id').AsInteger);
            Result.Codigo := Query.FieldByName('codigo').AsString;
            Result.Nome := Query.FieldByName('nome').AsString;
            Result.UnidadeMedida := TModelEntidadeUnidadeMedida(AUnidadeMedidaModel).GetUnidadeMedida(Query.FieldByName('unidade_medida_id').AsInteger);
            Result.Estoque := Query.FieldByName('estoque').AsFloat;
            if not Query.FieldByName('data_validade').IsNull then
               Result.DataValidade := Query.FieldByName('data_validade').AsDateTime;
            Result.Controlado := Query.FieldByName('controlado').AsString = 'S';
            Result.Sensivel := Query.FieldByName('sensivel').AsString = 'S';
            Result.Armazenamento := Query.FieldByName('armazenamento').AsString;
         end;
end;

function TModelEntidadeProduto.GetProduto(const Codigo: String): TProduto;
var
   ATipoProdutoModel,
   AUnidadeMedidaModel: IModelEntidade;
begin
   Result := TProduto.Create;
   Open(Format('WHERE codigo = %s', [QuotedStr(Codigo)]));
   with fQuery do
      if not Query.IsEmpty then
         begin
            ATipoProdutoModel := TModelEntidadesFactory.New(fTipoConexao).TipoProduto;
            AUnidadeMedidaModel := TModelEntidadesFactory.New(fTipoConexao).UnidadeMedida;
            Result.Id := Query.FieldByName('id').AsInteger;
            Result.Tipo := TModelEntidadeTipoProduto(ATipoProdutoModel).GetTipoProduto(Query.FieldByName('tipo_id').AsInteger);
            Result.Codigo := Query.FieldByName('codigo').AsString;
            Result.Nome := Query.FieldByName('nome').AsString;
            Result.UnidadeMedida := TModelEntidadeUnidadeMedida(AUnidadeMedidaModel).GetUnidadeMedida(Query.FieldByName('unidade_medida_id').AsInteger);
            Result.Estoque := Query.FieldByName('estoque').AsFloat;
            if not Query.FieldByName('data_validade').IsNull then
               Result.DataValidade := Query.FieldByName('data_validade').AsDateTime;
            Result.Controlado := Query.FieldByName('controlado').AsString = 'S';
            Result.Sensivel := Query.FieldByName('sensivel').AsString = 'S';
            Result.Armazenamento := Query.FieldByName('armazenamento').AsString;
         end;
end;

function TModelEntidadeProduto.GetProdutos: TListaProdutos;
var
   AProduto: TProduto;
   ATipoProdutoModel,
   AUnidadeMedidaModel: IModelEntidade;
begin
   Result := TListaProdutos.Create;
   Open();
   with fQuery do
      if not Query.IsEmpty then
         begin
            ATipoProdutoModel := TModelEntidadesFactory.New(fTipoConexao).TipoProduto;
            AUnidadeMedidaModel := TModelEntidadesFactory.New(fTipoConexao).UnidadeMedida;
            Query.First;
            while not Query.Eof do
               begin
                  AProduto := TProduto.Create;
                  AProduto.Id := Query.FieldByName('id').AsInteger;
                  AProduto.Tipo := TModelEntidadeTipoProduto(ATipoProdutoModel).GetTipoProduto(Query.FieldByName('tipo_id').AsInteger);
                  AProduto.Codigo := Query.FieldByName('codigo').AsString;
                  AProduto.Nome := Query.FieldByName('nome').AsString;
                  AProduto.UnidadeMedida := TModelEntidadeUnidadeMedida(AUnidadeMedidaModel).GetUnidadeMedida(Query.FieldByName('unidade_medida_id').AsInteger);
                  AProduto.Estoque := Query.FieldByName('estoque').AsFloat;
                  if not Query.FieldByName('data_validade').IsNull then
                     AProduto.DataValidade := Query.FieldByName('data_validade').AsDateTime;
                  AProduto.Controlado := Query.FieldByName('controlado').AsString = 'S';
                  AProduto.Sensivel := Query.FieldByName('sensivel').AsString = 'S';
                  AProduto.Armazenamento := Query.FieldByName('armazenamento').AsString;
                  Result.Add(AProduto);
                  Query.Next;
               end;
         end;
end;

class function TModelEntidadeProduto.New(const ATipoConexao: TTipoConexao = tcFireDAC): IModelEntidade;
begin
   Result := Self.Create(ATipoConexao);
end;

procedure TModelEntidadeProduto.Open(const AWhere: String);
var
   ASQL: String;
begin
   ASQL := '';
   ASQL := ASQL + 'SELECT id, tipo_id, codigo, nome, unidade_medida_id, estoque,';
   ASQL := ASQL + 'data_validade, controlado, sensivel, armazenamento ';
   ASQL := ASQL + 'FROM produtos';
   if AWhere <> '' then
      ASQL := ASQL + ' ' + AWhere;
   fQuery.Open(ASQL);
   // Definindo o campo id, como autoincremento
   fQuery.Query.FieldByName('id').AutoGenerateValue := TAutoRefreshFlag.arAutoInc;
end;

{ TModelEntidadeTipoProduto }

constructor TModelEntidadeTipoProduto.Create(const ATipoConexao: TTipoConexao = tcFireDAC);
begin
   fTipoConexao := ATipoConexao;
   fQuery := TModelConexaoFactory.New(fTipoConexao).Query;
end;

function TModelEntidadeTipoProduto.DataSet(const Value: TDataSet): IModelEntidade;
begin
   Result := Self;
   Value.Assign(fQuery.Query);
end;

function TModelEntidadeTipoProduto.DataSet(const Value: TDataSource): IModelEntidade;
begin
   Result := Self;
   Value.DataSet := fQuery.Query;
end;

destructor TModelEntidadeTipoProduto.Destroy;
begin

  inherited;
end;

function TModelEntidadeTipoProduto.GetTipoProduto(const Id: Integer): TTipoProduto;
begin
   Result := TTipoProduto.Create;
   Open(Format('WHERE id = %d', [Id]));
   with fQuery do
      if not Query.IsEmpty then
         begin
            Result.Id := Query.FieldByName('id').AsInteger;
            Result.Descricao := Query.FieldByName('descricao').AsString;
            Result.Sigla := Query.FieldByName('sigla').AsString;
            Result.Armazenamento := Query.FieldByName('armazenamento').AsString = 'S';
         end;
end;

class function TModelEntidadeTipoProduto.New(const ATipoConexao: TTipoConexao = tcFireDAC): IModelEntidade;
begin
   Result := Self.Create(ATipoConexao);
end;

procedure TModelEntidadeTipoProduto.Open(const AWhere: String);
var
   ASQL: String;
begin
   ASQL := '';
   ASQL := ASQL + 'SELECT id, descricao, sigla, armazenamento ';
   ASQL := ASQL + 'FROM tipos_produto';
   if AWhere <> '' then
      ASQL := ASQL + ' ' + AWhere;
   fQuery.Open(ASQL);
   // Definindo o campo id, como autoincremento
   fQuery.Query.FieldByName('id').AutoGenerateValue := TAutoRefreshFlag.arAutoInc;
end;

end.
