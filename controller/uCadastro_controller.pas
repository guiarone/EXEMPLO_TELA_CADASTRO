unit uCadastro_controller;

interface
uses
  uCadastro_model, System.Classes, System.sysutils;

type

  TCadastro_Controller = class
  private
    FArquivo: TList;
    function Get_Ultimo_Id: integer;
    function Get_Registro_by_Id(oId: integer; var oCadastro: TCadastro): integer;
    function Get_Registro_By_Cpf(oCpf: string; var oCadastro: TCadastro): integer;
    function GetCount: integer;
  public
    constructor Create;
    destructor Destroy;
    function Alterar(oCadastro: TCadastro; var oErro: string): boolean;
    function Consultar(oId: integer; var oCadastro: TCadastro; var oErro: string): boolean;
    function ConsultaByIndice( oindice: integer; var oCadastro: TCadastro; var oErro: string): integer;
    function Excluir(oId: integer; var oErro: string): boolean;
    function Incluir(oCadastro: TCadastro; var oErro: string): boolean;
    property Count: integer read GetCount;
  end;

implementation

{ TCadastro_Controller }

function TCadastro_Controller.Alterar(oCadastro: TCadastro;
        var oErro: string): boolean;
var
  indice: integer;
  cadaux: TCadastro;
begin
  //descobre o registro
  indice:= Get_Registro_by_Id(oCadastro.Id, cadaux);
  //altera
  if indice > -1 then
    try
      FArquivo[indice]:= oCadastro;
      result:= true;
    except
      oErro:= 'Falha na opera??o de altera??o.';
      result:= false;
    end;
end;

function TCadastro_Controller.Get_Registro_By_Cpf(ocpf: string;
  var oCadastro: TCadastro): integer;
var
  achou: boolean;
  indice: integer;
begin
  achou:= false;
  result:= -1;
  indice:= 0;
  //procura o registro pelo CPF
  if FArquivo.Count > 0 then
    repeat
      try
        oCadastro:= FArquivo[indice];
        if (oCadastro.CPF = ocpf) and (not oCadastro.Excluido) then
        begin
          achou:= true;
          result:= indice;
        end
        else
          inc(indice);
      except
        result:= -1;
        achou:= false;
      end;
    until achou or (indice = FArquivo.Count);
end;

function TCadastro_Controller.ConsultaByIndice(oindice: integer;
  var oCadastro: TCadastro; var oErro: string): integer;
begin
  //procura o registro pelo indice da Tlist
  if oindice < FArquivo.Count then
  begin
    oCadastro:= FArquivo[oindice];
    result:= oCadastro.Id;
  end
  else
  begin
    oErro:= 'Registro n?o encontrado.';
    result:= -1;
  end;
end;

function TCadastro_Controller.Consultar(oId: integer;
        var oCadastro: TCadastro; var oErro: string): boolean;
var
  retorno: integer;
begin
  //busca registro pelo ID e retora em oCadastro
  retorno:= Get_Registro_by_Id(oId, oCadastro);
  if retorno = -1 then
  begin
    oErro:= 'Registro n?o encontrado.';
    result:= false;
  end
  else
    result:= true;
end;

constructor TCadastro_Controller.Create;
begin
  //inicializa
  FArquivo:= TList.Create;
end;

destructor TCadastro_Controller.Destroy;
var
  i: integer;
  cad: TCadastro;
begin
  //finaliza
  for i:= 0 to pred(FArquivo.Count) do
  begin
    cad:= FArquivo[i];
    cad.Free;
  end;
  FArquivo.Free;
end;

function TCadastro_Controller.Excluir(oId: integer; var oErro: string): boolean;
var
  retorno: integer;
  cadaux: TCadastro;
begin
  //busca pelo id
  retorno:= Get_Registro_by_Id(oId, cadaux);
  if retorno = -1 then
  begin
    oErro:= 'Registro n?o encontrado.';
    result:= false;
  end
  else
  begin
    //se achou marca como excluido
    try
      cadaux.Excluido:= true;
    except
      oErro:= 'Falha na opera??o de exclus?o.';
      result:= false;
    end;
  end;
end;

function TCadastro_Controller.GetCount: integer;
begin
  //retorna numero de registros no arquivo, inclusive os marcados como excluido
  Result:= FArquivo.Count;
end;

function TCadastro_Controller.Get_Registro_by_Id(oId: integer;
          var oCadastro: TCadastro): integer;
var
  achou: boolean;
  indice: integer;
begin
  achou:= false;
  result:= -1;
  indice:= 0;
  //retorna o registro pelo ID em oCadastro
  if FArquivo.Count > 0 then
    repeat
      try
        oCadastro:= FArquivo[indice];
        if oCadastro.Id = oId then
        begin
          achou:= true;
          result:= indice;
        end
        else
          inc(indice);
      except
        result:= -1;
        achou:= false;
      end;
    until achou or (indice = FArquivo.Count);
end;

function TCadastro_Controller.Get_Ultimo_Id: integer;
var
  cad: TCadastro;
begin
  //pega o ultimo ID inserido no TList
  if FArquivo.Count > 0 then
    try
      cad:= FArquivo[FArquivo.Count-1];
      Result:= cad.Id;
    except
      result:= -1;
    end
  else
    Result:= -1;
end;

function TCadastro_Controller.Incluir(oCadastro: TCadastro;
        var oErro: string): boolean;
var
  auxCad: TCadastro;
begin
  try
    //inclui registro
    if (Get_Registro_By_Cpf(oCadastro.CPF, auxCad) = -1) or
       (oCadastro.CPF = '') then
    begin
      oCadastro.Id:= Get_Ultimo_Id+1;
      oCadastro.Excluido:= false;
      FArquivo.Add(oCadastro);
      result:= true;
    end
    else
    begin
      oErro:= 'CPF j? cadastrado.';
      result:= false
    end;
  except
    oErro:= 'Falha na opera??o de inclus?o.';
    result:= false;
  end;
end;

end.
