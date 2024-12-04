#ifndef HASH_H
#define HASH_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct no {
    char nome[100];
    char token [100];
    int linha;
    struct no *prox;
}Item;

typedef struct hash{
    int tam;
    Item **vet;
}Hash;

// Descrição: Exibe o menu principal do programa.
// Entrada: nenhuma
// Retorno: nenhum
// Pré-Condição: nenhuma
// Pós-Condição: exibe o menu na saída padrão
void menu();

// Descrição: Verifica se a lista está vazia.
// Entrada: ponteiro para o item da lista
// Retorno: 1 se a lista estiver vazia, 0 caso contrário
// Pré-Condição: item deve ser um ponteiro válido
// Pós-Condição: retorna se a lista está vazia ou não
int vazia(Item *item);

// Descrição: Calcula o valor hash de uma string.
// Entrada: h - ponteiro para a tabela hash, nome - string para calcular o hash
// Retorno: valor hash calculado
// Pré-Condição: h deve ser um ponteiro válido, nome deve ser uma string válida
// Pós-Condição: retorna o valor hash calculado
int hashing(Hash *h, char *nome);

// Descrição: Cria uma nova tabela hash.
// Entrada: tam - tamanho da tabela hash
// Retorno: ponteiro para a nova tabela hash
// Pré-Condição: tam deve ser um valor válido
// Pós-Condição: retorna a nova tabela hash criada
Hash *criarHash(int tam);

// Descrição: Insere um novo item na tabela hash.
// Entrada: ponteiro para a tabela hash, nome do item, token do item
// Retorno: nenhum
// Pré-Condição: h deve ser um ponteiro válido, nome e token devem ser strings válidas
// Pós-Condição: insere o novo item na tabela hash
void inserirHash(Hash *h, char *nome, char *token);

// Descrição: Insere um novo item na lista encadeada.
// Entrada: ponteiro para o item da lista, nome do item, token do item
// Retorno: ponteiro para o novo item da lista
// Pré-Condição: item deve ser um ponteiro válido, nome e token devem ser strings válidas
// Pós-Condição: insere o novo item na lista encadeada
Item *inserir(Item *item, char *nome, char *token);

// Descrição: Imprime os itens da lista encadeada.
// Entrada: item - ponteiro para o item da lista
// Retorno: nenhum
// Pré-Condição: item deve ser um ponteiro válido
// Pós-Condição: imprime os itens da lista encadeada
void imprimir(Item *item);

// Descrição: Imprime os itens da tabela hash.
// Entrada: ponteiro para a tabela hash
// Retorno: nenhum
// Pré-Condição: h deve ser um ponteiro válido
// Pós-Condição: imprime os itens da tabela hash
void imprimirHash(Hash *h);

// Descrição: Busca um item na lista encadeada.
// Entrada: ponteiro para o item da lista, string a ser buscada
// Retorno: ponteiro para o item encontrado ou NULL se não encontrado
// Pré-Condição: item deve ser um ponteiro válido, str deve ser uma string válida
// Pós-Condição: retorna o item encontrado ou NULL se não encontrado
Item *busca (Item *item, char* str);

// Descrição: Verifica se uma string contém caracteres inválidos.
// Entrada: string a ser verificada, número da linha onde ocorreu a verificação
// Retorno: 0 se não há erro, a posição do primeiro caractere inválido caso contrário
// Pré-Condição: str deve ser uma string válida, linha deve ser um número válido
// Pós-Condição: retorna a posição do primeiro caractere inválido ou 0 se não há erro
int verificaErro(char* str, int linha);

// Descrição: Libera a memória ocupada pela lista encadeada.
// Entrada: item - ponteiro para o item da lista
// Retorno: NULL
// Pré-Condição: item deve ser um ponteiro válido
// Pós-Condição: libera a memória ocupada pela lista encadeada
Item *limpa(Item *item);

// Descrição: Libera a memória ocupada pela tabela hash.
// Entrada: h - ponteiro para a tabela hash
// Retorno: NULL
// Pré-Condição: h deve ser um ponteiro válido
// Pós-Condição: libera a memória ocupada pela tabela hash
Hash *limpaHash(Hash *h);

#endif