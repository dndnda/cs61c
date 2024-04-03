#include <stddef.h>
#include "ll_cycle.h"

int ll_has_cycle(node *head)
{
    /* your code here */
    node *first = head;
    node *second = head;

    while (1)
    {
        if (!second || !second->next)
        {
            return 0;
        }
        second = second->next->next;
        first = first->next;
        if (first == second)
        {
            return 1;
        }
    }
    return 0;
}