unit uCadastro_model;

interface

type
  TCadastro = class
  private
    FId: integer;
    FLogradouro: ShortString;
    FBairro: ShortString;
    FEmail: ShortString;
    FCPF: ShortString;
    FCep: ShortString;
    FNumero: shortstring;
    FIdentidade: ShortString;
    FComplemento: ShortString;
    FNome: shortString;
    FCidade: ShortString;
    FPais: ShortString;
    FEstado: ShortString;
    FTelefone: ShortString;
    FExcluido: boolean;
    procedure SetId(const Value: integer);
    procedure SetBairro(const Value: ShortString);
    procedure SetCep(const Value: ShortString);
    procedure SetCidade(const Value: ShortString);
    procedure SetComplemento(const Value: ShortString);
    procedure SetCPF(const Value: ShortString);
    procedure SetEmail(const Value: ShortString);
    procedure SetEstado(const Value: ShortString);
    procedure SetIdentidade(const Value: ShortString);
    procedure SetLogradouro(const Value: ShortString);
    procedure SetNome(const Value: ShortString);
    procedure SetNumero(const Value: shortstring);
    procedure SetPais(const Value: ShortString);
    procedure SetTelefone(const Value: ShortString);
    procedure SetExcluido(const Value: boolean);
  public
    property Id: integer read FId write SetId;
    property Nome: shortstring read FNome write SetNome;
    property Identidade: shortstring read FIdentidade write SetIdentidade;
    property CPF: shortstring read FCPF write SetCPF;
    property Telefone: shortstring read FTelefone write SetTelefone;
    property Email: shortstring read FEmail write SetEmail;
    //FEnderešo
    property Cep: shortstring read FCep write SetCep;
    property Logradouro: shortstring read FLogradouro write SetLogradouro;
    property Numero: shortstring read FNumero write SetNumero;
    property Complemento: shortstring read FComplemento write SetComplemento;
    property Bairro: shortstring read FBairro write SetBairro;
    property Cidade: shortstring read FCidade write SetCidade;
    property Estado: shortstring read FEstado write SetEstado;
    property Pais: shortstring read FPais write SetPais;
    property Excluido: boolean read FExcluido write SetExcluido;
  end;

implementation

{ TCadastro }

function SoNumeros(const Value: shortstring): shortstring;
var
  i: integer;
  valor: shortString;
begin
  valor:= '';
  for i:= 1 to length(Value) do
    if (Value[i] >= '0') and (Value[i] <= '9')then
      valor:= valor + Value[i];
  result:= valor;
end;

procedure TCadastro.SetBairro(const Value: ShortString);
begin
  FBairro := Value;
end;

procedure TCadastro.SetCep(const Value: ShortString);
begin
  FCep := Value;
end;

procedure TCadastro.SetCidade(const Value: ShortString);
begin
  FCidade := Value;
end;

procedure TCadastro.SetComplemento(const Value: ShortString);
begin
  FComplemento := Value;
end;

procedure TCadastro.SetCPF(const Value: ShortString);
begin
  FCPF := Value;
end;

procedure TCadastro.SetEmail(const Value: ShortString);
begin
  FEmail := Value;
end;

procedure TCadastro.SetEstado(const Value: ShortString);
begin
  FEstado := Value;
end;

procedure TCadastro.SetExcluido(const Value: boolean);
begin
  FExcluido := Value;
end;

procedure TCadastro.SetId(const Value: integer);
begin
  FId := Value;
end;

procedure TCadastro.SetIdentidade(const Value: ShortString);
begin
  FIdentidade := Value;
end;

procedure TCadastro.SetLogradouro(const Value: ShortString);
begin
  FLogradouro := Value;
end;

procedure TCadastro.SetNome(const Value: ShortString);
begin
  FNome := Value;
end;

procedure TCadastro.SetNumero(const Value: shortstring);
begin
  FNumero := Value;
end;

procedure TCadastro.SetPais(const Value: ShortString);
begin
  FPais := Value;
end;

procedure TCadastro.SetTelefone(const Value: ShortString);
begin
  FTelefone := Value;
end;

end.
