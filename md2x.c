#include <stdio.h>

int main( int argc, char *argv[] )  
{


	char command[100] = {0};
	sprintf(command,"bash /home/keith/projects/md2x/md2x.sh %s %s","","");
	system(command);


}

