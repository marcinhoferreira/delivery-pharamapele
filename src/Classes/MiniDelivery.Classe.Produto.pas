unit MiniDelivery.Classe.Produto;

interface

uses
   SysUtils, Classes, Generics.Collections,
   MiniDelivery.Classe.UnidadeMedida;

type
   TTipoProduto = class(TObject)
   private
      { Private declarations }
      fId: Integer;
      fDescricao: String;
      fSigla: String;
      fArmazenamento: Boolean;
      function GetArmazenamento: Boolean;
      function GetDescricao: String;
      function GetId: Integer;
      function GetSigla: String;
      procedure SetArmazenamento(const Value: Boolean);
      procedure SetDescricao(const Value: String);
      procedure SetId(const Value: Integer);
      procedure SetSigla(const Value: String);
   protected
      { Protected declarations }
   public
      { Public declarations }
      property Id: Integer Read GetId Write SetId;
      property Descricao: String Read GetDescricao Write SetDescricao;
      property Sigla: String Read GetSigla Write SetSigla;
      property Armazenamento: Boolean Read GetArmazenamento Write SetArmazenamento;
   end;

   TProduto = class(TObject)
   private
      { Private declarations }
      fId: Integer;
      fTipo: TTipoProduto;
      fCodigo: String;
      fNome: String;
      fUnidadeMedida: TUnidadeMedida;
      fEstoque: Double;
      fDataValidade: TDate;
      fControlado: Boolean;
      fSensivel: Boolean;
      fArmazenamento: String;
      function GetId: Integer;
      function GetNome: String;
      procedure SetId(const Value: Integer);
      procedure SetNome(const Value: String);
      function GetCodigo: String;
      procedure SetCodigo(const Value: String);
      function GetArmazenamento: String;
      function GetDataValidade: TDate;
      function GetEstoque: Double;
      function GetUnidadeMedida: TUnidadeMedida;
      procedure SetArmazenamento(const Value: String);
      procedure SetDataValidade(const Value: TDate);
      procedure SetEstoque(const Value: Double);
      procedure SetUnidadeMedida(const Value: TUnidadeMedida);
      function GetTipo: TTipoProduto;
      procedure SetTipo(const Value: TTipoProduto);
    function GetControlado: Boolean;
    function GetSensivel: Boolean;
    procedure SetControlado(const Value: Boolean);
    procedure SetSensivel(const Value: Boolean);
   protected
      { Protected declarations }
   public
      { Public declarations }
      constructor Create;
      destructor Destroy; override;
      property Id: Integer Read GetId Write SetId;
      property Tipo: TTipoProduto Read GetTipo Write SetTipo;
      property Codigo: String Read GetCodigo Write SetCodigo;
      property Nome: String Read GetNome Write SetNome;
      property UnidadeMedida: TUnidadeMedida Read GetUnidadeMedida Write SetUnidadeMedida;
      property Estoque: Double Read GetEstoque Write SetEstoque;
      property DataValidade: TDate Read GetDataValidade Write SetDataValidade;
      property Controlado: Boolean Read GetControlado Write SetControlado;
      property Sensivel: Boolean Read GetSensivel Write SetSensivel;
      property Armazenamento: String Read GetArmazenamento Write SetArmazenamento;
   end;

   TArrayProdutos = Array Of TProduto;

   TListaProdutos = class(TObject)
   private
      { Private declarations }
      fItems: TArrayProdutos;
   protected
      { Protected declarations }
   public
      { Public declarations }
      function Tamanho: Integer;
      function Add(AProduto: TProduto): Integer;
      property Items: TArrayProdutos Read fItems Write fItems;
   end;

implementation

{ TProduto }

constructor TProduto.Create;
begin
   fTipo := TTipoProduto.Create;
   fUnidadeMedida := TUnidadeMedida.Create;
end;

destructor TProduto.Destroy;
begin
   FreeAndNil(fTipo);
   FreeAndNil(fUnidadeMedida);
  inherited;
end;

function TProduto.GetArmazenamento: String;
begin
   Result := fArmazenamento;
end;

function TProduto.GetCodigo: String;
begin
   Result := fCodigo;
end;

function TProduto.GetControlado: Boolean;
begin
   Result := fControlado;
end;

function TProduto.GetDataValidade: TDate;
begin
   Result := fDataValidade;
end;

function TProduto.GetEstoque: Double;
begin
   Result := fEstoque;
end;

function TProduto.GetId: Integer;
begin
   Result := fId;
end;

function TProduto.GetNome: String;
begin
   Result := fNome;
end;

function TProduto.GetSensivel: Boolean;
begin
   Result := fSensivel;
end;

function TProduto.GetTipo: TTipoProduto;
begin
   Result := fTipo;
end;

function TProduto.GetUnidadeMedida: TUnidadeMedida;
begin
   Result := fUnidadeMedida;
end;

procedure TProduto.SetArmazenamento(const Value: String);
begin
   if Value <> fArmazenamento then
      fArmazenamento := Value;
end;

procedure TProduto.SetCodigo(const Value: String);
begin
   if Value <> fCodigo then
      fCodigo := Value;
end;

procedure TProduto.SetControlado(const Value: Boolean);
begin
   if Value <> fControlado then
      fControlado := Value;
end;

procedure TProduto.SetDataValidade(const Value: TDate);
begin
   if Value <> fDataValidade then
      fDataValidade := Value;
end;

procedure TProduto.SetEstoque(const Value: Double);
begin
   if Value <> fEstoque then
      fEstoque := Value;
end;

procedure TProduto.SetId(const Value: Integer);
begin
   if Value <> fId then
      fId := Value;
end;

procedure TProduto.SetNome(const Value: String);
begin
   if Value <> fNome then
      fNome := Value;
end;

procedure TProduto.SetSensivel(const Value: Boolean);
begin
   if Value <> fSensivel then
      fSensivel := Value;
end;

procedure TProduto.SetTipo(const Value: TTipoProduto);
begin
   fTipo := Value;
end;

procedure TProduto.SetUnidadeMedida(const Value: TUnidadeMedida);
begin
   fUnidadeMedida := Value;
end;

{ TListaProdutos }

function TListaProdutos.Add(AProduto: TProduto): Integer;
begin
   SetLength(fItems, Tamanho + 1);
   fItems[High(fItems)] := AProduto;
   Result := High(fItems);
end;

function TListaProdutos.Tamanho: Integer;
begin
   Result := Length(fItems);
end;


{ TTipoProduto }

function TTipoProduto.GetArmazenamento: Boolean;
begin
   Result := fArmazenamento;
end;

function TTipoProduto.GetDescricao: String;
begin
   Result := fDescricao;
end;

function TTipoProduto.GetId: Integer;
begin
   Result := fId;
end;

function TTipoProduto.GetSigla: String;
begin
   Result := fSigla;
end;

procedure TTipoProduto.SetArmazenamento(const Value: Boolean);
begin
   if Value <> fArmazenamento then
      fArmazenamento := Value;
end;

procedure TTipoProduto.SetDescricao(const Value: String);
begin
   if Value <> fDescricao then
      fDescricao := Value;
end;

procedure TTipoProduto.SetId(const Value: Integer);
begin
   if Value <> fId then
      fId := Value;
end;

procedure TTipoProduto.SetSigla(const Value: String);
begin
   if Value <> fSigla then
      fSigla := Value;
end;

end.
