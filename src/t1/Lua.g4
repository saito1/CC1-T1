/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

grammar Lua;

@members {
   public static String grupo="<<Digite os RAs do grupo aqui>>";
}
WS:   (' ') -> skip;
ENDL:  ([\n] | [\t]) -> skip;
// base
fragment LETRA: [a-z|A-Z];
fragment ALGARISMO: [0-9];

// Declarar funcao:
FUNCTION : 'function' ;

// IF
IF : 'if';
THEN: 'then';
ELSE: 'else';

// Repeat
REPEAT: 'repeat';
UNTIL: 'until';

// For
FOR: 'for';
DO: 'do';

// Operadores
MINUS: '-';
PLUS: '+';
TIMES: '*';
DIVIDED: '/';
NOR: 'nor';
HASH: '#';

// Utilidades
LOCAL: 'local';
ATRIBUICAO: '=';
COMPARACAO: '==' | '>';
LPAREN : '(' ;
RPAREN : ')' ;
END : 'end';
RETURN: 'return';


COMENTARIO_INICIO: '--' ~([\n]|[\r])+ -> skip;
UNDERSCORE: '_';
DOT: '.';
COMMA: ',';
SEMI_C: ';' ;
CADEIA: ([\\'] (~[\\'])* [\\']) | ('"' (~'"')* '"');

ID : (LETRA|UNDERSCORE) ((LETRA|ALGARISMO|UNDERSCORE)+)?;
NUMERO : ALGARISMO* DOT? ALGARISMO+;

programa : bloco;

bloco: (comando SEMI_C?)* (comando_ultimo SEMI_C?)?;
comando_ultimo: retorno ;

comando : atr
        | comentario
        | if_decl
        | funcao_decl
        | funcao_chamada
        | repeat_decl
        | do_decl
        | for_decl;
comentario: COMENTARIO_INICIO;

retorno: RETURN (valor|exp);

do_decl: DO bloco END;
repeat_decl: REPEAT bloco UNTIL log_exp;
for_decl: FOR atr COMMA LPAREN (valor|exp) RPAREN DO bloco END SEMI_C;

if_decl: IF log_exp THEN bloco (ELSE bloco)? END;
log_exp: (valor|exp) COMPARACAO (valor|exp);

funcao_decl: FUNCTION funcao_nome funcao_corpo;
funcao_corpo: LPAREN lista_valor RPAREN bloco END SEMI_C;
funcao_chamada : ID args;
args: LPAREN lista_valor RPAREN;
funcao_nome: ID{ TabelaDeSimbolos.adicionarSimbolo($ID.text, Tipo.FUNCAO); };

var: ID{ TabelaDeSimbolos.adicionarSimbolo($ID.text, Tipo.VARIAVEL); };
valor: (NUMERO|var)
     | funcao_chamada
     | CADEIA
     | var DOT funcao_chamada;

atr: (LOCAL)? var ATRIBUICAO (valor|exp);

lista_valor: ((valor|exp) COMMA)* (valor|exp);

exp: valor (operador1 | operador2) (valor|exp) | operador_un (valor|exp) ;


operador1: MINUS | PLUS;
operador2: TIMES | DIVIDED;
operador_un: MINUS | NOR |HASH;