unit MiniDelivery.Classe.UnidadeMedida;

interface

uses
   SysUtils, Classes, Generics.Collections;

type
   TUnidadeMedida = class(TObject)
   private
      { Private declarations }
      fId: Integer;
      fNome: String;
      fSigla: String;
      function GetId: Integer;
      function GetNome: String;
      function GetSigla: String;
      procedure SetId(const Value: Integer);
      procedure SetNome(const Value: String);
      procedure SetSigla(const Value: String);
   protected
      { Protected declarations }
   public
      { Public declarations }
      property Id: Integer Read GetId Write SetId;
      property Nome: String Read GetNome Write SetNome;
      property Sigla: String Read GetSigla Write SetSigla;
   end;

   TArrayUnidadesMedida = Array Of TUnidadeMedida;

   TListaUnidadesMedida = class(TObject)
   private
      { Private declarations }
      fItems: TArrayUnidadesMedida;
   protected
      { Protected declarations }
   public
      { Public declarations }
      function Tamanho: Integer;
      function Add(AUnidadeMedida: TUnidadeMedida): Integer;
      property Items: TArrayUnidadesMedida Read fItems Write fItems;
   end;

implementation

{ TUnidadeMedida }

function TUnidadeMedida.GetId: Integer;
begin
   Result := fId;
end;

function TUnidadeMedida.GetNome: String;
begin
   Result := fNome;
end;

function TUnidadeMedida.GetSigla: String;
begin
   Result := fSigla;
end;

procedure TUnidadeMedida.SetId(const Value: Integer);
begin
   if Value <> fId then
      fId := Value;
end;

procedure TUnidadeMedida.SetNome(const Value: String);
begin
   if Value <> fNome then
      fNome := Value;
end;

procedure TUnidadeMedida.SetSigla(const Value: String);
begin
   if Value <> fSigla then
      fSigla := Value;
end;

{ TListaUnidadesMedida }

function TListaUnidadesMedida.Add(AUnidadeMedida: TUnidadeMedida): Integer;
begin
   SetLength(fItems, Tamanho + 1);
   fItems[High(fItems)] := AUnidadeMedida;
   Result := High(fItems);
end;

function TListaUnidadesMedida.Tamanho: Integer;
begin
   Result := Length(fItems);
end;

end.
