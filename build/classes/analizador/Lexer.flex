package analizador;
import static analizador.Token.*;
%%
%class Lexer
%type Token
L           = [a-zA-Z_]
D           = [0-9]
WHITE       = [ \t\r]
SALTO       = [\n]
ESP         = " "*
OPERADOR    = ["&" | "$" | "/" | "*" | "^"]
ALFANUM     = ({D}*|{L}*)
ELEMENT     = {ESP} ( "\"" {ALFANUM} "\"") ","{1} {ESP}
ULTIMOELE   = {ESP} ( "\"" {ALFANUM} "\"") {ESP}
ASIGNAR     = {ALFANUM} {ESP} "=" {ESP}
CONJUNTO    = {ASIGNAR} "{" {ELEMENT}*  ({ULTIMOELE}"}"){1}
UNIVERSO    = "UNIVERSO" {ESP} "=" {ESP} "{" {ELEMENT}* ({ULTIMOELE}"}"){1}
CONJUNTOV   = {ASIGNAR} "{" {ESP} "}"
OPERACION   = {L}+ {ESP} {OPERADOR}{1} {ESP} {L}+ ({ESP}{OPERADOR}{1} {ESP} {L}+)*
OPERACIONES = "(" {OPERACION} ")" | {OPERACION}

//DEC_DEFINICION = "DEFINICION" {CONJUNTO}* | {CONJUNTOV}
//DEC_OPERACION  = "OPERACION" {OPERACIONES}*
%{
public String lexeme;
%}
%%
{WHITE}          {/*Ignore*/}
"EOF"            {/*Ignore*/}
 EOF             {/*Ignore*/}
"DEFINICION"     {lexeme=yytext(); return DEFINICION;}
"OPERACION"      {lexeme=yytext(); return OPERACION;}
{SALTO}          {lexeme=yytext(); return LINEA;}
{UNIVERSO}       {lexeme=yytext(); return UNIVERSO;}
{CONJUNTO}       {lexeme=yytext(); return CONJUNTO;}
{CONJUNTOV}      {lexeme=yytext(); return CONJUNTO_VACIO;}
{OPERACIONES}    {lexeme=yytext(); return OPERACIONES;}



. {return ERROR;}