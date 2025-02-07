unit MiniDelivery.Classe.Entregador;

interface

uses
   SysUtils, Classes, Generics.Collections;

type
   TEntregador = class(TObject)
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

   TArrayEntregadores = Array Of TEntregador;

   TListaEntregadores = class(TObject)
   private
      { Private declarations }
      fItems: TArrayEntregadores;
   protected
      { Protected declarations }
   public
      { Public declarations }
      function Tamanho: Integer;
      function Add(AEntregador: TEntregador): Integer;
      property Items: TArrayEntregadores Read fItems Write fItems;
   end;

implementation

{ TEntregador }

function TEntregador.GetId: Integer;
begin
   Result := fId;
end;

function TEntregador.GetNome: String;
begin
   Result := fNome;
end;

procedure TEntregador.SetId(const Value: Integer);
begin
   if Value <> fId then
      fId := Value;
end;

procedure TEntregador.SetNome(const Value: String);
begin
   if Value <> fNome then
      fNome := Value;
end;


{ TListaEntregadores }

function TListaEntregadores.Add(AEntregador: TEntregador): Integer;
begin
   SetLength(fItems, Tamanho + 1);
   fItems[High(fItems)] := AEntregador;
   Result := High(fItems);
end;

function TListaEntregadores.Tamanho: Integer;
begin
   Result := Length(fItems);
end;

end.
