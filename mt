/NS-cars_sol.c/
#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <semaphore.h>
​
int main(int argc, char *argv[])
{
    int i,car=0, loop=3;
    sem_t *ns, *ew;
    ns = sem_open("ns", O_CREAT,0666,1);
    ew = sem_open("ew", O_CREAT, 0666, 0);
    for(i=0;i<loop;i++){
        sem_wait(ns);
        printf("Semaphore: The road from north to south is open\n");
        sleep(1);
        printf("NS-Car: car %d passed\n",car++);
        sem_post(ew);
    }
    printf("NS: Time is up. %d cars passed.\n",car);
​
    sem_close(ns);
    sem_close(ew);
    sem_unlink("ns");
    sem_unlink("ew");
​
    return 0;
}

/EW-cars_sol.c/
#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <semaphore.h>

int main(int argc, char *argv[])
{
    int i,car=0, loop=3;
    sem_t *ns, *ew;

    ns = sem_open("ns", O_CREAT,0666,1);
    ew = sem_open("ew", O_CREAT, 0666, 0);
    for(i=0;i<loop;i++){
        sem_wait(ew);
        printf("Semaphore: The road from east to west is open\n");
        sleep(rand()%2+1);
        printf("EW-Car: car %d passed\n",car++);
        sem_post(ns);
    }
    printf("EW: Time is up. %d cars passed.\n",car);

    sem_close(ns);
    sem_close(ew);
    sem_unlink("ns");
    sem_unlink("ew");

    return 0;
}

to compile the programs, 
gcc -o EW-cars EW-cars.c
gcc -o NS-cars NS-cars.c

nano run_both.sh
chmod +x filename
./filename

adhula idhu add pannanum

#!/bin/bash

./EW-cars & # Run the first program in the background
pid1=$!

./NS-cars   # Run the second program

# Wait for the background process to finish
wait $pid1

echo "Both programs have finished running."
