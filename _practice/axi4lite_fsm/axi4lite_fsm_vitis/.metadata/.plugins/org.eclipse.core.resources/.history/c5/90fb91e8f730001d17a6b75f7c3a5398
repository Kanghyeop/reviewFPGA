#include <stdio.h>
#include "xparameters.h"
#include "xil_io.h"

#define WRITE 1
#define READ 2
#define AXI_DATA_BYTE 4 // 32bits

#define IDLE 1
#define RUN 1 << 1
#define DONE 1 << 2

#define CTRL_REG 0
#define STATUS_REG 1

int main() {
	int data;
	int read_data;
	int reg_num;

	while(1){
		printf("======= Program Run ======\n");
		printf("plz input run mode\n");
		printf("1. write (CTRL) \n");
		printf("2. read (REG) \n");
		scanf("%d",&data);

		if(data == WRITE){
			// clear CTRL_REG
			printf("[w]clear CTRL_REG \n");
			Xil_Out32((XPAR_TOP_0_BASEADDR) + (CTRL_REG*AXI_DATA_BYTE), (u32)(0x00000000));
			// get input
			printf("plz input Value ~31bit.\n");
			scanf("%d",&data);
			// check is IDLE
			printf("[w]check is IDLE \n");
			do {
				read_data = Xil_In32((XPAR_TOP_0_BASEADDR) + (STATUS_REG*AXI_DATA_BYTE));
			} while ((read_data & IDLE) != IDLE);
			// start core
			printf("[w]start core \n");
			Xil_Out32((XPAR_TOP_0_BASEADDR) + (CTRL_REG*AXI_DATA_BYTE), (u32)(data | 0x80000000));
			// check is DONE
			printf("[w]check is DONE \n");
			do{
				read_data = Xil_In32((XPAR_TOP_0_BASEADDR) + (STATUS_REG*AXI_DATA_BYTE));
			} while( (read_data & DONE) != DONE );
			printf("[w]write finished. \n");
		}

		else if(data == READ){
			printf("plz input READ reg number (0~1)\n");
			scanf("%d",&reg_num);
			read_data = Xil_In32((XPAR_TOP_0_BASEADDR) + (reg_num*AXI_DATA_BYTE));
			printf("reg_number (%d), value : %d\n", reg_num, read_data & 0x7FFFFFFF);
		}

	}
}
