#include <stdbool.h>

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
} Data;