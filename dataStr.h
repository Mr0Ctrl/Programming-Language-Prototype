#ifndef INFRASTRUCTURE_H
#define INFRASTRUCTURE_H

#include <stdbool.h>
#include <stdlib.h>


typedef enum
{
    tBool,
    tInt,
    tFloat,
    tChar
} typeEnum;

typedef struct
{
    typeEnum type;
    union
    {
        int ival;
        float fval;
        char cval;
        bool bval;
    } value;

} data;

#endif // INFRASTRUCTURE_H