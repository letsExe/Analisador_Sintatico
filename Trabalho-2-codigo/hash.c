#include "hash.h"


// Descrição: Exibe o menu principal do programa.
// Pré-Condição: nenhuma
// Pós-Condição: exibe o menu na saída padrão
void menu(){
   printf("       __           _       __   ______         \n");
   printf("      / /___ _   __(_)___ _/ /  / ____/__    __ \n");
   printf(" __  / / __ \\ | / / / __ `/ /  / /  __/ /___/ /_\n");
   printf("/ /_/ / /_/ / |/ / / /_/ / /  / /__/_  __/_  __/\n");
   printf("\\____/\\____/|___/_/\\__,_/_/   \\____//_/   /_/   \n");
   printf("                                                \n");
}

// Descrição: Verifica se a lista está vazia.
// Pré-Condição: item deve ser um ponteiro válido
// Pós-Condição: retorna se a lista está vazia ou não
int vazia(Item *item){
   return (item == NULL);
}

// Descrição: Calcula o valor hash de uma string.
// Pré-Condição: h deve ser um ponteiro válido, nome deve ser uma string válida
// Pós-Condição: retorna o valor hash calculado
int hashing(Hash *h, char *nome){
   int t = 0;

   for(int i = 0; nome[i]; i++){
      t += (int) nome[i];
   }
   return t%h->tam;
}

// Descrição: Cria uma nova tabela hash.
// Pré-Condição: tam deve ser um valor válido
// Pós-Condição: retorna a nova tabela hash criada
Hash *criarHash(int tam){
   Hash *h = (Hash*) malloc (sizeof(Hash));
   h->tam = tam;
   h->vet = (Item**) malloc (sizeof(Item*)*tam);
   for(int i = 0; i < tam; i++){
      h->vet[i] = NULL;
   }
   return h;
}

// Descrição: Insere um novo item na tabela hash.
// Pré-Condição: h deve ser um ponteiro válido, nome e token devem ser strings válidas
// Pós-Condição: insere o novo item na tabela hash
void inserirHash(Hash *h, char *nome, char *token){
   int key = hashing(h, nome);
   h->vet[key] = inserir(h->vet[key], nome, token);
}

// Descrição: Insere um novo item na lista encadeada.
// Pré-Condição: item deve ser um ponteiro válido, nome e token devem ser strings válidas
// Pós-Condição: insere o novo item na lista encadeada
Item *inserir(Item *item, char *nome, char *token){
   if(busca(item, nome) == NULL){
      Item *aux = (Item *)malloc(sizeof(Item));

      strcpy(aux->nome, nome);
      strcpy(aux->token, token);

      aux->prox = item;      
      return aux;
   }
   return item;
}

// Descrição: Busca um item na lista encadeada.
// Pré-Condição: item deve ser um ponteiro válido, str deve ser uma string válida
// Pós-Condição: retorna o item encontrado ou NULL se não encontrado
Item *busca (Item *item, char* str){
   Item *aux = item;
   for(; aux != NULL; aux = aux->prox){
      if(strcmp(aux->nome, str) == 0) return aux;
   }
   return aux;
}

// Descrição: Imprime os itens da lista encadeada.
// Pré-Condição: item deve ser um ponteiro válido
// Pós-Condição: imprime os itens da lista encadeada
void imprimir(Item *item){
   if(vazia(item)){
      return;
   } else {
      imprimir(item->prox);
      printf("| %-20s |", item->token);
      printf("%20s |\n", item->nome);
   }
}

// Descrição: Imprime os itens da tabela hash.
// Pré-Condição: h deve ser um ponteiro válido
// Pós-Condição: imprime os itens da tabela hash
void imprimirHash(Hash *h){
   for(int i = 0; i < h->tam; i++){
      imprimir(h->vet[i]);
   }
}

// Descrição: Verifica se uma string contém caracteres inválidos.
// Pré-Condição: str deve ser uma string válida, linha deve ser um número válido
// Pós-Condição: retorna a posição do primeiro caractere inválido ou 0 se não há erro
int verificaErro(char* str, int linha){
   char erro[] = "@$¨~çÇ§¹²³£¢¬₢°`";
   int pos = strcspn(str, erro);
   if(pos == strlen(str)){
      return 0;
   }else{
      printf("\n\tERRO NA LINHA %d CARACTER %d: %s\n\n", linha, pos+1, str);
      return pos;
   }
}

// Descrição: Libera a memória ocupada pela lista encadeada.
// Pré-Condição: item deve ser um ponteiro válido
// Pós-Condição: libera a memória ocupada pela lista encadeada
Item *limpa(Item *item){
   if(!vazia(item)){
      item->prox = limpa(item->prox);
      free(item);
   }
   return NULL;
}

// Descrição: Libera a memória ocupada pela tabela hash.
// Pré-Condição: h deve ser um ponteiro válido
// Pós-Condição: libera a memória ocupada pela tabela hash
Hash *limpaHash(Hash *h){
   if(h != NULL){
      for(int i = 0; i < h->tam; i++){
         h->vet[i] = limpa(h->vet[i]);
      }
      free(h);
   }
   return NULL;
}