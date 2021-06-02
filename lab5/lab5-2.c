#include <stdio.h>
#include <time.h>
#define STB_IMAGE_IMPLEMENTATION
#include "stb_image.h"
#define STB_IMAGE_WRITE_IMPLEMENTATION
#include "stb_image_write.h"
unsigned char* Processasm(unsigned char* data, int x, int y, int n, int new_x, int new_y);
unsigned char* process_image(unsigned char* data, int x, int y, int n,int new_x, int new_y){
	int i, j;
	float k1=((float)x)/new_x; float k2=((float)y)/new_y;
	//printf("%.2f, %.2f\n", k1, k2);
	unsigned char* data2 = (unsigned char*)malloc(sizeof(unsigned char*)*new_x*new_y*n);
	for ( i = 0; i<new_y; i++){
		for ( j = 0; j<new_x*n; j++){
			int l, m, p;
			float L = k1*j; l = L;
			float M = i*k2; m = M;
			while (l%n!=0)
				l+=1;
			//data2[i*new_x+j] = data[m*new_x+j];
			for(p = 0; p<n; p++){
				data2[i*new_x*n+j]=data[m*x*n+l+p];
				j+=1;
			}
			j-=1;
			/*data2[i*new_x*n+j] = data[m*x*n+l+1];
			j+=1;
			data2[i*new_x*n+j] = data[m*x*n+l+2];
			j+=1;
			data2[i*new_x*n+j] = data[m*x*n+l+3];
		*/}
	}
	return data2;
}
int main(int argc, char* argv[]){
	if (argc <3){
		printf("run program with ./program_name input_filename output_filename\n");
		return 0;
	}
	int x, y, n;
	unsigned char* data = stbi_load(argv[1], &x, &y, &n, 0);
//	printf("%d\n", length(data));
	if (data == NULL){
		printf("couldn't find your image\n");
		return 1;
	}
	int new_x, new_y;
	printf ("Input new x\n");
	scanf("%d", &new_x);
	while (new_x%n!=0)
		new_x+=1;
	printf("Input new y\n");
	scanf("%d", &new_y);
	int start = clock();
	unsigned char* data2 =process_image(data, x, y, n,new_x, new_y);
	int fin = clock();
	int res = fin - start;
	printf("c time: %.4f\n", ((float)res)/CLOCKS_PER_SEC);
	if (data2 == NULL){
		printf("problems with C function\n");
		return 0;
	}
	stbi_write_png(argv[2], new_x, new_y, n, data2, new_x*n);
	start = clock();
	unsigned char* data3 = Processasm(data, x, y, n, new_x, new_y);
	fin = clock();
	res = fin - start;
	printf("asm time: %.4f\n", ((float)res)/CLOCKS_PER_SEC);
	if (data3 == NULL){
		printf("Problems with asm function\n");
		return 0;
	}
	stbi_write_png(argv[3], new_x, new_y, n, data3, new_x*n);
	return 0;
}
