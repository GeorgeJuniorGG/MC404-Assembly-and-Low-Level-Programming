/*
  Self Driving Car Application Programming Interface
*/
#ifndef API_CAR_H
#define API_CAR_H
/******************************************************************************/
/*  MOTORES                                                                   */
/******************************************************************************/

/*
  Define os valores para o deslocamento vertical e horizontal do carro.
  Paramêtros:
  * vertical:   um byte que define o deslocamento vertical, entre -1 e 1.
                Valor -1 faz o carro andar para trás e 1 para frente
  * horizontal: define o valor para o deslocamento horizontal, entre -127 e 127.
                Valores negativos gera deslocamento para a direita e positivos
                para a esquerda.
  Retorna:
  * 0 em caso de sucesso.
  * -1 caso algum parametro esteja fora de seu intervalo.
*/
int set_motor(char vertical, char horizontal);


/*
  Aciona o freio de mão do carro.
  Paramêtros:
  * valor:  um byte que define se o freio será acionado ou não.
            1 para acionar o freio e 0 para não acionar.
  Retorna:
  * 0 em caso de sucesso.
  * -1 caso algum parametro esteja fora de seu intervalo .
*/
int set_handbreak(char valor);


/******************************************************************************/
/*  SENSORES                                                                  */
/******************************************************************************/

/*
  Lê os valores do sensor ultrasônico.
  Paramêtros:
  * sensor_values:  endereço de um vetor de 256 elementos que armazenará os
                    valores lidos do sensor ultrasônico.
  Retorna:
    Nada
*/
void read_sensors(unsigned char* sensor_values);


/*
  Lê a distancia do sensor ultrasônico
  Paramêtros:
    Nenhum
  Retorna:
    O inteiro com a distância do sensor, em centímetros.
*/
int read_sensor_distance(void);


/*
  Lê a posição aproximada do carro usano um dispositivo de GPS
  Parametros:
  * x:  endereço da variável que armazenará o valor da posição x
  * y:  endereço da variável que armazenará o valor da posição y
  * z:  endereço da variável que armazenará o valor da posição z
  Retorna:
    Nada
*/
void get_position(int* x, int* y, int* z);


/*
  Lê a rotação global do dispositivo de giroscópio
  Parametros:
  * x:  endereço da variável que armazenará o valor do angulo de Euler em x
  * y:  endereço da variável que armazenará o valor do angulo de Euler em y
  * z:  endereço da variável que armazenará o valor do angulo de Euler em z
  Retorna:
    Nada
*/
void get_rotation(int* x, int* y, int* z);


/******************************************************************************/
/*  TIMER                                                                     */
/******************************************************************************/

/*
  Lê o tempo do sistema
  Paramêtros:
    Nenhum
  Retorna:
    O tempo do sistema, em milisegundos.
*/
unsigned int get_time(void);
#endif  /* API_CAR_H */
