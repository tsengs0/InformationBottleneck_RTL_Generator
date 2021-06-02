#include <iostream>
#include <fstream>
#include <cstdlib>
#include <cstdio>
#include <ctime>
#include <cmath>
using namespace std;

#define MAX_GEN 16
#define CN_DEGREE 8
#define QUAN_SIZE 4
#define QUAN_RANGE 3

int msg_pattern[CN_DEGREE];
void decimal2bin(int dec, char *bin_txt);
void rvereseArray(char *arr, int start, int end);

int main(int argc, char **argv)
{
	srand(time(0));
	ofstream genFile;
	char *msg_bin;
	int msg_max;

	msg_bin = new char[QUAN_SIZE];
	msg_max = pow(2.0, (double) QUAN_RANGE);
	genFile.open("in_msg.txt");

	for(int i = 0; i < (int) MAX_GEN; i++) {
		for(int j = 0; j < (int) CN_DEGREE; j++) {
			msg_pattern[j] = rand() % msg_max;		
			decimal2bin(msg_pattern[j], msg_bin);	
			genFile << msg_bin << endl;	
			cout << msg_bin << " ";
		}
		cout << endl;
	}

	delete [] msg_bin;
	return 0;
}

void decimal2bin(int dec, char *bin_txt)
{
	bin_txt[QUAN_SIZE-1] = '0';
	for (int i = QUAN_RANGE-1; i>=0; i--) { 
		bin_txt[i] = (dec & (1 << i)) ? '1' : '0'; 
	} 
	rvereseArray(bin_txt, 0, QUAN_SIZE-1); 
}

/* Function to reverse arr[] from start to end*/
void rvereseArray(char *arr, int start, int end) 
{ 
    while (start < end) 
    { 
        int temp = arr[start];  
        arr[start] = arr[end]; 
        arr[end] = temp; 
        start++; 
        end--; 
    }  
} 
