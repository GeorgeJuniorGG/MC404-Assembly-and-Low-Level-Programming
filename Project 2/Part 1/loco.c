#include "api_car.h"

// Implemente aqui a lógica de controle do carro, utilizando as funções da api

void user_code(void) {
    int tempo = get_time();

    int cinza_Min = 110;
    int cinza_Max = 150;

    while (1 == 1) {
        if(get_time() - 100 >= tempo) {
            tempo = get_time();
            
            unsigned char* faixas;
            read_sensors(faixas);

            int direita = 0;
            int esquerda = 0;
            int time = get_time();
            int contDir = 0;
            int contEsq = 0;

            for (int i = 1; i < 120; i++) {
                if(faixas[128 - i] >= cinza_Min && faixas[128 - i] <= cinza_Max && contEsq < 24) {
                    esquerda = i;
                    contEsq = 0;
                }
                else {
                    contEsq ++;
                }
                if(faixas[128 + i] >= cinza_Min && faixas[128 + i] <= cinza_Max && contDir < 24) {
                    direita = i;
                    contDir = 0;
                }
                else {
                    contDir ++;
                }
            }
            if (direita == esquerda) {
                set_motor(1, 0);
            }
            else if (direita > esquerda) {
                set_motor(1, 33);
            }
            else {
                set_motor(1, -33);
            }

            get_time();
            get_time();

            set_handbreak(1);

            while(1 == 1) {
                if(get_time() - 530 >= time) {
                    break;
                }
            }
            
            set_handbreak(0);
        }
    }
}
