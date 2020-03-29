#include <nds.h>
#include <stdio.h>


volatile int frame = 0;

extern "C" {float multiply(float x, float y);}
extern float multiply(float x, float y);

//---------------------------------------------------------------------------------
void Vblank() {
//---------------------------------------------------------------------------------
	frame++;
}
	
//---------------------------------------------------------------------------------
int main(void) {
//---------------------------------------------------------------------------------
	touchPosition touchXY;

	irqSet(IRQ_VBLANK, Vblank);

	consoleDemoInit();

	printf("ARM Floating Point algorithm\n");
	printf("By: Pedro Javier Fdez - 2I\n\n");
 
	unsigned int a = 0xC1900000;
        float A = *((float*)&a);

	unsigned int b = 0x41180000;
        float B = *((float*)&b);
        printf("Multiplying %.3f times %.3f \n",A,B);

	float result = multiply(A,B);

	printf("\n\n RESULT: %.3f",result);

	while(1) {
	
		swiWaitForVBlank();
		scanKeys();
		int keys = keysDown();
		if (keys & KEY_START) break;


	}

	return 0;
}
