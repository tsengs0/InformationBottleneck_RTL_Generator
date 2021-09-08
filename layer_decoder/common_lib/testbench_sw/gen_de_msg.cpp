#include <iostream>
#include <fstream>
#include <cstdlib>
#include <cstdio>
#include <ctime>
#include <cmath>
using namespace std;

#define MAX_GEN 16
#define CN_DEGREE 10
#define QUAN_SIZE 4
#define QUAN_RANGE 3

int msg_pattern[CN_DEGREE];
void decimal2bin(int dec, char *bin_txt);
void rvereseArray(char *arr, int start, int end);

int main(int argc, char **argv)
{
	srand(time(0));
	ofstream genFile, genFileCSV;
	char *msg_bin;
	int msg_max;

	msg_bin = new char[QUAN_SIZE];
	msg_max = pow(2.0, (double) QUAN_RANGE);
	genFile.open("v2cIn_msg.mem");
	genFileCSV.open("v2cIn_msg.csv");

	for(int i = 0; i < (int) MAX_GEN; i++) {
		for(int j = 0; j < (int) CN_DEGREE; j++) {
			msg_pattern[j] = rand() % msg_max;		
			decimal2bin(msg_pattern[j], msg_bin);	
			genFile << hex << msg_pattern[j];
			genFileCSV << hex << msg_pattern[j];
			cout << msg_bin;
			if(j != CN_DEGREE-1) {
				genFile << " ";
				genFileCSV << ",";
				cout << " ";
			}
		}
		genFile << endl;
		genFileCSV << endl;
		cout << endl;
	}

	delete [] msg_bin;
	genFile.close(); genFileCSV.close();
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
