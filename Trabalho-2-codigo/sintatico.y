%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include "arvore.h"
    #include "hash.h"
    #include "sintatico.tab.h"

    extern FILE *yyin;

    int yylex(void);
    void yyerror(char *);

    int linha = 1;

    Item *tokens = NULL;
    Item *usuario = NULL;
    Hash *h = NULL;
    Hash *simbolo = NULL;
    Pilha *p = NULL;
%}

%union {
    int ival;     
    double dval;  
    char *sval;  
}

%token <ival> INTEIRO
%token <dval> REAL
%token <sval> LETRA
%token <sval> ID
%token <sval> BIB
%token WHITESPACE
%token ENTER
%token <sval> ERRO
%token <sval> ASPAS

%token <sval> IF_TOK
%token <sval> ELSE_TOK
%token <sval> FOR_TOK
%token <sval> WHILE_TOK

%token <sval> CHAR_TOK
%token <sval> INT_TOK
%token <sval> FLOAT_TOK
%token <sval> DOUBLE_TOK
%token <sval> VOID_TOK

%token <sval> MAIN_TOK
%token <sval> PRINT_TOK
%token <sval> SCAN_TOK
%token <sval> RETURN_TOK
%token <sval> IMPORT_TOK
%token <sval> DEFINE_TOK

%left <sval> MAIS_TOK
%left <sval> MENOS_TOK
%left <sval> DIV_TOK
%left <sval> MULT_TOK
%token <sval> MOD_TOK
%token <sval> NEG_TOK
%token <sval> OR_TOK
%token <sval> XOR_TOK
%token <sval> AND_TOK

%token <sval> L_AND_TOK
%token <sval> L_OR_TOK
%token <sval> L_SHL_TOK
%token <sval> L_SHR_TOK

%token <sval> INC_TOK
%token <sval> DEC_TOK

%token <sval> ATR_TOK
%token <sval> ATR_SM_TOK
%token <sval> ATR_DC_TOK
%token <sval> ATR_MT_TOK
%token <sval> ATR_DV_TOK
%token <sval> ATR_MD_TOK

%token <sval> IG_TOK
%token <sval> DIF_TOK
%token <sval> MEN_TOK
%token <sval> MAI_TOK
%token <sval> MAI_IG_TOK
%token <sval> MEN_IG_TOK

%token <sval> VIRG_TOK
%token <sval> PVIRG_TOK
%token <sval> DPONT_TOK

%token <sval> A_PAR_TOK
%token <sval> F_PAR_TOK
%token <sval> A_COL_TOK
%token <sval> F_COL_TOK
%token <sval> A_CHA_TOK
%token <sval> F_CHA_TOK

%token <sval> COMENTARIO
%token <sval> STRING

%%
inicio:
    definicoes                                      {p = insere(p, "Inicio", 1); printf("Inicio -> definicoes\nSintaticamente Correto!!\n");}
    |                                               {printf("Vazio\n");}
    ;
definicoes:
    dec_imp definicoes                              {p = insere(p, "Definicoes", 2); printf("Definicoes -> <dec imp> <sequencia>\n");}
    | dec_def definicoes                            {p = insere(p, "Definicoes", 2); printf("Definicoes -> <dec def> <sequencia>\n");}
    | seq                                           {p = insere(p, "Definicoes", 1); printf("Definicoes -> <sequencia>\n");}
    ;
seq:
    dec pvirg                                       {p = insere(p, "Sequencia", 2); printf("Sequencia -> <declaracao> <pvirg>\n");}
    | dec pvirg seq                                 {p = insere(p, "Sequencia", 3); printf("Sequencia -> <declaracao> <pvirg> <sequencia>\n");}
    ;   
dec:
    main                                            {p = insere(p, "Declaracao", 1); printf("Declaracao -> <main>\n");}
    | dec_cond                                      {p = insere(p, "Declaracao", 1); printf("Declaracao -> <dec condicional>\n");}
    | dec_rep                                       {p = insere(p, "Declaracao", 1); printf("Declaracao -> <dec repeticao>\n");}
    | dec_atr                                       {p = insere(p, "Declaracao", 1); printf("Declaracao -> <dec atribuicao>\n");}
    | dec_lei                                       {p = insere(p, "Declaracao", 1); printf("Declaracao -> <dec leitura>\n");}
    | dec_esc                                       {p = insere(p, "Declaracao", 1); printf("Declaracao -> <dec escrita>\n");}
    | exp                                           {p = insere(p, "Declaracao", 1); printf("Declaracao -> <expressao>\n");}
    | func                                          {p = insere(p, "Declaracao", 1); printf("Declaracao -> <funcao>\n");}
    | dec_ret                                       {p = insere(p, "Declaracao", 1); printf("Declaracao -> <dec retorno>\n");}
    | comm                                          {p = insere(p, "Declaracao", 1); printf("Declaracao -> <comentario>\n");}
    | string                                        {p = insere(p, "Declaracao", 1); printf("Declaracao -> <string>\n");}
    ;
dec_cond:
    cond_if abre_p exp fecha_p abre_c seq fecha_c                                           {p = insere(p, "Dec_cond", 7); printf("Declaracao Condicional -> <cond_if> <abre_p> <expressao> <fehca_p> <abre_c> <sequencia> <fecha_c>\n");}
    | cond_if abre_p exp fecha_p abre_c seq fecha_c cond_else abre_c seq fecha_c            {p = insere(p, "Dec_cond", 11); printf("Declaracao Condicional -> <cond_if> <abre_p> <expressao> <fehca_p> <abre_c> <sequencia> <fecha_c> <cond_else> <abre_c> <sequencia> <fecha_c>\n");}
    ;
dec_rep: 
    rep abre_p dec_atr pvirg exp pvirg dec_atr fecha_p abre_c seq fecha_c                   {p = insere(p, "Dec_rep", 11); printf("Declaracao repeticao -> <rep> <abre_p> <atribuicao <pvirg> <expressao <pvirg> <atribuicao> <fehca_p> <abre_c> <sequencia> <fecha_c>\n");}
    | rep abre_p exp fecha_p abre_c seq fecha_c                                             {p = insere(p, "Dec_rep", 7); printf("Declaracao repeticao -> <rep> <abre_p> <expressao> <fehca_p> <abre_c> <sequencia> <fecha_c>\n");}
    ;
dec_atr:
    id sinal_atr exp                        {p = insere(p, "Atribuicao", 3); printf("Atribuicao -> <id> <sinal_atr> <expressao>\n");}
    | tipo id sinal_atr exp                 {p = insere(p, "Atribuicao", 4); printf("Atribuicao -> <tipo> <id> <sinal_atr> <expressao>\n");}
    | id sinal_atr                          {p = insere(p, "Atribuicao", 2); printf("Atribuicao -> <id> <sinal_atr>\n");}
    ; 
dec_lei:
    scan abre_p id fecha_p                  {p = insere(p, "Dec_lei", 4); printf("Leitura -> <scan> <abre_p> <id> <fecha_p>\n");}
    ;
dec_esc:    
    print abre_p exp fecha_p                {p = insere(p, "Dec_esc", 4); printf("Escrita -> <print> <abre_p> <expressao> )\n");}
    ;
dec_ret:
    ret exp                                 {p = insere(p, "Dec_ret", 2); printf("Declaracao retorno -> <ret> <expressao>\n");}
    ;
dec_imp:
    imp comp bib comp                       {p = insere(p, "Dec_imp", 4); printf("Declaracao importacao -> <imp> <comp> <bib> <comp>\n");}
    ;
dec_def:
    def id exp                              {p = insere(p, "Dec_def", 3); printf("Dec definicao -> <def> <id> <expressao>\n");}
    ;
exp:
    exp_simples comp exp_simples            {p = insere(p, "Exp", 3); printf("Expressao -> <exp_simples> <comparacao> <exp_simples>\n");}
    | exp_simples                           {p = insere(p, "Exp", 1); printf("Expressao -> <exp_simples>\n");}
    | exp_simples logic exp_simples         {p = insere(p, "Exp", 3); printf("Expressao -> <exp_simples> <logica> <exp_simples>\n");}
    ;
func:
    tipo id abre_p lista_parametros fecha_p abre_c seq fecha_c         {p = insere(p, "Func", 8); printf("Funcao -> <tipo> <id> <abre_p> <lista_parametros> <fehca_p <abre_c> <sequencia> <fecha_c>\n");}
    | tipo id abre_p fecha_p abre_c seq fecha_c                        {p = insere(p, "Func", 7); printf("Funcao -> <tipo> <id> <abre_p> <fehca_p <abre_c> <sequencia> <fecha_c>\n");}
    | tipo main abre_p fecha_p abre_c seq fecha_c                      {p = insere(p, "Func", 7); printf("Funcao -> <tipo> <main> <abre_p> <fehca_p> <abre_c> <sequencia> <fecha_c>\n");}
    ;
lista_parametros:
    parametro                                   {p = insere(p, "Lista_par", 1); printf("Lista_parametros -> <parametro>\n");}
    | parametro virgula lista_parametros        {p = insere(p, "Lista_par", 3); printf("Lista_parametros -> <lista_parametros> <virgula> <parametro>\n");}
    ;
parametro:
    tipo id                                     {p = insere(p, "Parametro", 2); printf("Parametro -> <tipo> <id>\n");}
    ;
exp_simples: 
    exp_simples soma termo      {p = insere(p, "Exp_S", 3); printf("Exp_simples -> <exp_simples> <soma> <termo>\n");}
    | termo                     {p = insere(p, "Exp_S", 1); printf("Exp_simples -> <termo>\n");}
    ;
termo:
    termo mult termo            {p = insere(p, "Termo", 3); printf("Termo -> <termo> <mult> <termo>\n");}
    | fator                     {p = insere(p, "Termo", 1); printf("Termo -> <fator>\n");}
    ;
fator:
    abre_p exp fecha_p          {p = insere(p, "Fator", 3); printf("Fator -> <abre_p> <expressao> )\n");}
    | numero                    {p = insere(p, "Fator", 1); printf("Fator -> <numero>\n");}
    | id                        {p = insere(p, "Fator", 1); printf("Fator -> <id>\n");}
    ;


rep:
    FOR_TOK                     {p = insere(p, $1, 0); p = insere(p, "Rep", 1);  printf("Repeticao -> %s\n", p->token->token);}
    | WHILE_TOK                 {p = insere(p, $1, 0); p = insere(p, "Rep", 1);  printf("Repeticao -> %s\n", p->token->token);}
    ;
sinal_atr:
    ATR_TOK                     {p = insere(p, $1, 0); p = insere(p, "Sinal", 1); printf("Sinal Atribuicao -> %s\n", p->token->token);}
    | INC_TOK                   {p = insere(p, $1, 0); p = insere(p, "Sinal", 1); printf("Sinal Atribuicao -> %s\n", p->token->token);}
    | DEC_TOK                   {p = insere(p, $1, 0); p = insere(p, "Sinal", 1); printf("Sinal Atribuicao -> %s\n", p->token->token);}
    | ATR_SM_TOK                {p = insere(p, $1, 0); p = insere(p, "Sinal", 1); printf("Sinal Atribuicao -> %s\n", p->token->token);}
    | ATR_DC_TOK                {p = insere(p, $1, 0); p = insere(p, "Sinal", 1); printf("Sinal Atribuicao -> %s\n", p->token->token);}
    | ATR_MT_TOK                {p = insere(p, $1, 0); p = insere(p, "Sinal", 1); printf("Sinal Atribuicao -> %s\n", p->token->token);}
    | ATR_DV_TOK                {p = insere(p, $1, 0); p = insere(p, "Sinal", 1); printf("Sinal Atribuicao -> %s\n", p->token->token);}
    | ATR_MD_TOK                {p = insere(p, $1, 0); p = insere(p, "Sinal", 1); printf("Sinal Atribuicao -> %s\n", p->token->token);}
    ;
comp:
    MEN_TOK                     {p = insere(p, $1, 0); p = insere(p, "Comp", 1); printf("Comparacao -> %s\n", p->token->token);}
    | IG_TOK                    {p = insere(p, $1, 0); p = insere(p, "Comp", 1); printf("Comparacao -> %s\n", p->token->token);}
    | MAI_TOK                   {p = insere(p, $1, 0); p = insere(p, "Comp", 1); printf("Comparacao -> %s\n", p->token->token);}
    | DIF_TOK                   {p = insere(p, $1, 0); p = insere(p, "Comp", 1); printf("Comparacao -> %s\n", p->token->token);}
    | MAI_IG_TOK                {p = insere(p, $1, 0); p = insere(p, "Comp", 1); printf("Comparacao -> %s\n", p->token->token);}
    | MEN_IG_TOK                {p = insere(p, $1, 0); p = insere(p, "Comp", 1); printf("Comparacao -> %s\n", p->token->token);}
    ;
mult:
    MULT_TOK                    {p = insere(p, $1, 0); p = insere(p, "Mult", 1); printf("Mult -> %s\n", p->token->token);}
    | DIV_TOK                   {p = insere(p, $1, 0); p = insere(p, "Mult", 1); printf("Mult -> %s\n", p->token->token);}
    ;
soma:
    MAIS_TOK                    {p = insere(p, $1, 0); p = insere(p, "Soma", 1); printf("Soma -> %s\n", p->token->token);}
    | MENOS_TOK                 {p = insere(p, $1, 0); p = insere(p, "Soma", 1); printf("Menos -> %s\n", p->token->token);}
    ;
numero:
    INTEIRO                     {p = insereInt(p, $1, 0); p = insere(p, "Num", 1); printf("Numero -> %s\n", p->token->token);}
    | REAL                      {p = insereDouble(p, $1, 0); p = insere(p, "Num", 1); printf("Numero -> %s\n", p->token->token);}
    ;
tipo:
    INT_TOK                     {p = insere(p, $1, 0); p = insere(p, "Tipo", 1); printf("Tipo -> %s\n", p->token->token);}
    | DOUBLE_TOK                {p = insere(p, $1, 0); p = insere(p, "Tipo", 1); printf("Tipo -> %s\n", p->token->token);}
    | CHAR_TOK                  {p = insere(p, $1, 0); p = insere(p, "Tipo", 1); printf("Tipo -> %s\n", p->token->token);}
    | FLOAT_TOK                 {p = insere(p, $1, 0); p = insere(p, "Tipo", 1); printf("Tipo -> %s\n", p->token->token);}
    | VOID_TOK                  {p = insere(p, $1, 0); p = insere(p, "Tipo", 1); printf("Tipo -> %s\n", p->token->token);}
    ;
logic:
    L_AND_TOK                   {p = insere(p, $1, 0); p = insere(p, "Logic", 1); printf("Logica -> %s\n", p->token->token);}
    | L_OR_TOK                  {p = insere(p, $1, 0); p = insere(p, "Logic", 1); printf("Logica -> %s\n", p->token->token);}
    | L_SHL_TOK                 {p = insere(p, $1, 0); p = insere(p, "Logic", 1); printf("Logica -> %s\n", p->token->token);}
    | L_SHR_TOK                 {p = insere(p, $1, 0); p = insere(p, "Logic", 1); printf("Logica -> %s\n", p->token->token);}
    ;
comm:
    COMENTARIO                  {p = insere(p, $1, 0); p = insere(p, "Comentario", 1); printf("Comentario -> %s\n", p->token->token);}
    ;
string:
    STRING                      {p = insere(p, $1, 0); p = insere(p, "String", 1); printf("String -> %s\n", p->token->token);}
    ;
id: 
    ID                          {p = insere(p, $1, 0); p = insere(p, "Id", 1); printf("Identificador -> %s\n", p->token->token);}
    ;
abre_p:
    A_PAR_TOK                   {p = insere(p, $1, 0); p = insere(p, "AbreP", 1); printf("Abre Parentese -> %s\n", p->token->token);}
    ;
fecha_p:
    F_PAR_TOK                   {p = insere(p, $1, 0); p = insere(p, "FechaP", 1); printf("Fecha Parentese -> %s\n", p->token->token);}
    ;
abre_c:
    A_CHA_TOK                   {p = insere(p, $1, 0); p = insere(p, "AbreC", 1); printf("Abre Chaves -> %s\n", p->token->token);}
    ;
fecha_c:
    F_CHA_TOK                   {p = insere(p, $1, 0); p = insere(p, "FechaC", 1); printf("Fecha Chaves -> %s\n", p->token->token);}
    ;
pvirg:
    PVIRG_TOK                   {p = insere(p, $1, 0); p = insere(p, "Pvirg", 1); printf("Ponto Virgula -> %s\n", p->token->token);}
    ;
main:
    MAIN_TOK                    {p = insere(p, $1, 0); p = insere(p, "Main", 1); printf("Main -> %s\n", p->token->token);}
    ;
cond_if:
    IF_TOK                      {p = insere(p, $1, 0); p = insere(p, "If", 1); printf("Cond if -> %s\n", p->token->token);}
    ;
cond_else:
    ELSE_TOK                    {p = insere(p, $1, 0); p = insere(p, "Else", 1); printf("Cond else -> %s\n", p->token->token);}
    ;
imp:
    IMPORT_TOK                  {p = insere(p, $1, 0); p = insere(p, "Importacao", 1); printf("Importacao -> %s\n", p->token->token);}
    ;
bib:
    BIB                         {p = insere(p, $1, 0); p = insere(p, "Biblioteca", 1); printf("Biblioteca -> %s\n", p->token->token);}
    ;
ret:
    RETURN_TOK                  {p = insere(p, $1, 0); p = insere(p, "Retorno", 1); printf("Retorno -> %s\n", p->token->token);}
    ;
def:
    DEFINE_TOK                  {p = insere(p, $1, 0); p = insere(p, "Define", 1); printf("Definicao -> %s\n", p->token->token);}
    ;
virgula:
    VIRG_TOK                    {p = insere(p, $1, 0); p = insere(p, "Virgula", 1); printf("Virgula -> %s\n", p->token->token);}
    ;
scan:
    SCAN_TOK                    {p = insere(p, $1, 0); p = insere(p, "Scan", 1); printf("Scan -> %s\n", p->token->token);}
    ;
print:
    PRINT_TOK                   {p = insere(p, $1, 0); p = insere(p, "Print", 1); printf("Print -> %s\n", p->token->token);}
    ;
%%

void yyerror(char *s){
    printf("erro na linha %d -> %s\n", linha, s);
}

int main(){	
    char str[50];
    int saida = 1;
    int opcao;
    FILE* arq;

    menu();
        
    do{
        printf("\n1 - Inserir arquivo de leitura\n");
        printf("2 - Imprimir tabela de palavras reservadas\n");
        printf("3 - Imprimir tabela de simbolos\n");
        printf("0 - Sair\n");

        scanf("%d", &opcao);
    
        switch(opcao) {
            case 1 : 
                h = limpaHash(h);
                simbolo = limpaHash(simbolo);
                h = criarHash(200);
                simbolo = criarHash(200);

                printf("\nDigite o nome do arquivo: ");
                scanf("%s", str);
                strcat(str, ".txt");

                arq = fopen(str, "r");
                while(arq == NULL){
                    printf("Digite o nome correto do arquivo: "); 
                    scanf("%s", str);
                    strcat(str, ".txt");
                    arq = fopen(str, "r");
                }
                yyin = arq;
                yyparse(); 
                break;
            case 2 :
                printf("TABELA DE PALAVRAS RESERVADAS\n"); 
                printf(" ______________________ _____________________ \n");
                imprimirHash(h);
                printf(" ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾ ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾ \n");
                break;
            case 3 : 
                printf("TABELA DE SIMBOLOS\n"); 
                printf(" ______________________ _____________________ \n");
                imprimirHash(simbolo);
                printf(" ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾ ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾ \n");
                break;
        }
        printf("Total de linhas: %d\n\n", linha);
        imprimirPorNivel("arvore.txt", p->token);
    } while(opcao != 0);

    fclose(arq);
    yyparse(); 
        
	return 0;
}