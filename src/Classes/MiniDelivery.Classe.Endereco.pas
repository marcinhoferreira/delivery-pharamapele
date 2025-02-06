unit MiniDelivery.Classe.Endereco;

interface

uses
   SysUtils, Classes, Generics.Collections;

type
   TPais = class(TObject)
   private
      { Private declarations }
      fId: Integer;
      fNome: String;
      function GetId: Integer;
      function GetNome: String;
      procedure SetId(const Value: Integer);
      procedure SetNome(const Value: String);
   protected
      { Protected declarations }
   public
      { Public declarations }
      property Id: Integer Read GetId Write SetId;
      property Nome: String Read GetNome Write SetNome;
   end;

   TArrayPaises = Array Of TPais;

   TListaPaises = class(TObject)
   private
      { Private declarations }
      fItems: TArrayPaises;
   protected
      { Protected declarations }
   public
      { Public declarations }
      function Tamanho: Integer;
      function Add(APais: TPais): Integer;
      property Items: TArrayPaises Read fItems Write fItems;
   end;

   TEstado = class(TObject)
   private
      { Private declarations }
      fId: Integer;
      fNome: String;
      fPais: TPais;
      function GetId: Integer;
      function GetNome: String;
      procedure SetId(const Value: Integer);
      procedure SetNome(const Value: String);
      function GetPais: TPais;
      procedure SetPais(const Value: TPais);
   protected
      { Protected declarations }
   public
      { Public declarations }
      constructor Create;
      destructor Destroy; override;
      property Id: Integer Read GetId Write SetId;
      property Nome: String Read GetNome Write SetNome;
      property Pais: TPais Read GetPais Write SetPais;
   end;

   TArrayEstados = Array Of TEstado;

   TListaEstados = class(TObject)
   private
      { Private declarations }
      fItems: TArrayEstados;
   protected
      { Protected declarations }
   public
      { Public declarations }
      function Tamanho: Integer;
      function Add(AEstado: TEstado): Integer;
      property Items: TArrayEstados Read fItems Write fItems;
   end;

   TMunicipio = class(TObject)
   private
      { Private declarations }
      fId: Integer;
      fNome: String;
      fEstado: TEstado;
      function GetId: Integer;
      function GetNome: String;
      procedure SetId(const Value: Integer);
      procedure SetNome(const Value: String);
      function GetEstado: TEstado;
      procedure SetEstado(const Value: TEstado);
   protected
      { Protected declarations }
   public
      { Public declarations }
      constructor Create;
      destructor Destroy; override;
      property Id: Integer Read GetId Write SetId;
      property Nome: String Read GetNome Write SetNome;
      property Estado: TEstado Read GetEstado Write SetEstado;
   end;

   TArrayMunicipios = Array Of TMunicipio;

   TListaMunicipios = class(TObject)
   private
      { Private declarations }
      fItems: TArrayMunicipios;
   protected
      { Protected declarations }
   public
      { Public declarations }
      function Tamanho: Integer;
      function Add(AMunicipio: TMunicipio): Integer;
      property Items: TArrayMunicipios Read fItems Write fItems;
   end;

   TEndereco = class(TObject)
   private
      { Private declarations }
      fCep: String;
      fRua: String;
      fNumero: String;
      fBairro: String;
      fMunicipio: TMunicipio;
      function GetBairro: String;
      function GetCep: String;
      function GetMunicipio: TMunicipio;
      function GetNumero: String;
      function GetRua: String;
      procedure SetBairro(const Value: String);
      procedure SetCep(const Value: String);
      procedure SetMunicipio(const Value: TMunicipio);
      procedure SetNumero(const Value: String);
      procedure SetRua(const Value: String);
   protected
      { Protected declarations }
   public
      { Public declarations }
      constructor Create;
      destructor Destroy; override;
      property Cep: String Read GetCep Write SetCep;
      property Rua: String Read GetRua Write SetRua;
      property Numero: String Read GetNumero Write SetNumero;
      property Bairro: String Read GetBairro Write SetBairro;
      property Municipio: TMunicipio Read GetMunicipio Write SetMunicipio;
   end;

implementation

{ TPais }

function TPais.GetId: Integer;
begin
   Result := fId;
end;

function TPais.GetNome: String;
begin
   Result := fNome;
end;

procedure TPais.SetId(const Value: Integer);
begin
   if Value <> fId then
      fId := Value;
end;

procedure TPais.SetNome(const Value: String);
begin
   if Value <> fNome then
      fNome := Value;
end;

{ TEstado }

constructor TEstado.Create;
begin
   fPais := TPais.Create;
end;

destructor TEstado.Destroy;
begin
   FreeAndNil(fPais);
  inherited;
end;

function TEstado.GetId: Integer;
begin
   Result := fId;
end;

function TEstado.GetNome: String;
begin
   Result := fNome;
end;

function TEstado.GetPais: TPais;
begin
   Result := fPais;
end;

procedure TEstado.SetId(const Value: Integer);
begin
   if Value <> fId then
      fId := Value;
end;

procedure TEstado.SetNome(const Value: String);
begin
   if Value <> fNome then
      fNome := Value;
end;

procedure TEstado.SetPais(const Value: TPais);
begin
   fPais := Value;
end;

{ TMunicipio }

constructor TMunicipio.Create;
begin
   fEstado := TEstado.Create;
end;

destructor TMunicipio.Destroy;
begin
   FreeAndNil(fEstado);
  inherited;
end;

function TMunicipio.GetEstado: TEstado;
begin
   Result := fEstado;
end;

function TMunicipio.GetId: Integer;
begin
   Result := fId;
end;

function TMunicipio.GetNome: String;
begin
   Result := fNome;
end;

procedure TMunicipio.SetEstado(const Value: TEstado);
begin
   fEstado := Value;
end;

procedure TMunicipio.SetId(const Value: Integer);
begin
   if Value <> fId then
      fId := Value;
end;

procedure TMunicipio.SetNome(const Value: String);
begin
   if Value <> fNome then
      fNome := Value;
end;

{ TEndereco }

constructor TEndereco.Create;
begin
   fMunicipio := TMunicipio.Create;
end;

destructor TEndereco.Destroy;
begin
   FreeAndNil(fMunicipio);
  inherited;
end;

function TEndereco.GetBairro: String;
begin
   Result := fBairro;
end;

function TEndereco.GetCep: String;
begin
   Result := fCep;
end;

function TEndereco.GetMunicipio: TMunicipio;
begin
   Result := fMunicipio;
end;

function TEndereco.GetNumero: String;
begin
   Result := fNumero;
end;

function TEndereco.GetRua: String;
begin
   Result := fRua;
end;

procedure TEndereco.SetBairro(const Value: String);
begin
   if Value <> fBairro then
      fBairro := Value;
end;

procedure TEndereco.SetCep(const Value: String);
begin
   if Value <> fCep then
      fCep := Value;
end;

procedure TEndereco.SetMunicipio(const Value: TMunicipio);
begin
   fMunicipio := Value;
end;

procedure TEndereco.SetNumero(const Value: String);
begin
   if Value <> fNumero then
      fNumero := Value;
end;

procedure TEndereco.SetRua(const Value: String);
begin
   if Value <> fRua then
      fRua := Value;
end;

{ TListaMunicipios }

function TListaMunicipios.Add(AMunicipio: TMunicipio): Integer;
begin
   SetLength(fItems, Tamanho + 1);
   fItems[High(fItems)] := AMunicipio;
   Result := High(fItems);
end;

function TListaMunicipios.Tamanho: Integer;
begin
   Result := Length(fItems);
end;

{ TListaPaises }

function TListaPaises.Add(APais: TPais): Integer;
begin
   SetLength(fItems, Tamanho + 1);
   fItems[High(fItems)] := APais;
   Result := High(fItems);
end;

function TListaPaises.Tamanho: Integer;
begin
   Result := Length(fItems);
end;

{ TListaEstados }

function TListaEstados.Add(AEstado: TEstado): Integer;
begin
   SetLength(fItems, Tamanho + 1);
   fItems[High(fItems)] := AEstado;
   Result := High(fItems);
end;

function TListaEstados.Tamanho: Integer;
begin
   Result := Length(fItems);
end;

end.
